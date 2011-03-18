/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

model Outside
  import EnergySim.Technologies.*;
  
  extends ElectricDevice;
  
  flow Power power = 0;
  
  equation
    electric_in.P = power;

end Outside;

model SomeTech
  import EnergySim.Technologies.*;
  extends ElectricDevice;
  
  equation
    power_demand = 37;    

end SomeTech;

model HouseWithSomeTech
  import EnergySim.Technologies.*;
  extends House;
  
  SomeTech some_tech;

  equation
    power_demand = some_tech.power_demand;

end HouseWithSomeTech;

model EnergySimTest
  import EnergySim.Technologies.*;
 
  extends EnergySim.System.Environment;
  
  public
    HouseWithSomeTech       house;
    //Outside                 outside;
    
  equation
    //connect(house.electric_out, outside.electric_in);
    //connect(house.electric_in, outside.electric_out);
  
end EnergySimTest;
