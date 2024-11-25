/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Ming Wang
 */

public class Sim1_ADD
{
	  public void execute()
	    {
	        boolean carryOutNum = false; // Initialize carryOut to false
	        //Add a statement that's if it's 3 one's then you 
	        for (int i = 0; i < 32; i++)
	        {
	            // when both are one
	        	if((a[i].get() && b[i].get() && carryOutNum)) {
	        		 sum[i].set(true);
		             carryOutNum = true;
	        	}
	        	else if ((a[i].get() && b[i].get()) || (a[i].get() && carryOutNum) || (b[i].get() && carryOutNum))
	            {
	                sum[i].set(false);
	                carryOutNum = true;
	            }
	            else if ((a[i].get() ^ b[i].get()) || (a[i].get() ^ carryOutNum) || (b[i].get() ^ carryOutNum))
	            {
	                sum[i].set(true);
	                carryOutNum = false;
	            }
	            else
	            {
	                sum[i].set(false);
	                carryOutNum = false;
	            }
	        }

	        carryOut.set(carryOutNum); 
	        overflow.set(carryOutNum); 
	    }



	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;

	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;

	public Sim1_ADD()
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}

