//@Author Ming Wang

/*
 * creates and implements a simple mux in a cpu and will 
 * compute the out input depending on the in inputs and the control
 * wires 
 */
public class Sim3_MUX_8by1 {
    public RussWire[] control;
    public RussWire[] in;
    public RussWire out;

    public Sim3_MUX_8by1(){
        control = new RussWire[3];
        in = new RussWire[8];
        out = new RussWire();
        //initializes the 3-bit control wires
        for(int i = 0; i < 3; i++){
            control[i] = new RussWire();
        }
        //initialized the 8-bit in wires
        for(int i = 0; i < 8; i++){
            in[i] = new RussWire();
        }

    }

    public void execute(){
        //set the out input of the MUX 
        out.set((in[0].get() && !control[2].get() && !control[1].get() && !control[0].get()) ||
                (in[1].get() && !control[2].get() && !control[1].get() && control[0].get())||
                (in[2].get() && !control[2].get() && control[1].get()&& !control[0].get()) ||
                (in[3].get() && !control[2].get() && control[1].get()&& control[0].get()) ||
                (in[4].get() && control[2].get() && !control[1].get()&& !control[0].get()) ||
                (in[5].get() && control[2].get() && !control[1].get()&& control[0].get()) ||
                (in[6].get() && control[2].get() && control[1].get()&& !control[0].get())||
                (in[7].get() && control[2].get() && control[1].get()&& control[0].get())
                );
    }

    
}
