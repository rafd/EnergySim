model HouseAsUsual
  extends GenericDwelling(UWall=0.28);
end HouseAsUsual;

model HouseAsInsulatedWell	//"A house that is well insulated with low U values"
  extends GenericDwelling(UWall=0.1,UWindow=0.07);
end   HouseAsInsulatedWell;

model HousePropaneHeating	//"A house ultilize propane instead of natural gas for heating"
  extends GenericDwelling(GasEnergy=25.3,GasPrice=0.615);
end   HousePropaneHeating;


