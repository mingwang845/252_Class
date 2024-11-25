//@Author Ming Wang

/*
 * creates a working ALU and will work for any size
 * as and will return true or false for teh less than 
 * 
 */
public class Sim3_ALU {

    public RussWire[] aluOp;
    public RussWire bNegate;
    public RussWire[] a;
    public RussWire[] b;
    public RussWire[] result;
    public int size;
    public Sim3_ALUElement[] elements;

    public void execute() {
        // Set aluOp and bNegate for the first element so that you can have carryIn
        elements[0].aluOp[0].set(aluOp[0].get());
        elements[0].aluOp[1].set(aluOp[1].get());
        elements[0].aluOp[2].set(aluOp[2].get());

        elements[0].bInvert.set(bNegate.get());

        elements[0].a.set(a[0].get());
        elements[0].b.set(b[0].get());
        elements[0].carryIn.set(bNegate.get()); 
        elements[0].execute_pass1();
        //Set aluOp and bNegate and executes all the rest of the elements
        //that are inputted into the ALU
        for (int i = 1; i < size; i++) {
            elements[i].aluOp[0].set(aluOp[0].get());
            elements[i].aluOp[1].set(aluOp[1].get());
            elements[i].aluOp[2].set(aluOp[2].get());

            elements[i].bInvert.set(bNegate.get());

            elements[i].a.set(a[i].get());
            elements[i].b.set(b[i].get());
            elements[i].carryIn.set(elements[i-1].carryOut.get()); 
            elements[i].execute_pass1();
        }
        //sets the least signicant bit as true or false if less
        elements[0].less.set(elements[size-1].addResult.get()); 

        //sets the less for the rest of the ALU as false
        for(int i = 1; i < size; i++){
            elements[i].less.set(false);
        }


        // Call execute_pass2() on every element, and copy to the result[] output
        // the less is always false after the first index in the bit series so it should be only the 
        //least signicat bit that tells us if it's less than or not less
        for (int i = 0; i < size; i++) {
            elements[i].execute_pass2();
            result[i].set(elements[i].result.get());
        }
    }

    public Sim3_ALU(int x) {
        //Initializes all the variables 
        size = x;
        aluOp = new RussWire[3];
        a = new RussWire[x];
        b = new RussWire[x];
        result = new RussWire[x];
        elements = new Sim3_ALUElement[x];
        //create and intializes the list of russwires used and sim3_aluElements
        for (int i = 0; i < x; i++) {
            a[i] = new RussWire();
            b[i] = new RussWire();
            result[i] = new RussWire();
            elements[i] = new Sim3_ALUElement();
        }

        for (int i = 0; i < 3; i++) {
            aluOp[i] = new RussWire();
        }
        bNegate = new RussWire();
    }
}
