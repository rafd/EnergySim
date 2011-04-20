within EnergySim; 
encapsulated package BuildingTech
  "Building technology package"
  
  
  connector SignalPort
    Boolean s(start=false);
  end SignalPort;
  
  
  partial model ControlledDevice
  
    SignalPort control;
    
    equation
      RunningCost = if control.s then rated_running_cost else 0;
      P = if control.s then rated_electric_power else 0;
      Q = if control.s then rated_thermal_power else 0;
  
  end ControlledDevice;
  
  
end BuildingTech;