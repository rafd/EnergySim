

model ClimateData
  Modelica.Blocks.Tables.CombiTable1Ds Climate(tableOnFile = true, tableName = "Climate", fileName = "../Data/toronto_climate_2010.txt",columns=2:11);
  
  //Real Month  = Climate.y[1] "Month of the year";
  //Real Day    = Climate.y[2] "Day of the month";
  Real T      = Climate.y[3]+273 "temperature in C";
  //Real DT     = Climate.y[4] "Dew Point Temperature in C";
  //Real RH     = Climate.y[5] "relative Humidity in %";
  //Real D      = 10*Climate.y[6] "wind direction in degree";
  //Real V      = Climate.y[7]"wind speed in km/h";
  //Real Vis    = Climate.y[8]"Visibiliy in km";
  //Real P      = Climate.y[9]"Standard Pressure in kPa";
  //Real WC     = Climate.y[10] "WindChill";
  
  equation 
    Climate.u=time/60/60;

end ClimateData;

model DemandData
  Modelica.Blocks.Tables.CombiTable1Ds Demand(tableOnFile = true, tableName = "Demand", fileName = "../Data/ontario_electricity_demand.txt",columns=2:4);
  
  Real TotalDemand    = Demand.y[1] "total demand";
  //Real OntarioDemand  = Demand.y[2] "Ontario Demand";
  //Real PredictDemand  = Demand.y[3] "Predicted demand for this hour";
  
  equation
    Demand.u = time/60/60;
  
end DemandData;




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
  
  ClimateData climate_data;
  DemandData demand_data;
  
  inner EnergySim.Temperature outside_temperature;
  
  Real system_demand;
  
  equation
    outside_temperature = climate_data.T;
    system_demand = demand_data.TotalDemand; 
  
    connect(sys.i, com.o);
    connect(sys.o, com.i);
  
end Test;