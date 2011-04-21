model Test
  Real insolation;
  
  equation
    insolation = EnergySim.System.system_solar_insolation(time); 
end Test;