type Temperature = Real;



function system_temperature
  input    Real         time;
  output   Temperature  result "Outside Temperature in Kelvin";
  
  constant Real seconds_in_day = 86400;
  constant Real seconds_in_year = 31536000;
  
  Real max_T = 33;
  Real min_T = -17+5;
  Real days_to_peak = 189; // July 8
  
  Real a = (max_T - min_T) / 2; //magnitude
  Real b = (Modelica.Constants.pi * 2) / seconds_in_year; //period
  Real c = days_to_peak * seconds_in_day; //x-offset right
  Real d = a + min_T; //y-offset up
  
  Temperature x, y;
  
  algorithm
   
    x := 0.9 * a * cos(b*(time-c)) + d + 273; //daily extremes
    y := 5 * cos((b*365)*(time-seconds_in_day/2)) - 5; //daily variation of 5 deg
    result := x + y;
end system_temperature;



model ThermalBuilding
  Real Q "Heat Energy";
  Temperature T "Temp, in Kelvin";
  Real C_p = 1.012;
  Real M = 100;
  
  Real conduction_in;
  Real T_out = system_temperature(time);
  
  Boolean heater_on(start=false);
  Real heater_power;
  //Real hp_new;
  
  initial equation
    Q = M*C_p*T;
    T = 300;
    
  equation
    Q = M*C_p*T;
    
    conduction_in =  (T_out - T)/250.0;
    
    if heater_on then
      heater_power = 0.2;
    else 
      heater_power = 0;
    end if;
    
    der(Q) = conduction_in + heater_power;
    
    //heater_power = 0;
    
    when {T < 20+273, T > 22+273} then
      heater_on = T < 20+273;
      //hp_new = if heater_on then 0.25 else 0;
      //reinit(heater_power, hp_new);
    end when;
      
    
  

end ThermalBuilding;