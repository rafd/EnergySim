/*
  Neighbourhood simulation to test all features of EnergySim library.
*/

model Timing
  import EnergySim.System.TimeConversions.*;

  Real hour = hour_of_day(time);
  Real day = day_of_year(time);
  Real week = week_of_year(time);
end Timing;
