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
    
    BuildingTech.Thermal.Walls walls;
    BuildingTech.Thermal.Heater heater;
    BuildingTech.Thermal.AirConditioner ac;
    BuildingTech.Thermal.Thermostat thermostat;
    
    equation
      connect(heater.control, thermostat.heater_on);
      connect(ac.control, thermostat.ac_on);
  
  end ThermalTechBuilding;
 
  
end Tech;