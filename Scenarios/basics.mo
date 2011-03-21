encapsulated package EnergySim
  
  type Power = Real(final quantity="Power", final unit="J");
  type Temperature = Real;
  
  constant Real seconds_in_day = 86400;
  constant Real seconds_in_year = 31536000;
  
  function system_temperature
    input    Real         time;
    output   Temperature  result "Outside Temperature in Kelvin";
    
    Real max_T = 33;
    Real min_T = -17+5;
    Real days_to_peak = 189; // July 8
    
    Real a = (max_T - min_T) / 2; //magnitude
    Real b = (Modelica.Constants.pi * 2) / seconds_in_year; //period
    Real c = days_to_peak * seconds_in_day; //x-offset right
    Real d = a + min_T; //y-offset up
    
    Real x, y;
    
    algorithm
     
      x := 0.9 * a * cos(b*(time-c)) + d + 273; //daily extremes
      y := 5 * cos((b*365)*(time-seconds_in_day/2)) - 5; //daily variation of 5 deg
      result := x + y;
  end system_temperature;
  
  
  connector MultiPort
    flow Power P;
    
    Temperature T;
  end MultiPort;
  
  
  partial model MultiDevice
    MultiPort i;
    MultiPort o;
    
    Power P "power produced";
    Temperature T "temperature of object";
    
    equation
      P = o.P - i.P;
      T = i.T;
      o.T = i.T; //temperature is state, in = out
    
  end MultiDevice;
  
  
  model System
    extends MultiDevice;

    MultiPort ground;
    
    Temperature temp_outside;
      
    equation
      connect(i, ground);
      ground.T = temp_outside;
      o.T = i.T;
      
    algorithm
      temp_outside := system_temperature(time);
      
    
  end System;


  model Community
    extends MultiDevice;
    
    inner MultiPort comm_io;
    
    equation
      connect(i, comm_io);
      connect(i, o);
    
  end Community;


  model Technology
    extends MultiDevice;

  end Technology;


  model Building 
    extends MultiDevice;
    outer MultiPort comm_io;

    equation
      P = -120;
      connect(comm_io, i);
      
  end Building;

end EnergySim;

/////////

model Ontario
  extends EnergySim.System;

end Ontario;


model HarbordVillage
  extends EnergySim.Community;
  
  EnergySim.Building buildings[1];
  
end HarbordVillage;


model Basics
  
  Ontario           system;
  HarbordVillage    community;
  
  Real day = floor(time / 86400);
  
  equation
    connect(system.i, community.o);
    connect(system.o, community.i);
  
end Basics;