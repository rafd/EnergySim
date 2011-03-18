within EnergySim; 
encapsulated package Technologies
  "Technology package"
  import Modelica.SIunits.*;
  
  
  // UNITS
  
  type FixedCost = Real(final quantity="Fixed Cost", final unit="$");
  type VariableCost = Real(final quantity="Variable Cost", final unit="$/year");
  type Power = Real(final quantity="Power", final unit="J");
  
  
  // CONNECTORS (PORTS)
  
  connector EconomicPort
    FixedCost fixed_cost "Fixed cost in dollars.";
    //flow Cost variable_cost "Variable cost, in dollars/year"
  end EconomicPort;
  
  
  connector ThermalPort
    Temperature T "Temperature in [K]";
    //flow Modelica.SIunits.HeatFlux q "Heat flux";
  end ThermalPort;
  
  
  connector RadiativePort
    //Real I "intensity";
    //flow _ _ "flux";
  end RadiativePort;
  
  
  connector ElectricPort
    flow Power P "power flowing into the port";
  end ElectricPort;
  
  
  // GENERIC DEVICES
  
  partial model GenericDevice
    
  end GenericDevice;
  
  
  partial model EconomicDevice
    extends GenericDevice;
    
    //EconomicPort economic_in;
    EconomicPort economic_out;
    
  end EconomicDevice;
  
  
  partial model ElectricDevice
    extends GenericDevice;
    
    //ElectricPort electric_in;
    //ElectricPort electric_out;
    
    Power power_demand;
    
    equation
      //power_demand = electric_in.P - electric_out.P;
    
  end ElectricDevice;
  
  
  partial model ThermalDevice
    extends GenericDevice;
    
    Temperature delta_T "temperature drop between thermal_in and thermal_out";
    //Current i "current flow from elec_in to elec_out"
    
    ThermalPort thermal_in;
    ThermalPort thermal_out;
    
    equation
      delta_T	= thermal_in.T - thermal_out.T; 
      //0 = elec_in.i + elec_out.i; 
      //i = elec_in.i;
    
  end ThermalDevice;
  
  
  partial model RadiativeDevice
    extends GenericDevice;

    // TODO
    
  end RadiativeDevice;
  
  
  // HOUSE
  
  partial model EconomicHouse
    extends EconomicDevice;
    
    //outer EconomicPort env_fixed_cost;
    
    FixedCost fixed_cost = 2000;
    input Real cost = 0;
    
    equation
      //economic_in.fixed_cost = cost;
      economic_out.fixed_cost = fixed_cost; //economic_in.fixed_cost + fixed_cost;
      //connect(economic_out, env_fixed_cost);
      
  end EconomicHouse;
  
  
  partial model ElectricHouse
    extends ElectricDevice;
    
    //flow Power power = 10;
    //Power house_power_draw(start=0);
    
    //algorithm
      //house_power_draw := house_power_draw + 5;
    initial equation
      power_demand = 0;
    equation
      //electric_out.P = power;
      //power_demand = house_power_draw;
    
    
      
    
  end ElectricHouse;
  
  
  partial model ThermalHouse
    extends ThermalDevice;
    
    outer ThermalPort env_thermal;
    
    equation
      connect(thermal_in, env_thermal);
      
      thermal_out.T = thermal_in.T;
  
  end ThermalHouse;
  
  
  partial model RadiativeHouse
    extends RadiativeDevice;
    
  end RadiativeHouse;
  
  
  model House
    extends ElectricHouse;
    
  end House;
  
end Technologies;