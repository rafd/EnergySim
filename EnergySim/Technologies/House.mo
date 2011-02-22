within EnergySim.Technologies;
package Something
model House
	parameter Real k, area, wall_thickness, volume;
	parameter Real air_heat_capacity = 1.297;
	parameter Real t_in, t_out;
	Real heat;
equation
	heat = volume * air_heat_capacity;
	der(t_in) =  k*area/wall_thickness*(t_out-t_in);.
end House;
end Something;