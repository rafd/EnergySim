model ClimateData
  Modelica.Blocks.Tables.CombiTable1Ds Climate(tableOnFile = true, tableName = "Climate", fileName = "../Data/toronto_climate_2010.txt",columns=2:11);
  
  //Real Month  = Climate.y[1] "Month of the year";
  //Real Day    = Climate.y[2] "Day of the month";
  Real T      = Climate.y[3]+273 "temperature in C";
  //Real DT     = Climate.y[4] "Dew Point Temperature in C";
  //Real RH     = Climate.y[5] "relative Humidity in %";
  //Real D      = 10*Climate.y[6] "wind direction in degree";
  Real V      = Climate.y[7]"wind speed in km/h";
  //Real Vis    = Climate.y[8]"Visibiliy in km";
  Real P      = Climate.y[9]"Standard Pressure in kPa";
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


model MiscQDevice //this excluded AC
    Modelica.Blocks.Tables.CombiTable2D spring(tableOnFile = true, tableName = "spring", fileName = "../Data/TateData.txt");
    Modelica.Blocks.Tables.CombiTable2D summer(tableOnFile = true, tableName = "summer", fileName = "../Data/TateData.txt");
    Modelica.Blocks.Tables.CombiTable2D fall(tableOnFile = true, tableName = "fall", fileName = "../Data/TateData.txt");
    Modelica.Blocks.Tables.CombiTable2D winter(tableOnFile = true, tableName = "winter", fileName = "../Data/TateData.txt");
    Real PowerUsage "in watts exclude AC";
    outer Real PowerAC "in watts, power usage of AC";
    Real DayofWeek;//1 is monday 7 is sunday
    Real HourofDay;//range (1:24)
    Real Month;
    
  equation
    
    DayofWeek= EnergySim.System.Time.day_of_week(time);
    HourofDay= EnergySim.System.Time.hour_of_day(time)+1;
    Month= EnergySim.System.Time.month_of_year(time);
    
    spring.u1=HourofDay;
    summer.u1=HourofDay;
    fall.u1=HourofDay;
    winter.u1=HourofDay;
    spring.u2=DayofWeek;
    summer.u2=DayofWeek;
    fall.u2=DayofWeek;
    winter.u2=DayofWeek;
    /*
    if Month>2 and Month <6 then
    PowerUsage=spring.y*1000;
    elseif Month>5 and Month<9 then
    PowerUsage=summer.y*1000; 
    elseif Month>8 and Month<12 then
    PowerUsage=fall.y*1000;
    else
    PowerUsage=winter.y*1000;
    end if;
    */
    PowerUsage+PowerAC=if Month>2 and Month <6 then spring.y*1000 elseif Month>5 and Month<9 then summer.y*1000 elseif Month>8 and Month<12 then fall.y*1000 else winter.y*1000;
end MiscQDevice;

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
  MiscQDevice miscQ;
  
  inner EnergySim.Temperature outside_temperature;
  inner Real WindSpeed;
  inner Real Patm;
  inner Real PowerAC;
  
  Real system_demand;
  
  equation
    //outside_temperature = 305;
    outside_temperature = climate_data.T;
    WindSpeed=(climate_data.V)/3.6;
    Patm=(climate_data.P)*1000;
    system_demand = demand_data.TotalDemand; 
    PowerAC=com.bdg.ac.i.P;
  
    connect(sys.i, com.o);
    connect(sys.o, com.i);
  
end Test;