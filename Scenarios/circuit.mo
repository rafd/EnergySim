encapsulated package CircuitPackage
  //import Voltage = Modelica.SIUnits.Voltage;
  //import Current = Modelica.SIUnits.Current;
  
  type Power = Real(final quantity="Power", final unit="J");
  type Voltage = Real;
  type Current = Real;
  type Resistance = Real;

  connector ElectricPort
    Voltage V;
    flow Current I "power flowing into the port";
  end ElectricPort;

  partial model ElectricDevice
    ElectricPort electric_in;
    ElectricPort electric_out;
  
    Voltage V;
    Power P;
    Current I;
  
    equation
      V = electric_in.V - electric_out.V;
      I = electric_in.I;
      0 = electric_in.I + electric_out.I;
      P = V * I;
    
  end ElectricDevice;

  model Load
    extends ElectricDevice;
    
    parameter Resistance R = 1;
    
    equation
      R*I=V;
      
  end Load;

  model Source
    extends ElectricDevice;
    
    parameter Voltage v = 120;
    
    equation
      V = 120;
      //electric_out.V = 0;
  end Source;
  
  model Ground
    ElectricPort e;
    
    equation
      e.V = 0;
  
  end Ground;

  
end CircuitPackage;

model Circuit
  
  CircuitPackage.Load load;
  CircuitPackage.Source source;
  CircuitPackage.Ground ground;
  
  equation
    connect(load.electric_out, source.electric_in);
    connect(load.electric_in, ground.e);
    connect(source.electric_out, ground.e);
end Circuit;