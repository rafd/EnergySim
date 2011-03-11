/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

model TenHouses
  EnergySim.Technologies.House house_vec[10];
end TenHouses;

model EnergySimTest
  import EnergySim.Technologies.*;
  
  extends EnergySim.System.Environment;
  
  Real fixed_cost;
  
  public
    House       houses[10];
  
  algorithm
    fixed_cost := 0;
    for k in 1:9 loop
      fixed_cost := fixed_cost + houses[1].economic_out.fixed_cost; //needs to be k, not 1
    end for;

    //Dwelling    house_usual(UWall=0.28);
    //Dwelling    house_well_insulated(UWall=0.1,UWindow=0.07);         //"A house that is well insulated with low U values"
    //Dwelling    house_propane_heating(GasEnergy=25.3,GasPrice=0.615); //"A house using propane instead of natural gas for heating"
  
end EnergySimTest;
