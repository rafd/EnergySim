model SpecificBuilding
  extends EnergySim.Building.Building;

end SpecificBuilding;

model Sys
  extends EnergySim.System.System;
  extends EnergySim.System.getData;

end Sys;


model Com
  extends EnergySim.System.Community;
  
  SpecificBuilding bdg;
  
end Com;


model Test

  Sys   sys;
  Com   com;
  
  inner EnergySim.Temperature outside_temperature;
  inner Real WindSpeed10 "Windspeed at 10m Height in m/s";
  
  equation
    outside_temperature = sys.temperature;
    WindSpeed10=sys.V*0.277777778;
    connect(sys.i, com.o);
    connect(sys.o, com.i);
  
end Test;