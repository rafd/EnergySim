/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

model TenHouses
  EnergySim.Technologies.House house_vec[10];
end TenHouses;

model EnergySimTest
  import EnergySim.Technologies.*;
  //import EnergySim.System.TimeConversions.*;
  
  extends EnergySim.System.Environment;
  
  
  Real Hour = floor(mod(time, 86400) / 3600);
  //Real fixed_cost;
  flow Current current_in;// = 20;
  flow Current current_out;
  
  //Real day = day_of_year(time);
  //Real week = week_of_year(time);
  
  public
    House       house;
    
  
  equation
    house.electric_in.v = 240;
    house.electric_in.i = current_in;
    house.electric_out.i = current_out;
    //house.electric_in.v = env_electric_in.v;
    //house.electric_out.v = env_electric_out.v;
    //connect(house.electric_out, env_electric_out);
  //algorithm  
    
    //Dwelling    house_usual(UWall=0.28);
    //Dwelling    house_well_insulated(UWall=0.1,UWindow=0.07);         //"A house that is well insulated with low U values"
    //Dwelling    house_propane_heating(GasEnergy=25.3,GasPrice=0.615); //"A house using propane instead of natural gas for heating"
  
end EnergySimTest;
