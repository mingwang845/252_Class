/* Simulates a physical NOT gate.
 *
 * Author: Ming Wang
 */

public class Sim1_NOT
{
	public void execute()
	{
		// TODO: fill this in!
		out.set(!in.get());
	}



	public RussWire in;    // input
	public RussWire out;   // output

	public Sim1_NOT()
	{
		// TODO: fill this in!
		in = new RussWire();
		out = new RussWire();
	}
}

