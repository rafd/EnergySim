within EnergySim.System;

encapsulated package Occupants
  import SI = Modelica.SIunits;
  
  function preferred_temperature

    constant SI.Temperature max_pref = 25 + 273;
    constant SI.Temperature min_pref = 18 + 273;

    input    SI.Temperature t_outside;
    output   SI.Temperature result;

    algorithm
        if t_outside > max_pref then result := max_pref;
        elseif t_outside < min_pref then result := min_pref;
        else result := t_outside;
        end if;

  end preferred_temperature;

  function heat_generation "heat generated due to misc devices"

  end heat_generation;

  function occupancy "number of people in household as a function of time"
    //make this up
  end occupancy;

end Occupants;