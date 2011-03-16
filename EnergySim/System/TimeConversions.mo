within EnergySim.System;

encapsulated package TimeConversions
  
  function hour_of_day
    input Real s "second value, since year start";
    output Real hour "hour, since day start";
  
    algorithm
      hour := floor(mod(s, 86400) / 3600);
  end hour_of_day;

  function day_of_year
    input Real s "second value, since year start";
    output Real day "day, since year start";
  
    algorithm
      day := floor(s / 86400);
  end day_of_year;

  function week_of_year
    input Real s "second value, since year start";
    output Real week "week, since year start";

    algorithm
      week := floor( s / (86400 * 7));
  end week_of_year;

end TimeConversions;