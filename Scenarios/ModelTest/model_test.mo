/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

model EnergySimTest

  public
    Dwelling    house_usual(UWall=0.28);
    Dwelling    house_well_insulated(UWall=0.1,UWindow=0.07);         //"A house that is well insulated with low U values"
    Dwelling    house_propane_heating(GasEnergy=25.3,GasPrice=0.615); //"A house using propane instead of natural gas for heating"
  
end EnergySimTest;