//@Author Ming Wang

/*
 * implements the mux class in order to make a working 
 * a single alu element that implements a mux and will reutrn a 
 * the result depending on what controls and things are turned on 
 */
public class Sim3_ALUElement {

    public RussWire[] aluOp;
    public RussWire bInvert;
    public RussWire a;
    public RussWire b;
    public RussWire carryIn;
    public RussWire less;
    public RussWire carryOut;
    public RussWire result;
    public RussWire addResult;
    public Sim3_MUX_8by1 mux;

    public boolean aVal;
    public boolean bVal;
    public boolean bInvertVal;
    public boolean carryInVal;
    public boolean lessVal;

    public Sim3_ALUElement() {
        //initilizes all the public variables 
        aluOp = new RussWire[3];
        for (int i = 0; i < 3; i++) {
            aluOp[i] = new RussWire();
        }
        bInvert = new RussWire();
        a = new RussWire();
        b = new RussWire();
        carryIn = new RussWire();
        less = new RussWire();
        carryOut = new RussWire();
        result = new RussWire();
        addResult = new RussWire();
        mux = new Sim3_MUX_8by1();

    }
    public void execute_pass1() {
        
        // Compute the value of bVal based on bInvertVal
        boolean tempBVal = (b.get()^bInvert.get());
        //intializes and runs to get the add values depending on the a and bnegate and the carryin
        addResult.set((a.get()&& tempBVal && carryIn.get())||
                    (a.get() && !tempBVal && !carryIn.get())||
                    (!a.get() && tempBVal && !carryIn.get())||
                    (!a.get() && !tempBVal && carryIn.get()));

        //computes the carryOut and set its and then runs the rest of the code
        carryOut.set((a.get()&&tempBVal) || (a.get() && carryIn.get() ) || (tempBVal && carryIn.get()));
        
        // Set the inputs of the MUX
        mux.control[0].set(aluOp[0].get());
        mux.control[1].set(aluOp[1].get());
        mux.control[2].set(aluOp[2].get());
        mux.in[0].set(a.get() && tempBVal);
        mux.in[1].set(a.get() || tempBVal);
        mux.in[2].set(addResult.get());

        mux.in[4].set(a.get()^tempBVal);
        mux.in[5].set(false);
        mux.in[6].set(false);
        mux.in[7].set(false);       
    }
    
    public void execute_pass2() {
        //returns output of the mux as the result fo the alu element 
        mux.in[3].set(less.get());
        mux.execute();
        result.set(mux.out.get());
    }
    
    

}
