within EnergySim; 
encapsulated package Tech
  "Technology package"
  
  import EnergySim.*;
  
  // Building
  
  model Building
    extends System.CommunityTechnology;
    extends ThermalBuilding;
    extends ThermalTechBuilding;

    inner System.MultiPort building_io;

    Cost TotalCost;

    equation
      connect(i, building_io);

  end Building;
  
  
  partial model GeometricBuilding
  
  
  end GeometricBuilding;
  
  
  partial model ThermalBuilding
    inner Temperature building_temperature(start=273+21) "Temp, in Kelvin";
    
    ThermalEnergy E;
    
    initial equation
      E = 1*building_temperature;
      
    equation
    
      der(E) = 1000000*der(building_temperature); //or should this be E=kT?

      der(E) = Q; // Q is summative heat flow from building technologies
      
  
  end ThermalBuilding;
  
  partial model ThermalTechBuilding
    
    Walls walls;
    Heater heater;
    AirConditioner ac;
    Thermostat thermostat;
    
    equation
      connect(heater.control, thermostat.heater_on);
      connect(ac.control, thermostat.ac_on);
  
  end ThermalTechBuilding;
 
  /*
  *   Building Tech
  */
  
  model Walls
    extends System.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    
    outer Temperature outside_temperature;
  
    equation
      Q = 30*(outside_temperature - building_temperature);
      RunningCost = 0;
      P = 0;
  
  end Walls;
   
  
  connector SignalPort
    Boolean s(start=false);
  end SignalPort;
   
  model Thermostat
    SignalPort heater_on;
    SignalPort ac_on;
    
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
  
  
  partial model ControlledDevice
  
    SignalPort control;
    
    equation
      RunningCost = if control.s then rated_running_cost else 0;
      P = if control.s then rated_electric_power else 0;
      Q = if control.s then rated_thermal_power else 0;
  
  end ControlledDevice;
  
  
  model AirConditioner
    extends System.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    extends ControlledDevice;

    ThermalPower rated_thermal_power = -1000;
    ElectricPower rated_electric_power = -1500;
    Cost rated_running_cost = 0.01; //TODO: should be a function of elec. cost
    
  end AirConditioner;
  
  
  model Heater
    extends System.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    extends ControlledDevice;

    ThermalPower rated_thermal_power = 1500;
    ElectricPower rated_electric_power = -1500;
    Cost rated_running_cost = 0.01; //TODO: should be a function of elec. cost
      
  end Heater;
  
  
  /*
    Community Tech
  */
  
end Tech;