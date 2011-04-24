within EnergySim; 
encapsulated package BuildingTech
  "Building technology package"
  
  import EnergySim.*;
  
  partial model BuildingTechnology
    extends System.MultiDevice;
    extends System.GHGTechnology;
    
    outer System.MultiPort building_io;
    outer Temperature building_temperature;

    equation
      connect(building_io, i);
      
  end BuildingTechnology;
  
  
  connector SignalPort
    Boolean s(start=false);
  end SignalPort;
  
  
  partial model ControlledDevice
  
    SignalPort control;
    
    equation
      P = if control.s then rated_electric_power else 0;
      NG = if control.s then rated_natural_gas_power else 0;
      Q = if control.s then rated_thermal_power else 0;
  
  end ControlledDevice;
  
end BuildingTech;