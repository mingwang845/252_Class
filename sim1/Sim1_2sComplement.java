/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Ming Wang
 */

public class Sim1_2sComplement
{
	public void execute()
	{
		// TODO: fill this in!
		//
		// REMEMBER: You may call execute() on sub-objects here, and
		//           copy values around - but you MUST NOT create
		//           objects while inside this function.
		
		
		
		
		
		//inverts all the 1 and 0
		for(int i = 0; i < 32; i++) {
			t.a[i].set(!in[i].get());	
			}
		//creates a bit string with 1 and all zeros after
		t.b[0].set(true);
		for(int i = 1; i < 32; i++) {
			t.b[i].set(false);
		}
		
		t.execute();
		
		for (int i = 0; i < 32; i++) {
		    out[i].set(t.sum[i].get());
		}

        // Check for overflow and update the overflow wire
        boolean overflow = t.overflow.get();
        
		
	}



	// you shouldn't change these standard variables...
	public RussWire[] in;
	public RussWire[] out;


	// TODO: add some more variables here.  You must create them
	//       during the constructor below.  REMEMBER: You're not
	//       allowed to create any object inside the execute()
	//       method above!
	public Sim1_ADD t;
	
	public Sim1_2sComplement()
	{
		// TODO: this is where you create the objects that
		//       you declared up above.
		in = new RussWire[32];
		out = new RussWire[32];
		 t = new Sim1_ADD();

		    // Create a new array for t.a
		    t.a = new RussWire[32];
		    for (int i = 0; i < 32; i++)
		    {
		        t.a[i] = new RussWire();
		    }
		    
		for (int i=0; i<32; i++)
		{
			in  [i] = new RussWire();
			out  [i] = new RussWire();
			t.a[i] = new RussWire();
			t.b[i] = new RussWire();
			t.sum[i] = new RussWire();
			
		}
	}
}

