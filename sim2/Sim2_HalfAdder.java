//Author: Ming Wang

public class Sim2_HalfAdder {
    RussWire a = new RussWire();
    RussWire b = new RussWire();
    RussWire sum = new RussWire();
    RussWire carry = new RussWire();
    XOR x = new XOR();

    
    public void execute(){
        x.a.set(a.get());
        x.b.set(b.get());

        x.execute();

        sum.set(x.out.get());
        AND y = new AND();
        y.a.set(a.get());
        y.b.set(b.get());
        y.execute();
        carry.set(y.out.get());
    }



}
