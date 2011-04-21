within EnergySim.BuildingTech;

encapsulated package Solar
  
  import EnergySim.*;
  
  model solar_pv_panel
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    
    Real tilt_angle = 39.0;
    Real azimuth_angle = 0.0;
    Real panel_efficiency = 0.15;
    Real inverter_efficiency = 0.95;
    Real size = 2; // m2
  
    equation
      Q = 0;
      RunningCost = 0;
      P = panel_efficiency*inverter_efficiency*size*EnergySim.System.system_solar_insolation(time, tilt_angle, azimuth_angle);
      
  end solar_pv_panel;
  
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