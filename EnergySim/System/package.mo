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
   * Model for describing solar influx of the region of the region
   * Input: Local standard time, Longitude/Latitude of the location
   * Output: DynamicSolarInsulation W/m^2
   * Default data are from Annex
   * Created by Kun Xie 2010/03/07
   */


  function radians
    input Real inp;
    output Real out;
     
    algorithm
      out := inp * 2 * Modelica.Constants.pi/360;
  end radians;
   
  function degrees
    input Real inp;
    output Real out;
    
    algorithm
      out := inp * 0.5 * 360/Modelica.Constants.pi;
  end degrees;


  function system_solar_insolation
     
    input Real time;
    input Real CollectorTiltAngle;
    input Real CollectorAzimuthAngle;

    parameter Real Longitude = 79.62 "longitude of location";
    parameter Real Latitude = 43.58 "latitude of location";
    parameter Real Reflectivity = 0 "reflectivity around the subject of interest, 0.8 for snow, 0.2 for grass";

    constant Real STML = 75 "Standard Time Meridian Longitude";
    constant Real SkyDiffusivityFactor = 0.058;
    constant Real ClearnessNumber = 1 "clouds?";

    parameter Real OpticalDepth = 0.144 "local optical depth"; //NOT A PARAM, SHOULD BE A LOOKUP
    parameter Real SkyDiffuseFactor = 0.06 "radiation factors diffused from sky"; //NOT A PARAM, SHOULD BE A LOOKUP

    Real DayOfYear;

    Real LST;
    Real B "intermediate variable for calculation, unit Rad";
    Real ET "intermediate variable for calculation, unit Min";
    Real SolarTime "time of the day that solar influx existed, unit Min";
    Real HourAngle;
    Real SolarDeclination;
    Real SolarAltitudeAngle;
    Real SolarAzimuthAngle;
    Real DynamicSolarInsolation;
    Real IncidentAngle;
    
    Real NormalBeamRadiation;
    Real HorizontalRadiation;
    Real BeamRadiation;
    Real DiffuseRadiation;
    Real ReflectedRadiation;
    
    output Real TotalRadiation; // W/m2

    algorithm
       LST       := mod(time,86400)/60;
       DayOfYear := Time.day_of_year(time)+1;
       B          := 360*(DayOfYear-81)/364;
       ET         := 9.87 * sin(2*radians(B)) - 7.53 * cos(radians(B)) - 1.55 * sin(radians(B));
       SolarTime  := LST+ET+(STML-Longitude)*4;
       HourAngle  := (SolarTime-12*60)/4;
       SolarDeclination   := 23.45 * sin(radians(360*(284+DayOfYear)/365));
       SolarAltitudeAngle := degrees(asin(sin(radians(Latitude))*sin(radians(SolarDeclination))+cos(radians(Latitude))*cos(radians(SolarDeclination))*cos(radians(HourAngle)))); 
       SolarAzimuthAngle  := degrees(asin(cos(radians(SolarDeclination))*sin(radians(HourAngle))/cos(radians(SolarAltitudeAngle))));
       DynamicSolarInsolation := 1353*(1+0.034*cos(radians(360*DayOfYear/365.25)));
       IncidentAngle := degrees( acos( cos(radians(SolarAltitudeAngle)) * cos(radians(SolarAzimuthAngle-CollectorAzimuthAngle)) * sin(radians(CollectorTiltAngle)) + sin(radians(SolarAltitudeAngle)) * cos(radians(CollectorTiltAngle)) ) );
       
       NormalBeamRadiation := if SolarAltitudeAngle < 0 then 0 else ClearnessNumber*DynamicSolarInsolation*exp(-OpticalDepth/sin(radians(SolarAltitudeAngle)));
       HorizontalRadiation := (SkyDiffusivityFactor+sin(radians(SolarAltitudeAngle)))*NormalBeamRadiation;
       BeamRadiation := if IncidentAngle > 90 then 0 else NormalBeamRadiation * cos(radians(IncidentAngle));     
       DiffuseRadiation := SkyDiffusivityFactor * NormalBeamRadiation * abs((1+cos(radians(CollectorTiltAngle)))/2);
       ReflectedRadiation := Reflectivity * HorizontalRadiation * abs((1-cos(radians(CollectorTiltAngle)))/2);
       TotalRadiation := BeamRadiation + DiffuseRadiation + ReflectedRadiation;
      
      
  end system_solar_insolation;
  
  
  
  function ghg_calculator
    input Real time;
    input ElectricPower P_electricity;
    input NaturalGasPower P_natural_gas;
    
    output GHGRate ghg_rate;
    
    algorithm
    
      ghg_rate := 0;
  
  end ghg_calculator;
  
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
  
  
  connector NaturalGasPort
    flow NaturalGasPower NG;
  end NaturalGasPort;
  
  
  connector GHGPort
    flow GHGRate GHG;
  end GHGPort;
  
  
  connector MultiPort
    extends ElectricPort;
    extends ThermalPort;
    extends EconomicPort;
    extends NaturalGasPort;
    extends GHGPort;
  end MultiPort;    
  
  /*
  *    MODELS
  */
  
  partial model MultiDevice
    MultiPort i;
    MultiPort o;
    
    ElectricPower P "electric power out (produced)";
    ThermalPower Q "thermal power out (heat produced)";
    NaturalGasPower NG "";
    
    //State S "states s of object";
    
    equation
      P = o.P - i.P;
      Q = o.Q - i.Q;
      
      NG = o.NG - i.NG;
      GHG = o.GHG - i.GHG;
      
      TotalCost = o.TC - i.TC; //cost is a special case for now, due to the accumulator
      
      //S = i.S;
      //o.S = i.S;       
    
  end MultiDevice;
  
  
  model System
    extends MultiDevice;

    MultiPort ground;
  
    Temperature temperature;
   
    Cost TotalCost;
    GHGRate GHG;
     
    equation
      connect(i, ground);
      //ground.S = 0;

    algorithm
      temperature := EnergySim.System.system_temperature(time);

  end System;  


  model Community
    extends MultiDevice;
    
    Cost TotalCost;
    GHGRate GHG;
    
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
  
  
  partial model GHGTechnology
    GHGRate GHG "";
    
    equation
      GHG = EnergySim.System.ghg_calculator(time, P, NG);
  end GHGTechnology;

  
  partial model CommunityTechnology
    extends MultiDevice;
    
    outer MultiPort community_io;
    
    equation
      connect(community_io, i);
  
  end CommunityTechnology;
  
  
  

end System;
