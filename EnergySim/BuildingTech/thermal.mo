within EnergySim.BuildingTech; 
encapsulated package Thermal
  "Thermal building technology package"
  import EnergySim.*;
  
  
  model Walls
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=-60000);
    
    outer Temperature outside_temperature;
    
    Real SurfaceArea = 200; //200-540 m2
    Real R_value = 4; //0.17 - 2000
  
    equation
      Q = (SurfaceArea/R_value)*(outside_temperature - building_temperature);
      P = 0;
      NG = 0;
  
  end Walls;
  
  
  model Windows
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=-60000);
  
    outer Temperature outside_temperature;
    
    Real SurfaceArea = 20; //20-54 m2, 10% of surface area of house
    Real R_value = 2; //0.3 - 6
    
    equation
      Q = (SurfaceArea/R_value)*(outside_temperature - building_temperature);
      P = 0;
      NG = 0;
  end Windows;
  
  model Leaks
    
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=-60000);  
    
    parameter Real Height=2 "height of the building in m";
    
    parameter Real AirDensity = 1.3 "kg/m^3";
    parameter Real ELA=0.34 "equavalent leakage area m^2";
    parameter Real Shape=0.6 "shape property for leakage area, 0.6 for rough edge";
    parameter Real HF=1.2 "humidity factor, ususaly 1.2";
    parameter Real Cair=1005 "heat capacity in J/kg";
    parameter Real HouseVolume=6*10*Height;
    
    
    outer Temperature outside_temperature;
    outer Real WindSpeed "in m/s at 10m";
    outer Real Patm "atm pressure in Pa";
    
    Real FlowRate "in m^3/s";
    Real DeltaP "sum Pressure difference";
    Real DeltaPStack "pressure difference caused by stack (building height)";
    Real DeltaPWind "pressure different cuased by wind";
    //Real AirCycle"how many cycles of air has been replaced, in cycles";
    
    
    equation
      DeltaP=DeltaPStack+DeltaPWind;
      DeltaPStack=0.0342*(Height/2)*Patm*((1/outside_temperature)-(1/building_temperature));
      DeltaPWind=0.5*AirDensity*(WindSpeed*(Height/2/10)^0.26)^2;
      FlowRate=Shape*ELA*(2/AirDensity*DeltaP)^0.5;
      //der(AirCycle)=FlowRate/HouseVolume;
      Q=HF*FlowRate*AirDensity*Cair*(outside_temperature-building_temperature);
      P = 0;
      NG = 0;
    
  end Leaks;



  function preferred_temperature // NOTE: NOT TESTED OR USED

    constant Temperature max_pref = 25 + 273;
    constant Temperature min_pref = 18 + 273;

    input    Temperature t_outside;
    output   Temperature result;

    algorithm
        if t_outside > max_pref then result := max_pref;
        elseif t_outside < min_pref then result := min_pref;
        else result := t_outside;
        end if;

  end preferred_temperature;

   
  model Thermostat
    BuildingTech.SignalPort furnace_on;
    BuildingTech.SignalPort ac_on;
    
    outer Temperature building_temperature;
    
    Temperature summer_target = 21;
    Temperature winter_target = 20;
    Temperature sensitivity = 0.25;
  
    equation
      // AC
      when {building_temperature > summer_target+sensitivity+273, building_temperature < summer_target-sensitivity+273} then
        ac_on.s = building_temperature > summer_target+sensitivity+273;
      end when;
      
      // Furnace
      when {building_temperature < winter_target-sensitivity+273, building_temperature > winter_target+sensitivity+273} then
        furnace_on.s = building_temperature < winter_target-sensitivity+273;
      end when;
  
  end Thermostat; 
  
  
  model PeakSaver
    SignalPort ac_on;
    
  end PeakSaver;
  

  model AirConditioner
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=-60000);
    extends BuildingTech.ControlledDevice;

    ThermalPower rated_thermal_power = -4000;
    ElectricPower rated_electric_power = -5000;
    NaturalGasPower rated_natural_gas_power = 0;
  
  end AirConditioner;
  
  
  
  model Furnace
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=-60000);
    extends BuildingTech.ControlledDevice;

    ThermalPower rated_thermal_power = 7500;
    ElectricPower rated_electric_power = 0;
    NaturalGasPower rated_natural_gas_power = -7750;
  end Furnace;
  

  
end Thermal;