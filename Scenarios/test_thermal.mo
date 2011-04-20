model SpecificBuilding
  extends EnergySim.Building.Building;

end SpecificBuilding;

model Sys
  extends EnergySim.System.System;

end Sys;


model Com
  extends EnergySim.System.Community;
  
  SpecificBuilding bdg;
  
end Com;


model Test

  Sys   sys;
  Com   com;
  
  inner EnergySim.Temperature outside_temperature;
  
  equation
    outside_temperature = sys.temperature;
  
    connect(sys.i, com.o);
    connect(sys.o, com.i);
  
end Test;