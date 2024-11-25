/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Ming Wang
 */

public class Sim1_SUB {
	public void execute() {
		// TODO: fill this in!
		//
		// REMEMBER: You may call execute() on sub-objects here, and
		// copy values around - but you MUST NOT create
		// objects while inside this function.

		// creates the 2s complement list
		c.in = b;
		c.execute();

		// assigns the a value for the sub a to add a
		// then assigns the c.out(aka the 2's complement set)

		t.a = a;
		for (int i = 0; i < 32; i++) {
			t.b[i].set(c.out[i].get());
		}

		// adds the two sets together
		t.execute();

		for (int i = 0; i < 32; i++) {
			sum[i].set(t.sum[i].get());
		}
		
		
        if(t.a[31].get()) {
        	aNonNeg.set(false);
        }
        aNonNeg.set(true);
        if(c.in[31].get()) {
        	bNonNeg.set(false);
        }
        bNonNeg.set(true);

	}
	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] a, b;

	// output
	public RussWire[] sum;

	// --------------------
	// But you should add some *MORE* variables here.
	// --------------------
	// TODO: fill this in
	public Sim1_ADD t = new Sim1_ADD();
	public Sim1_2sComplement c = new Sim1_2sComplement();
	public RussWire carryOut = new RussWire();
	public RussWire overflow = new RussWire();
	public RussWire aNonNeg = new RussWire();
	public RussWire bNonNeg = new RussWire();

	public Sim1_SUB() {
		// TODO: fill this in!
		// Initialize arrays and wires
		a = new RussWire[32];
		b = new RussWire[32];
		sum = new RussWire[32];

		for (int i = 0; i < 32; i++) {
			a[i] = new RussWire();
			b[i] = new RussWire();
			sum[i] = new RussWire();
		}
	}

}
