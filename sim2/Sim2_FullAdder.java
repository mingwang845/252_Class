// Author: Ming Wang

public class Sim2_FullAdder {
   RussWire a = new RussWire();
   RussWire b = new RussWire();    
   RussWire carryIn = new RussWire();
   RussWire sum = new RussWire();
   RussWire carryOut = new RussWire();

   Sim2_HalfAdder halfOne = new Sim2_HalfAdder();
   Sim2_HalfAdder halfTwo = new Sim2_HalfAdder();
   OR z = new OR();

   /*
    * Logic behind this is very similar to the half adder, however, now you are making sure that
    * there is a carryIn so that if the previous was equal to two 1 and then you add a third one
    * the carryIn would now be a one
    */
   public void execute() {
       halfOne.a.set(a.get());
       halfOne.b.set(b.get());
       halfOne.execute();

       halfTwo.a.set(halfOne.sum.get());
       halfTwo.b.set(carryIn.get());
       halfTwo.execute();

       z.a.set(halfOne.carry.get()); 
       z.b.set(halfTwo.carry.get()); 
       z.execute();
       carryOut.set(z.out.get());  
       sum.set(halfTwo.sum.get());
   }


}
