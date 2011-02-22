within EnergySim.System;

encapsulated package TimeConversions
  
  function hour_of_day
    input Time s "second value, since year start";
    output Integer hour "hour, since day start";
  
    algorithm
      hour := mod(s,86400) / 86400;
  end hour_of_day;

  function day_of_year
    input Time s "second value, since year start";
    output Integer day "day, since year start";
  
    algorithm
      day := s / 86400;
  end day_of_year;

  function week_of_year
    input Time s "second value, since year start";
    output Integer week "week, since year start";

    algorithm
      week := s / (86400 * 7);
  end week_of_year;

end TimeConversions;