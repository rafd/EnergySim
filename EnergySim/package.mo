within; 
encapsulated package EnergySim
  "EnergySim root package"
  
  type ElectricPower = Real(final quantity="Power", final unit="J/s");
  type ThermalPower = Real(final quantity="Power", final unit="J/s");
  type ThermalEnergy = Real(final quantity="Energy", final unit="J");
  type NaturalGasPower = Real(final quantity="Power", final unit="J/s");
  type GHGRate = Real(final quantity="Grams/kWh", final unit="gC02eq/kwh");
  type Temperature = Real;
  type State = Real;
  type Cost = Real;
  
  constant Real seconds_in_day = 86400;
  constant Real seconds_in_year = 31536000;
  
  
  /* UTILITY FUNCTIONS */
  
  function radians
    input Real inp;
    output Real out;
     
    algorithm
      out := inp * 2 * Modelica.Constants.pi/360;
  end radians;
   
  function degrees
    input Real inp;
    output Real out;
    
    algorithm
      out := inp * 0.5 * 360/Modelica.Constants.pi;
  end degrees;
  
end EnergySim;