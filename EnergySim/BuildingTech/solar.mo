within EnergySim.Technologies;

// NOTE: NOT TESTED

encapsulated package Solar
  import SI = Modelica.SIunits;
/* 
 function DayOfYear (month, day) {
     input integer month;
     input integer day;
     integer dayOfYear;
     
     integer monthday;
 
     if month==1,3,5,7,8,10,12
     monthday=(month*31);
     
     if month==2
     monthday=31+day;
     
     if month ==3
     monthday=31+28+day;
     
     if month ==4
     monthday=31*2+28+day;
     
     if month ==5
     monthday=31*2+28+30+day;
     
     if month==6
     monthday=31*3+28+30+day;
     
     if month ==7
     monthday=31*3+30*2+28+day;
     
     if month==8
     monthday=31*4+30*2+28+day;
     
     if month==9
     monthday=31*5+30*2+28+day;
     
     if month==10
     monthday=31*5+30*3+28+day;
     
     if month==11
     monthday=31*6+30*3+28+day;
     
     else
     monthday=31*6+30*4+28+day;
  
     DayOfYear=(month-1)*30+day;//approximation of the day of the year
     
     return DayOfYear;
}
*/
  function solar_insolation
    input Real collector_tilt_angle, azimuth_angle, solar_eff, inv_eff;
    input Real longitude, latitude, clearness, sky_diffuse_factor;
    input Real reflectivity;
    
    output Real radiation;
    
    algorithm
      radiation := 829.8711835;
    
  end solar_insolation;
 
 
  

  model solar_pv
    import EnergySim.System.TimeConversions.*;
    
    constant Real Longitude = 79.62; //Longitude of Toronto's Annex Community
    constant Real Latitude = 43.58; //Latitude of Toronto's Annex Community
    constant Real Clearness = 1; //Clearness number
    constant Real sky_diffuse_factor = 1; //Sky diffuse factor
    constant Real Reflectivity = 0.8; //Sky diffuse factor
    
    input Real Collector_tilt_angle = 55 "Collector Tilt Angle in Degrees";
    input Real Collector_azimuth_angle = 80 "Collector Azimuth Angle in Degrees";
    input Real Solar_efficiency = 0.15 "Solar Efficiency";
    input Real Area_of_collector = 1 "Area of the Solar Collector";
    
    parameter Real Solar_Insolation = 300 "Solar Insolation";
    parameter Real inv_eff = 0.95;
    
    
    Real hour = hour_of_day(time);
    Real day = day_of_year(time);
    Real week = week_of_year(time);
    
    Real Output_Electricity "Electricity";
    
    equation
      Output_Electricity= Solar_efficiency *Area_of_collector*inv_eff*solar_insolation(Collector_tilt_angle, Collector_azimuth_angle, Solar_efficiency, inv_eff,
  Longitude, Latitude, Clearness, sky_diffuse_factor,Reflectivity);
    
  end solar_pv;
/*
 model solar_water_heater
  
//http://www.infinitepower.org/calc_waterheating.htm
//http://practicalaction.org/practicalanswers/product_info.php?products_id=166

    constant SI.WaterTemperature max_pref = 40 + 273;
    constant SI.WaterTemperature min_pref = 25 + 273;

    input    SI.Temperature t_outside;
    output   SI.Temperature result;


    algorithm
        if t_outside > max_pref then result := max_pref;
        elseif t_outside < min_pref then result := min_pref;
        else result := t_outside;
        end if;

  end solar_water_heater;

  */
end Solar;