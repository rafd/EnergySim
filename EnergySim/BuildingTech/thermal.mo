within EnergySim.BuildingTech; 
encapsulated package Thermal
  "Thermal building technology package"
  import EnergySim.*;
  
  
  model Walls
    extends System.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    
    outer Temperature outside_temperature;
  
    equation
      Q = 30*(outside_temperature - building_temperature);
      RunningCost = 0;
      P = 0;
  
  end Walls;

   
  model Thermostat
    BuildingTech.SignalPort heater_on;
    BuildingTech.SignalPort ac_on;
    
    outer Temperature building_temperature;
    
    Temperature summer_target = 23;
    Temperature winter_target = 21;
    Temperature sensitivity = 0.5;
  
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
    extends System.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    extends BuildingTech.ControlledDevice;

    ThermalPower rated_thermal_power = -1000;
    ElectricPower rated_electric_power = -1500;
    Cost rated_running_cost = 0.01; //TODO: should be a function of elec. cost
    
  end AirConditioner;
  
  
  model Heater
    extends System.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    extends BuildingTech.ControlledDevice;

    ThermalPower rated_thermal_power = 1500;
    ElectricPower rated_electric_power = -1500;
    Cost rated_running_cost = 0.01; //TODO: should be a function of elec. cost
      
  end Heater;
  
  
end Thermal;