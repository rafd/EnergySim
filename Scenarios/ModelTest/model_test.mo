/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

connector RealInput = input Real;

connector HeatPort
  Modelica.SIunits.Temp_K         T   "Temperature in [K]";
  //flow Modelica.SIunits.HeatFlux  q   "Heat flux";
end HeatPort;

model Community
  inner HeatPort envHeat;
  RealInput temp = 300;
  RealInput qu = 3;
  
  equation
    temp = envHeat.T;
    //qu = envHeat.q;
end Community;


partial model ThermalHouse
  outer HeatPort envHeat;
  HeatPort heat;

  equation
    connect(heat, envHeat);
end ThermalHouse;


partial model ElectricHouse

end ElectricHouse;


model House
  extends ThermalHouse;
  extends ElectricHouse;  
  
end House;

model TenHouses
  House house_vec[10];
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
