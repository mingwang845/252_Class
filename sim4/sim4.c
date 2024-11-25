#include <stdio.h>
#include "sim4.h"

/*
Author: Ming Wang 
*/

/*
* Pulls the instruction from the cur to the Memory
 */
WORD getInstruction(WORD curPC, WORD *instructionMemory){
    return instructionMemory[curPC/4];
}
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
Constructs how the cpu control bits should be utilized
and will turn on the controlBits that are used based
one the opCode, with opCode == 0 resulting in an R Format
opCode == 2 resulting in a J format
opCode == {4, 8, 9, 10, 13, 15, 35, 43} resulting in a I Format
*/
int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut) {
    controlOut->ALU.bNegate = 0;
    controlOut->ALU.op = 0;
    controlOut->ALUsrc = 0;
    controlOut->branch = 0;
    controlOut->extra1 = 0;
    controlOut->extra2 = 0;
    controlOut->extra3 = 0;
    controlOut->jump = 0;
    controlOut->memRead = 0;
    controlOut->memToReg = 0;
    controlOut->memWrite = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;

    if (fields->opcode == 0) {
        controlOut->regDst = 1;   
        controlOut->regWrite = 1;
        if (fields->funct == 32 || fields->funct == 33) {  //ADD and ADDU
            controlOut->ALU.op = 2;
        } else if (fields->funct == 34 || fields->funct == 35) {   //SUB and SUBU
            controlOut->ALU.bNegate = 1;
            controlOut->ALU.op = 2;
        } else if (fields->funct == 36) {     //AND
            // do nothing will delete later
        } else if (fields->funct == 37) {     //OR
            controlOut->ALU.op = 1;
        } else if (fields->funct == 38) {     //XOR
            controlOut->ALU.op = 4;
        } else if (fields->funct == 42) {     //SLT
            controlOut->ALU.bNegate = 1;    
            controlOut->ALU.op = 3;
        } else if (fields->funct == 0) {    //SLL
            controlOut->ALUsrc = 1;
            controlOut->ALU.op = 5;
            controlOut->extra3 = 1;
        } else {
            controlOut->regDst = 0;   
            controlOut->regWrite = 0;
            return 0;
        }
    }else if (fields->opcode == 8 ||fields->opcode == 9) {     //ADDI and ADDIU
        controlOut->ALUsrc = 1;
        controlOut->ALU.op = 2;
        controlOut->regWrite = 1;
    } else if (fields->opcode == 10) {     //SLTI
        controlOut->ALUsrc = 1;
        controlOut->ALU.bNegate = 1;
        controlOut->ALU.op = 3;
        controlOut->regWrite = 1;
    } else if (fields->opcode == 12) {     //ANDI
        controlOut->ALUsrc = 1;
        controlOut->ALU.op = 0; 
        controlOut->regWrite = 1;
        controlOut->extra2 = 1;
    } else if (fields->opcode == 13) {     //ORI
        controlOut->ALUsrc = 1;
        controlOut->ALU.op = 1;
        controlOut->extra2 = 1;
        controlOut->regWrite = 1;
    }  else if (fields->opcode == 35) {     //LW
        controlOut->memToReg = 1;
        controlOut->memRead = 1;
        controlOut->ALUsrc = 1;
        controlOut->ALU.op = 2; 
        controlOut->regWrite = 1;
    }  else if (fields->opcode == 43) {     //SW
        controlOut->ALU.op = 2;
        controlOut->memWrite = 1;
        controlOut->ALUsrc = 1;
    }  else if (fields->opcode == 4) {     //BEQ
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 1;
        controlOut->branch = 1;
    }  else if (fields->opcode == 5) {     //BNE
        controlOut->ALU.op = 2;
        controlOut->ALU.bNegate = 1;
        controlOut ->ALU.branch = 1;
        controlOut->extra1 = 1;
    }  else if (fields->opcode == 2) {     //J
        controlOut->jump = 1;
    } else {
        return 0;
    }
}



/*
* retrieves and returns the rsVal in the first ALU input
*/
WORD getALUinput1(CPUControl *controlIn, InstructionFields *fieldsIn,
		  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, 
		  WORD oldPC)
{   
    if(controlIn -> extra3){
        return rtVal;
    }
	return rsVal;
}
/*
*retrieves and returns the value of the second input for ALU
* when ALUscru = 0 it returns rtVal and when ALUscr = 1
*    
*/
WORD getALUinput2(CPUControl *controlIn, InstructionFields *fieldsIn, 
		  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, 
		  WORD oldPC)
{
	// R Format Instruction
    if (controlIn->ALUsrc == 0) {
        return rtVal;
    //Not R Format Instruction
    } else if (controlIn->ALUsrc == 1){
        
            return signExtend16to32(fieldsIn->imm16);
    }
}

/*
*Sets the ALU.op dependent on the controlIn from the CPUControl, adn will adjust
*the result of the aluResultOUt based on the operatoration being requested by the user
*/
void execute_ALU(CPUControl *controlIn, WORD input1, WORD input2, 
		 ALUResult *aluResultOut)
{
    aluResultOut->extra = 0;
    aluResultOut->result = 0;
    aluResultOut->zero = 0;
    if (controlIn->ALU.op == 0) { // AND
        aluResultOut->result = input1 & input2;
    } else if (controlIn->ALU.op == 1) { // OR
        aluResultOut->result = input1 | input2;
    } else if (controlIn->ALU.op == 2) {
        if (controlIn->ALU.bNegate) { // SUB
            aluResultOut->result = input1 - input2;
        } else {                    //ADD
            aluResultOut->result = input1 + input2;
        }
    } else if (controlIn->ALU.op == 3) {// SLT
        aluResultOut->result = (input1 < input2);
    } else if (controlIn->ALU.op == 4) {// XOR
        aluResultOut->result = input1 ^ input2;
    } else if (controlIn->ALU.op == 5) { //SLL
        aluResultOut->result = input1 << input2;
    }
    if (aluResultOut->result == 0) {
        aluResultOut->zero = 1;
    }
}


void execute_MEM(CPUControl *controlIn, ALUResult *aluResultIn, 
		 WORD rsVal, WORD rtVal, WORD *memory, 
		 MemResult *resultOut)
{
    resultOut->readVal = 0;
    if (controlIn->memRead) {
        resultOut->readVal = memory[(aluResultIn->result)/4];
    } 
    if (controlIn->memWrite) {
        memory[(aluResultIn->result)/4] = rtVal;
    }
}
/*
* Find and supplies the next PC based on the CPU control
*/
WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero, 
	       WORD rsVal, WORD rtVal, WORD oldPC)
{   
    WORD newPC = oldPC + 4;
    if (controlIn->jump) {
        return (0xf0000000 & newPC) | (fields->address << 2);
    } else if (controlIn->branch && aluZero) {
        return (signExtend16to32(fields->imm16) << 2) + newPC;
    } else {
        return newPC;
    }
}

/*
*writes to the register adn writes to mem to reg based on the CPUcontrol
*/
void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
		        ALUResult *aluResultIn, MemResult *memResultIn, 
			WORD *regs)
{
    if (controlIn->memToReg) {
        regs[fields->rt] = memResultIn->readVal;
    } else if (controlIn->regWrite) {
        if (controlIn->regDst) {
            regs[fields->rd] = aluResultIn->result;
        } else {
            regs[fields->rt] = aluResultIn->result;
        }
    }
   
}