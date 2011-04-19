encapsulated package EnergySim
  
  type ElectricPower = Real(final quantity="Power", final unit="J");
  type ThermalPower = Real(final quantity="Power", final unit="J");
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
  
  
  // CONNECTORS
  
  
  connector ThermalPort
    flow ElectricPower P;
  end ThermalPort;
  
  
  connector ElectricPort
    flow ThermalPower Q;
  end ElectricPort;
  
  
  connector EconomicPort
    flow Cost TC "total cost";
  end EconomicPort;
  
  
  connector MultiPort
    extends ElectricPort;
    extends ThermalPort;
    extends EconomicPort;
  end MultiPort;
  
  
  // MODELS
  
  
  partial model MultiDevice
    MultiPort i;
    MultiPort o;
    
    ElectricPower P "electric power out (produced)";
    ThermalPower Q "thermal power out (heat produced)";
    //State S "states s of object";
    
    equation
      P = o.P - i.P;
      Q = o.Q - i.Q;
      TotalCost = o.TC - i.TC;
      
      //S = i.S;
      //o.S = i.S;       
    
  end MultiDevice;
  
  
  model System
    extends MultiDevice;

    MultiPort ground;
    
    Temperature temperature;
    
    Cost TotalCost;
      
    equation
      connect(i, ground);
      //ground.S = 0;

    algorithm
      temperature := system_temperature(time);
      
    
  end System;


  model Community
    extends MultiDevice;
    
    Cost TotalCost;
    
    inner MultiPort community_io;
    
    equation
      connect(i, community_io);
      connect(i, o);
    
  end Community;


  partial model EconomicTechnology
    parameter Real FixedCost;
    
    Cost RunningCost;
    Cost TotalCost(start=FixedCost,fixed=true);
    
    equation
      der(TotalCost) = RunningCost;
  end EconomicTechnology;

  
  model CommunityTechnology
    extends MultiDevice;
    
    outer MultiPort community_io;
    
    equation
      connect(community_io, i);
  
  end CommunityTechnology;
  
  
  model BuildingTechnology
    extends MultiDevice;
    
    outer MultiPort building_io;

    equation
      connect(building_io, i);
      
  end BuildingTechnology;
  

  
  

  encapsulated package Tech
    import EnergySim.*;
    
    // Building
    
    model Building
      extends CommunityTechnology;

      inner MultiPort building_io;

      Cost TotalCost;

      equation
        connect(i, building_io);

    end Building;
    
    
    partial model ThermalBuilding  
    end ThermalBuilding;
   
    // Building Tech
    
    model Insulation
    end Insulation;
     
     
    model Thermostat
    end Thermostat; 
     
    model PeakSaver
    end PeakSaver;
    
    
    model AirConditioner
    end AirConditioner;
    
    
    model Heater
    end Heater;
    
    
    // Community Tech
    
     
  end Tech;

end EnergySim;




///////// SPECIFICS

model SpecificCommunityTechnology
  extends EnergySim.CommunityTechnology;
  extends EnergySim.EconomicTechnology(FixedCost=1000);

  equation
    RunningCost = 0.01;
    P = -120;
    Q = 0;
        
end SpecificCommunityTechnology;


model SpecificBuildingTechnology
  extends EnergySim.BuildingTechnology;
  extends EnergySim.EconomicTechnology(FixedCost=60000);

  equation
    RunningCost = 0.01;
    P = -120;
    Q = 10;
    
end SpecificBuildingTechnology;


model SpecificBuilding
  extends EnergySim.Tech.Building;
  
  SpecificBuildingTechnology tech[2];

end SpecificBuilding;


model Ontario
  extends EnergySim.System;

end Ontario;


model HarbordVillage
  extends EnergySim.Community;
  
  SpecificBuilding bdgs_a[3];
  SpecificBuilding bdgs_b[3];
  SpecificCommunityTechnology tech_a[2];
  SpecificCommunityTechnology tech_b[2];
  
end HarbordVillage;


model Basics

  Ontario           sys;
  HarbordVillage    com;
  
  Real day = floor(time / 86400);
    
  equation
    connect(sys.i, com.o);
    connect(sys.o, com.i);
  
end Basics;