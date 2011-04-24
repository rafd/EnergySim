model Test
  import Modelica.Blocks.Sources;
  import Modelica.Blocks.Tables;
  
  Tables.CombiTable1Ds january_weather(tableOnFile = true, tableName = "tab1", fileName = "../Data/toronto_weather_jan.txt", columns=2:5);
  
  Real T "temperature in C";
  Real RH "relative Humidity in %";
  Real D "wind direction in degree";
  Real V "wind speed in km/h";
  
equation 
  january_weather.u = time/60/60;
  T = january_weather.y[1];
  RH = january_weather.y[2];
  D = january_weather.y[3];
  V = january_weather.y[4];

end Test;
