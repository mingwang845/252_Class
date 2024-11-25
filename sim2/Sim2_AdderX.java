//Author: Ming Wang

public class Sim2_AdderX {

    RussWire a[];
    RussWire b[];;

    RussWire sum[];
    RussWire carryOut = new RussWire();
    RussWire overflow = new RussWire();

    Sim2_FullAdder fullAdder[];
    Sim2_HalfAdder halfAdder = new Sim2_HalfAdder();
    XOR xOR = new XOR();
    
    public int value = 0;

    public Sim2_AdderX(int x){
    	a = new RussWire[x];
    	b = new RussWire[x];
    	sum = new RussWire[x];
    	value += x;
    	
    	for(int i = 0; i < value ; i++) {
    		a[i] = new RussWire();
    		b[i] = new RussWire();
    		sum[i] = new RussWire();
    		
    	}
    	
    }
    
    public void execute() {
        halfAdder.a.set(a[0].get());
        halfAdder.b.set(b[0].get());
        halfAdder.execute();
        sum[0].set(halfAdder.sum.get());

        fullAdder = new Sim2_FullAdder[value];
        fullAdder[0] = new Sim2_FullAdder(); 
        fullAdder[0].a.set(a[0].get());
        fullAdder[0].b.set(b[0].get());
        fullAdder[0].carryIn.set(halfAdder.carry.get());
        fullAdder[0].execute();

        for (int i = 1; i < value; i++) {
            fullAdder[i] = new Sim2_FullAdder(); 

            fullAdder[i].a.set(a[i].get());
            fullAdder[i].b.set(b[i].get());
            fullAdder[i].carryIn.set(fullAdder[i - 1].carryOut.get());
            fullAdder[i].execute();

            sum[i].set(fullAdder[i].sum.get());
        }

        carryOut.set(fullAdder[value - 1].carryOut.get());
        xOR.a.set(fullAdder[value - 1].carryIn.get());
        xOR.b.set(fullAdder[value - 1].carryOut.get());
        
        xOR.execute();
        overflow.set(xOR.out.get());
    }

    
 

 }

