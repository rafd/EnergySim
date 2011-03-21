encapsulated package EnergySim
  
  type Power = Real(final quantity="Power", final unit="J");
  type Temperature = Real;
  type State = Real;
  type Cost = Real;
  
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
    flow Cost C;
    
    State S;
  end MultiPort;
  
  
  partial model MultiDevice
    MultiPort i;
    MultiPort o;
    
    Power P "power produced";
    State S "states s of object";
    Cost C "cost";
     
    equation
      P = o.P - i.P;
      
      S = i.S;
      o.S = i.S; //temperature is state, in = out
      
      C = o.C - i.C;
    
  end MultiDevice;
  
  
  model System
    extends MultiDevice;

    MultiPort ground;
    
    Temperature temperature;
      
    equation
      connect(i, ground);
      ground.S = 0;//temp_outside;
      
    algorithm
      temperature := system_temperature(time);
      
    
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
    outer MultiPort comm_io;
    
    Cost FixedCost = 100; // $
    Cost RunningCost = 0.01; // $/s
    Cost TotalCost; // $

    initial equation
      TotalCost = FixedCost;
    
    equation
      P = -120;
      connect(comm_io, i);
      
      der(TotalCost) = RunningCost;
      
      C = TotalCost;
        
  end Technology;


  model Building 
    extends MultiDevice;
    outer MultiPort comm_io;

    equation
      P = -120;
      connect(comm_io, i);
      
      C = 0;
      
  end Building;

end EnergySim;

/////////

model Ontario
  extends EnergySim.System;

end Ontario;


model HarbordVillage
  extends EnergySim.Community;
  
  EnergySim.Building buildings[1];
  
  EnergySim.Technology technology[1];
  
end HarbordVillage;


model Basics
  
  Ontario           system;
  HarbordVillage    community;
  
  Real day = floor(time / 86400);
  
  equation
    connect(system.i, community.o);
    connect(system.o, community.i);
  
end Basics;