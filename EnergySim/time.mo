within EnergySim;

encapsulated package Time // NOTE: NOT TESTED
  
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
  
  
  function day_of_week
    input Real time;
    output Real day;
    
    Integer first_day_of_year = 5; //1 = monday, 7 = sunday
    
    algorithm
      day := mod(floor(mod(time/86400, 7)) + first_day_of_year - 1, 7) + 1;
  end day_of_week;
  
  
  function month_of_year
    //86400
    input Real time;
    output Integer month;
    //dpm = [31, 28, 31, 30,  31,  30,  31,  31,  30,  31,  30, 31];
    Integer[12] dpp = {31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
    
    algorithm
      month := 1;
      for i in 1:12 loop
        if time < dpp[i]*86400 then
          month := i;
          break;
        end if;
      end for;  
        
  end month_of_year;

end Time;