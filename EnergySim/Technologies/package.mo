within EnergySim; 
encapsulated package Technologies
   
  "Technology package"
  import Modelica.SIunits.Energy;
  import Modelica.SIunits.Power;
  import Modelica.SIunits.Period;
  import Modelica.SIunits.Mass;
  import Modelica.SIunits.Voltage;
  
  //This model defines the power generating by wind turbine based on wind_ambient info. from region.
  //Created 2011/03/11
  //Default value are based on turbine model Southwest Windpower Skystream 3.7
  
  model wind_turbine
    import EnergySim.System.Region.*;
    
    parameter Mass GHG=2 "the GHG emission per unit manufactured in kg";
    parameter Height InstallHeight = 3 "the height where the wind turbine is installed";
    parameter Velocity CutIn=3.57 "the cut in speed of the wind turbine";
    parameter Velocity Rated=5.4 "the rated wind speed of wind turbine";
    parameter Power RatedPower= 2600 "The rated power output of the turbine in watt";
    parameter Real MechEfficiency =0.8 "the mechanical efficiency of the turbine";
    parameter Real ElecEfficiency =0.8 "the converter efficiency of the turbine";
    parameter Boolean DirectionBiased = false "if the turbine is direction biased";
    parameter Real CapitalCostFix=5400 "the fixed cost of buying and installing wind turbine";
    parameter Real CapitalCostVar=0 "the varied cost of buying and installing wind turbine";
    parameter Real OMCost=131.5/365/24/60/60 "Operating and Mantaining cost per second";
    parameter Period MTBF=20*365*24*60*60 "the mean time before failture of the turbine in seconds";
    parameter Real Depreciation=(CapitalCostFix+CapitalCostVar)/MTBF "the Depreciated value of wind turbine per seconds";
    parameter Voltage Vout= 240 "the voltage output of generate power in VAC";
    Real CurrentValue "the current value of the wind turbine";
    //Energy EnergyGen "the energy generated by the wind turine,unit J";
    //Power PowerGen "the instatanious power generated by the turbine,unit w";
        
   equation
     
     CurrentValue = (CapitalCostFix + CapitalCostVar)-Depreciation*time;
     
      
  end wind_turbine;
end Technologies;