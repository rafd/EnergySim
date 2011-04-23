within EnergySim; 
encapsulated package Building
  "Building package"
  
  import EnergySim.*;
  
  // Building
  
  model Building
    extends System.CommunityTechnology;
    extends ThermalBuilding;
    extends ThermalTechBuilding;
    extends WindTechBuilding;

    inner System.MultiPort building_io;

    Cost TotalCost;

    equation
      connect(i, building_io);

  end Building;
  
  
  partial model GeometricBuilding
    //area, wall_thickness, volume
  
  end GeometricBuilding;
  
  
  partial model ThermalBuilding
    inner Temperature building_temperature(start=273+21) "Temp, in Kelvin";
    
    ThermalEnergy E(start=0);
    
    /*
    constant Real air_heat_capacity = 1.297
    Real C_p = 1.012;
    Real Side = 20.0;
    Real M = Side^3 * 1.294;
    Real ConvCoeff = 5;
    Real SurfaceArea = Side^2*5;
    */
    
    initial equation
      //E = 1*building_temperature;
      
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
  
  partial model WindTechBuilding
    
    //BuidldingTech.Wind.WindTurbine WT;
    
  equation
    
  end WindTechBuilding;
  
end Building;