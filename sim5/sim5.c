#include <stdio.h>
#include "sim5.h"
#include "sim5_test_commonCode.h"

/*
* retrives and sets the instructionField being used for the CPU
*/
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut){

    //opCode are the binary numbers of 31-26
    fieldsOut -> opcode = ((instruction >> 26)  & 0x3f);

    // set register1  from instruction bits 25-21
    fieldsOut -> rs = ((instruction >> 21) & 0x1f);

    // set register2 from instruction bits 20-16
    fieldsOut -> rt = ((instruction >> 16) & 0x1f);

    // set registDestination from instruction bits 15- 11
    fieldsOut -> rd = ((instruction >> 11) & 0x1f);

    //set shifting from instruction bits 10-6
    fieldsOut -> shamt = ((instruction>> 6) & 0x1f);

    // set function from instruction bits 5-0
    fieldsOut -> funct = ((instruction & 0x3f));
    //push by 16 bits
    fieldsOut -> imm16  = (instruction & 0xffff);
    //push by 32 bits
    fieldsOut -> imm32 = signExtend16to32(fieldsOut -> imm16);
    // set the address for the calculated result
    fieldsOut -> address = (instruction & 0x3ffffff);
        

}

/*
Ensures if a stall is called in mips, that is it's either a lw or sw instruction being stalled
that the stalling will work properly.
*/

int IDtoIF_get_stall(InstructionFields *fields, ID_EX  *old_idex, EX_MEM *old_exmem)
{

if(fields ->opcode == 43){
	if(old_exmem->regWrite){
		if(fields->rs == old_exmem->writeReg && fields ->rs !=0){
			if(old_idex ->regDst){
				return 1;
			}
		}else if(fields ->rs != old_idex -> rt){
			return 1;
		}
			
		if(fields ->rt == old_exmem ->writeReg && fields ->rt !=0){
			if(old_idex->regDst){
				if(fields ->rt != old_idex ->rd){
					return 1;
				}
			}else if(fields->rt != old_idex ->rt){
				return 1;
			}
		}
		return 0;

	}
	}
	if(old_idex ->memRead){
		if(old_idex-> rt == fields ->rs || (fields ->opcode == 0 && old_idex ->rt == fields ->rt)){
			return 1;
		}
	}
	if(old_exmem -> memRead){
		if(old_exmem -> writeReg == fields ->rs || (fields -> opcode == 0 && old_exmem -> writeReg == fields ->rt)){
			return 1;
		}
	}
	return 0;

}

/*
Asks the ID phase and will properly preform a jump or branch instructions which can be seen 
and given from is opcode from the parameter fields.
# fields -> opcode -> 4 == BEQ
# fields -> opcode -> 5 == BNE
# fields -> opcode -> 2 == J

*/
int IDtoIF_get_branchControl(InstructionFields *fields, WORD rsVal, WORD rtVal)
{

	
	//  Return 1 if operation is beq and true 
	//  Return 1 if operation is bne and true
	if ((fields -> opcode == 5 && rsVal != rtVal) || 
	    (fields -> opcode == 4 && rsVal == rtVal)) {
		    return 1; 
	}

	// Return 2 if jump is called so we are jumping 
	if (fields -> opcode == 2) {
		return 2; 
	}

	// Otherwise we return 0
	return 0; 
}



WORD calc_branchAddr(WORD pcPlus4, InstructionFields *fields){

    WORD branchAdder = (fields -> imm32 << 2) +  pcPlus4;
    return branchAdder;
}
WORD calc_jumpAddr  (WORD pcPlus4, InstructionFields *fields){
    WORD jumpAddr = (fields -> address << 2) | ((pcPlus4 >> 28) << 28);
    return jumpAddr;
}

/*
*Retrieves and sets all the values need for the excute field
*which shall set all values and set all the control needed based
* on each instruction that is called for the exectue phase
*/

int execute_ID(int IDstall, InstructionFields *fieldsIn, WORD pcPlus4, 
		WORD rsVal, WORD rtVal, ID_EX *new_idex)
{
	// Set all values that we know will be the same: 
	new_idex -> rs    = fieldsIn -> rs; 
	new_idex -> rt    = fieldsIn -> rt; 
	new_idex -> rd    = fieldsIn -> rd; 
	new_idex -> rsVal = rsVal;
	new_idex -> rtVal = rtVal;
	new_idex -> imm16 = fieldsIn -> imm16; 
	new_idex -> imm32 = fieldsIn -> imm32; 
	
	WORD opcode = fieldsIn -> opcode; 
	WORD funct = fieldsIn -> funct;
	
	// Set to zero initially to save code space. 
	new_idex -> extra1      = 0;
	new_idex -> extra2      = 0; 
	new_idex -> extra3      = 0;
    new_idex -> ALUsrc      = 0; 
	new_idex -> ALU.bNegate = 0;
	new_idex -> ALU.op      = 0; 
	new_idex -> memRead     = 0;
	new_idex -> memWrite    = 0; 
	new_idex -> memToReg    = 0;
	new_idex -> regDst      = 0;
	new_idex -> regWrite    = 0; 	

	// First we check if we have a stall 
	if (IDstall) {
		setStall(new_idex);
		return 1; 
	}

	// add funct = 32 && addu funct = 33
	else if (opcode == 0 && (funct == 32 || funct == 33)) {
		new_idex -> ALU.op   = 2;
		new_idex -> regDst   = 1;
		new_idex -> regWrite = 1;
		return 1;
	}

	// sub funct = 34 && subu funct == 35
	else if (opcode == 0 && (funct == 34 || funct == 35)) {
		new_idex -> ALU.bNegate = 1; 
		new_idex -> ALU.op      = 2; 
		new_idex -> regDst      = 1; 
		new_idex -> regWrite    = 1; 
		return 1;
	}
	// and funct = 36
	else if (opcode == 0 && funct == 36) {
		new_idex -> regDst   = 1; 
		new_idex -> regWrite = 1;
		return 1;
	}

	// or funct = 37
	else if (opcode == 0 && funct == 37) {
	       new_idex -> ALU.op   = 1; 
	       new_idex -> regDst   = 1; 
	       new_idex -> regWrite = 1;
	       return 1;
	}

	// xor funct = 38
	else if (opcode == 0 && funct == 38) {
		new_idex -> ALU.op   = 4; 
		new_idex -> regWrite = 1;
		new_idex -> regDst   = 1;
		return 1;
	}

	// nor funct = 39
	else if (opcode == 0 && funct == 39) {
		new_idex -> ALU.op   = 1;
		new_idex -> regDst   = 1;
		new_idex -> regWrite = 1; 
		new_idex -> extra1   = 1; 
		return 1;
	}

	// slt funct = 42
	else if (opcode == 0 && funct == 42) {
		new_idex -> ALU.bNegate = 1; 
		new_idex -> ALU.op      = 3; 
		new_idex -> regDst      = 1;
		new_idex -> regWrite    = 1; 
		return 1;
	}
	// addi opcode = 8 && addiu opcode = 9 
	else if (opcode == 8 || opcode == 9) { 
		new_idex -> ALUsrc   = 1;	
		new_idex -> ALU.op   = 2; 
		new_idex -> regWrite = 1;	
		return 1;
	}



	// stli opcode = 10
	else if (opcode == 10) {
		new_idex -> ALUsrc      = 1; 
		new_idex -> ALU.bNegate = 1;
	        new_idex -> ALU.op      = 3; 
		new_idex -> regWrite    = 1;	
		return 1;
	}

	// lw opcode = 35
	else if (opcode == 35) {
		new_idex -> ALUsrc   = 1; 
		new_idex -> ALU.op   = 2; 
		new_idex -> memRead  = 1;
		new_idex -> memToReg = 1;
		new_idex -> regWrite = 1; 
		return 1; 
	}

	// sw opcode = 43
	else if (opcode == 43) {
		new_idex -> ALUsrc   = 1; 
		new_idex -> ALU.op   = 2;
		new_idex -> memWrite = 1;
		return 1; 
	}

	// beq opcode = 4
	else if (opcode == 4) {
		new_idex -> rs    = 0; 
		new_idex -> rt    = 0; 
		new_idex -> rd    = 0;
		new_idex -> rsVal = 0;
		new_idex -> rtVal = 0;
		return 1; 
	}

	// bne opcode = 5
	else if (opcode == 5) {
		new_idex -> extra1 = 1; 
		new_idex -> rs     = 0;
		new_idex -> rt     = 0; 
		new_idex -> rd     = 0; 
		new_idex -> rsVal  = 0;
		new_idex -> rtVal  = 0;
		return 1;
	}

	// j opcde = 2
	else if (opcode == 2) {
		new_idex -> rs    = 0; 
		new_idex -> rt    = 0;
		new_idex -> rd    = 0; 
		new_idex -> rsVal = 0;
		new_idex -> rtVal = 0;
		return 1; 
	}

	// andi opcode = 12
	else if (opcode == 12) {
		new_idex -> ALUsrc = 2;
		new_idex -> regWrite = 1;
		return 1; 
	}

	// ori opcode = 13
	else if (opcode == 13) {
		new_idex -> ALUsrc   = 2;
		new_idex -> ALU.op   = 1;
		new_idex -> regWrite = 1;
		return 1; 
	}

	// lui opcode = 15
	else if (opcode == 15) {
		new_idex -> ALUsrc   = 2; 
		new_idex -> ALU.op   = 4; 
		new_idex -> regWrite = 1;
		new_idex -> extra2   = 1; 
		return 1; 
	}

	// nop opcode & funct = 0
	else if (opcode == 0 && funct == 0) {
		new_idex -> ALU.op   = 5; 
		new_idex -> regDst   = 1;
		new_idex -> regWrite = 1;
		new_idex -> rs       = 0;
		new_idex -> rt       = 0;
		new_idex -> rd       = 0;
		new_idex -> rsVal    = 0;
		new_idex -> imm16    = 0;
		new_idex -> imm32    = 0; 
		return 1; 
	}

	// If we get here then we did not reach a 
	// opcode/function that was valid. 
	return 0; 
}

/*
 * A Helper function called from execute_ID to set a stall. 
 *
 * no return. 
 */
void setStall(ID_EX *new_idex){
	new_idex -> rs          = 0;
	new_idex -> rt          = 0;
	new_idex -> rd          = 0;
	new_idex -> rsVal       = 0;
	new_idex -> rtVal       = 0;
	new_idex -> memRead     = 0; 
	new_idex -> memWrite    = 0;
	new_idex -> memToReg    = 0;
	new_idex -> regDst      = 0;
	new_idex -> regWrite    = 0;
	new_idex -> extra1      = 0;
	new_idex -> extra2      = 0;
	new_idex -> extra3      = 0;
	new_idex -> imm16       = 0;
	new_idex -> imm32       = 0;
	new_idex -> ALUsrc      = 0;
	new_idex -> ALU.op      = 0;
	new_idex -> ALU.bNegate = 0;
}

/*
This function will return the value which is  delivered to input1 of the ALU.
ID_EX the current instruction decoding execution 
EX_MEM is the old result ofthe alu
MEM_WB is the wirte back register of the old value
*/
WORD EX_getALUinput1(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb){
    // checks to see if the MEM from the previous instruction if any
    // had data in either in the regWrite or the writeReg that can be used to call upon
    // for the rs instruction if it's dependent on the value for input1
     
	if (old_exMem -> regWrite && old_exMem -> writeReg == in -> rs) 
	{
		return old_exMem -> aluResult; 
	}

    // checks to see if the WB from the previous instruction if any
    // had data in either in the regWrite or the writeReg that can be used to call upon
    // for the rs instruction if it's dependent on the value for input1
	if (old_memWb -> regWrite && old_memWb -> writeReg == in -> rs){
		return old_memWb -> aluResult; 
	}

    return in -> rsVal;
}

/*
Ex_getALUinput2 set verifies and retrieves previous instructions. It now adds
checks for the rt field and the immediate field. This ensures proper access to
specific parts of the code for ALU execution, utilizing the correct registers efficiently.
*/
WORD EX_getALUinput2(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb){
    if(in -> ALUsrc == 1){
        return in ->imm32;
    }
    if(in ->ALUsrc ==2){
        return in ->imm16;
    }
    if(old_exMem -> regWrite && old_exMem -> writeReg == in ->rt){
        return old_exMem ->aluResult;
    }
    if(old_memWb -> regWrite && old_memWb -> writeReg == in -> rt){
        return old_memWb -> aluResult;
    }
    return in -> rtVal;
}
/*
Execute clock cycle in the pipeline does the exact same thing as the
ALU execute
*/
void execute_EX(ID_EX *in, WORD input1, WORD input2, EX_MEM *new_exMem)
{	
	// First thing we can copy all the rest of the values to our 
	// next pipeline register. 
	
	new_exMem -> rt        = in -> rt; 
	new_exMem -> rtVal     = in -> rtVal; 
	new_exMem -> regWrite  = in -> regWrite; 
	new_exMem -> aluResult = 0;
	new_exMem -> extra1    = in -> extra1; 
	new_exMem -> extra2    = in -> extra2;
	new_exMem -> extra3    = in -> extra3;
	new_exMem -> memToReg  = in -> memToReg;
	new_exMem -> memRead   = in -> memRead; 
	new_exMem -> memWrite  = in -> memWrite; 

	// Next we start off by seeing what type of format so we can see 
	// what register we need to write to. 
	if (in -> ALUsrc == 1) {
		new_exMem -> writeReg = in -> rt; 
	} else {
		if (in -> ALUsrc == 2) {
			new_exMem -> writeReg = in -> rt;
		} else {
			new_exMem -> writeReg = in -> rd; 
		}
	}

	// lui is our extra 2.
	if (in -> extra2) {
		new_exMem -> aluResult = in -> imm16 << 16; 
		return; 
	}

	// Now we check if operation is 3 to set result less than. 
	if (in -> ALU.op == 3) {
		new_exMem -> aluResult = input1 < input2; 
	}

	// If operation is not 3 then we know either it is 
	// and, or, nor, or adding. 
	else { 
		// First in here we need to check bNegate 
		if (in -> ALU.bNegate) {
			input2 *= -1; 
		}

		// ALU.op = 0 (AND)  
		if (in -> ALU.op == 0) {
			new_exMem -> aluResult = input1 & input2; 
		}

		// ALU.op = 1 (OR) 
		if (in -> ALU.op == 1) {
			// extra 1 = NOR
			if (in -> extra1) {
			        new_exMem -> aluResult = ~(input1 | input2);
			}
	 				
			// Otherwise OR 
			else {
				new_exMem -> aluResult = (input1 | input2);
			}
		}

		// ALU.op = 2 (ADD)
		if (in -> ALU.op == 2) {
			new_exMem -> aluResult = input1 + input2;
		}

		// ALU.op = 4 (XOR)
		if (in -> ALU.op == 4) {
			new_exMem -> aluResult = input1 ^ input2;
		}

	} 
}

void execute_MEM(EX_MEM *in, MEM_WB *old_memWb, WORD *mem, MEM_WB *new_memwb)
{
	// Copy over all the values from the in, as you are 
	//executing instructions which uses the Mem phase 
	new_memwb -> extra1    = in -> extra1; 
	new_memwb -> extra2    = in -> extra1; 
	new_memwb -> extra3    = in -> extra3;
	new_memwb -> aluResult = in -> aluResult;
	new_memwb -> writeReg  = in -> writeReg;
	new_memwb -> memToReg  = in -> memToReg;
	new_memwb -> regWrite  = in -> regWrite; 

	// if its an  sw instruction 
	if(in ->memWrite == 1){
		if(old_memWb -> writeReg == in -> rt && old_memWb ->regWrite){
			mem[in ->aluResult/4] = old_memWb -> memToReg ? old_memWb -> memResult : old_memWb -> aluResult;
		}else{
			mem[in ->aluResult /4] = in ->rtVal;
		}
		new_memwb -> memResult = 0;
	}
	else{
		new_memwb -> memResult = 0;
	}

	// if its an lw instruction 

	if (in -> memToReg) {
		new_memwb -> memResult = mem[in -> aluResult / 4];
	}
}

void execute_WB (MEM_WB *in, WORD *regs){
	//Checks to see if regWrite is used and then if 
	//it's turned on if it needs to be written in aluResult
if (in -> regWrite) {
		if (in -> memToReg) {
			regs[in -> writeReg] = in -> memResult;     
		}

		else {
			regs[in -> writeReg] = in -> aluResult; 
		}
	}



}
