/* Implementation of a 32-bit adder in C.
 *
 * Author: Ming Wang
 */


#include "sim1.h"



void execute_add(Sim1Data *obj)
{
	// TODO: implement me!
	int sub = obj->isSubtraction;
	// the sum is empty 
	int carry = 0;
	int overflow = 0;
	obj->aNonNeg = !(obj->a >>31 & 1);
	obj->bNonNeg = !(obj->b >>31 & 1);
	int sum = obj->sum;
	int sumBit;
	for(int i = 0; i<32 ; i++){
		int aBit = (obj->a >>i )& 1; 
		int bBit = (obj->b >>i )& 1;
		
		if(obj->isSubtraction == 1){
			if(i == 0){
				bBit = ~bBit & 1;
				carry = 1;
			}else{
				bBit = ~bBit & 1;
			}
		}
		if(aBit == 1 && bBit ==1 && carry ==1){
			sumBit = 1;
			carry = 1; 
		}
		else if((aBit == 1 && bBit ==1) || (aBit == 1 && carry ==1) || (bBit == 1 && carry  == 1)){
			sumBit = 0;
			carry = 1;
		}else if((aBit == 1 ^ bBit == 1) || (aBit == 1 ^ carry == 1) || (bBit == 1 ^ carry == 1)){
			sumBit = 1;
			carry = 0;
		}else{
			sumBit = 0;
			carry = 0;
		}
		sum = sum | (sumBit << i);
	}
	obj->carryOut = carry;
	obj->sumNonNeg = !(sum >>31 & 1);
	obj->sum = sum;

}

