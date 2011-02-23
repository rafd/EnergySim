within EnergySim.Technologies;

encapsulated package Solar
  import SI = Modelica.SIunits;
 
  function solar_water_heater
//http://www.infinitepower.org/calc_waterheating.htm
//http://practicalaction.org/practicalanswers/product_info.php?products_id=166

    constant SI.WaterTemperature max_pref = 40 + 273;
    constant SI.WaterTemperature min_pref = 25 + 273;

    input    SI.Temperature t_outside;
    output   SI.Temperature result;

/*
    algorithm
        if t_outside > max_pref then result := max_pref;
        elseif t_outside < min_pref then result := min_pref;
        else result := t_outside;
        end if;
*/
  end solar_water_heater;

  model solar_pv
    
    /*
    constant Real Longitude = 79.62; //Longitude of Toronto's Annex Community
    constant Real Latitude = 43.58; //Latitude of Toronto's Annex Community
    constant Real Clearness = 1; //Clearness number
    constant Real Sky_diffuse_factor = 1; //Sky diffuse factor
    constant Real Reflectivity = 0.8; //Sky diffuse factor

    
    input Real Collector_tilt_angle "Collector Tilt Angle in Degrees";
    input Real Collector_azimuth_angle "Collector Azimuth Angle in Degrees";
    input Real Clearness "Clearness";
    input Real Solar_efficiency "Solar Efficiency";
    */
    
    parameter Real Solar_efficiency = 0.15 "Solar Efficiency";//Takes into account overall efficiency
    parameter Real Area_of_collector = 1 "Area of the Solar Collector";
    parameter Real Solar_Insolation = 300 "Solar Insolation";
    
    Real Electricity "Electricity";
    
    equation
    
      Electricity=Solar_efficiency*Area_of_collector*Solar_Insolation;

  end solar_pv;

  
end Solar;