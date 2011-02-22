within EnergySim.System;

encapsulated package chp 

	model chpPlant "combined heat and power plant"
		parameter Real fuelPerTime = 300	"Fuel stocks in m^3 per time unit";
		parameter Real fuelLHV = 15 "Lower heating value of fuel in MJ/kg";
		parameter Real fuelDensity = 0.862 "Density in kg/m^3";
		parameter Real conversionEfficiency = 0.4 "Process efficiency from heat to electricity";
	    parameter Real gasPrice             = 0.1542	"Gas Price $/m^3";

		Real electricityPerTime = fuelPerTime * fuelLHV * fuelDensity * conversionEfficiency "Electricity per time unit in joules";
		Real heatPerTime = fuelPerTime * fuelLHV * fuelDensity * (1 - conversionEfficiency) "Heat per time unit in joules";
		Real heatWaste = 0 "Heat waste in joules";
		Real cumulativeFuel = 0;
		Real cumulativeCost = 0;
		
		equation
	
			der(cumulativeFuel) = fuelPerTime;
			cumulativeCost = cumulativeFuel * gasPrice;
	
	end chpPlant;

end chp;