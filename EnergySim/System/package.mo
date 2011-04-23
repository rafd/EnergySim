within EnergySim;

encapsulated package System
  "System modeling package"
  //import Modelica.SIunits.Temperature;
  import EnergySim.*;
  
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
  
  
  /*
  *    CONNECTORS
  */
  
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
    
  
  /*
  *    MODELS
  */
  
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
      temperature := EnergySim.System.system_temperature(time);
      
    
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

  
  partial model CommunityTechnology
    extends MultiDevice;
    
    outer MultiPort community_io;
    
    equation
      connect(community_io, i);
  
  end CommunityTechnology;
  
  model getData
    
    import Modelica.Blocks.Sources;
    import Modelica.Blocks.Tables;
    Tables.CombiTable1Ds Climate(tableOnFile = true, tableName = "Climate", fileName = "Climate2010.txt",columns=2:11);
    Tables.CombiTable1Ds Demand(tableOnFile = true, tableName = "Demand", fileName = "ElectricityDemand.txt",columns=2:4);
    
    
    Real Month =Climate.y[1] "Month of the year";
    Real Day=Climate.y[2] "Day of the month";
    Real T=Climate.y[3] "temperature in C";
    Real DT=Climate.y[4] "Dew Point Temperature in C";
    Real RH=Climate.y[5] "relative Humidity in %";
    Real D=10*Climate.y[6] "wind direction in degree";
    Real V=Climate.y[7]"wind speed in km/h";
    Real Visibiliy=Climate.y[8]"Visibiliy in km";
    Real Patm =Climate.y[9]"Standard Pressure in kPa";
    Real WC=Climate.y[10] "WindChill";
    
    Real TotalDemand=Demand.y[1]"total demand";
    Real ONDemand=Demand.y[2]"Ontario Demand";
    Real PredictDemand=Demand.y[3]"Predicted demand for this hour";
    
  equation 
    Climate.u=time/60/60;
    Demand.u=time/60/60;
    
    
  end getData;
  
  

end System;
