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
  
    outer Temperature outside_temperature;
    /*
    Real LeakArea;
    Real AirDensity;
    Real PressureDifferenceStack;
    Real PressureDifferenceWind;
    
    Real AirFlow;
    */
    equation
      Q = 100 * (outside_temperature - building_temperature);
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
    BuildingTech.SignalPort heater_on;
    BuildingTech.SignalPort ac_on;
    
    outer Temperature building_temperature;
    
    Temperature summer_target = 23;
    Temperature winter_target = 21;
    Temperature sensitivity = 2;
  
    equation
      // AC
      when {building_temperature > summer_target+sensitivity+273, building_temperature < summer_target-sensitivity+273} then
        ac_on.s = building_temperature > summer_target+sensitivity+273;
      end when;
      
      // Heater
      when {building_temperature < winter_target-sensitivity+273, building_temperature > winter_target+sensitivity+273} then
        heater_on.s = building_temperature < winter_target-sensitivity+273;
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
  
  
  model Heater
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=-60000);
    extends BuildingTech.ControlledDevice;

    ThermalPower rated_thermal_power = 7500;
    ElectricPower rated_electric_power = 0;
    NaturalGasPower rated_natural_gas_power = -7750;
  end Heater;
  
  
end Thermal;