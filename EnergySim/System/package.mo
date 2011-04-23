within EnergySim;

encapsulated package System
  "System modeling package"

  import EnergySim.*;
  
  function electricity_price
    input Real time;
    output Cost price "$/kwH";
    
    Cost off_peak = 0.059 "$/kwH";
    Cost mid_peak = 0.089 "$/kwH";
    Cost on_peak = 0.107 "$/kwH";
    
    Real hour;
    Real month;
  
    algorithm
      hour := EnergySim.Time.hour_of_day(time);
      month := EnergySim.Time.month_of_year(time);
      
      if EnergySim.Time.day_of_week(time) > 5  then //weekend
        price := off_peak;
      else // weekday
        if month >= 5 and month <= 10 then //summer
          if hour < 7 then
            price := off_peak;
          elseif hour < 11 then
            price := mid_peak;
          elseif hour < 17 then
            price := on_peak;
          elseif hour < 19 then
            price := mid_peak;
          else
            price := off_peak;
          end if;
        else // winter
          if hour < 7 then
            price := off_peak;
          elseif hour < 11 then
            price := on_peak;
          elseif hour < 17 then
            price := mid_peak;
          elseif hour < 19 then
            price := on_peak;
          else
            price := off_peak;
          end if;
        end if;
      end if;
  
  end electricity_price;
  
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
  
  
  

end System;
