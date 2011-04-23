model Test
  Real price;
  
  equation
  
    price = EnergySim.System.electricity_price(time);
  
end Test;