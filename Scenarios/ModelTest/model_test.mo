/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

model TenHouses
  EnergySim.System.House house_vec[10];
end TenHouses;

model EnergySimTest
  import EnergySim.System.*;
  extends Community;
  
  public
    House       h_1, h_2, h_3, h_4, h_5;
    TenHouses   houses_1; 
    Dwelling    house_usual(UWall=0.28);
    Dwelling    house_well_insulated(UWall=0.1,UWindow=0.07);         //"A house that is well insulated with low U values"
    Dwelling    house_propane_heating(GasEnergy=25.3,GasPrice=0.615); //"A house using propane instead of natural gas for heating"
  
end EnergySimTest;
