within EnergySim;

encapsulated package System
  import Modelica.SIunits.Temperature;


  encapsulated package Grid

    function electricity_demand

    end electricity_demand;

  end Grid;


  encapsulated package Region
    import Modelica.SIunits.Temperature;
    
    function temperature_outside
      input    Real         time;
      output   Temperature  result "Outside Temperature in Kelvin";

      algorithm
        result := -28 * cos(Modelica.Constants.pi / 6 * (time - 1)) - 5 + 273;
    end temperature_outside;

  end Region;

  function temperature_delta

    input  Real         time;
    output Temperature  result;

    algorithm
      result := Occupants.preferred_temperature(Region.temperature_outside(time)) - Region.temperature_outside(time);

  end temperature_delta;

  //"Condition: Time = "month, i.e time=12 means 12 months"
  //"Assumption: Annual temperature variation based on sinusoidal wave functions, ignore fluctuation within one month"
  //"Assumption: Heating efficiency is 40%"

  model Dwelling "generic dwelling model"

    parameter Real BuildingSurfaceArea  = 400     "Building Surface Area in m^2";
    parameter Real PercentageWindow     = 0.1		  "Percentage of window on building surface";
    parameter Real HeightOfFloor        = 2		    "Height of Floor in m";
    parameter Real WallThickness        = 0.3		  "WallThickness in m";
    parameter Real HeatingEfficiency    = 0.4	    "Heating Effciency";
    parameter Real GasEnergy            = 37.5		"Natural Gas Energy Content when combusted MJ/m^3";
    parameter Real UWall                = 0.29		"U factor for walls";
    parameter Real UWindow              = 0.18	  "U factor for windows";
    parameter Real InsWallThickness     = 0.1	    "wallthickness added by insulation";		
    parameter Real GasPrice             = 0.1542	"Gas Price $/m^3";
	
    Real SpaceReq     = (InsWallThickness * BuildingSurfaceArea) / HeightOfFloor  "Space Required for Heating";
    Real HeatCapReq   "Instantanoues Heating Capacity Required in Joule";
    Real HeatCapTot   "Accumulated Heating load in MJoule since t=0";		

    Real HeatCost       "Instantanous Heating Cost in $";
    Real AccuHeatCost	  "Accumulated Heating Cost since t=0";
    Real OutsideTempC	  "Outside Temperature in Celcius";	

    equation 

      HeatCapReq = 	UWall * BuildingSurfaceArea * (1 - PercentageWindow) * temperature_delta(time) + 
    		UWindow * BuildingSurfaceArea * PercentageWindow * temperature_delta(time);
			
      der(HeatCapTot) = HeatCapReq * 24*60*60*30 / 1000000;	
				
      AccuHeatCost = (HeatCapTot / GasEnergy * GasPrice) / HeatingEfficiency;

      HeatCost = der(AccuHeatCost);

      OutsideTempC=Region.temperature_outside(time)-273;

  end Dwelling;

end System;