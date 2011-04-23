within EnergySim.BuildingTech; 
encapsulated package Wind
"Wind Technology Building Package"
import EnergySim.*;

  model WindTurbine
    extends System.BuildingTech.BuildingTechnology;
    extends System.EconomicTechnology(FixedCost=60000);
    
    parameter Real InstallHeight = 5.5 "the height where the wind turbine is installed m";
    parameter Real CutInSpeed=0 "the cut in speed of the wind turbine m/s";
    parameter Real RatedSpeed=10.72 "the rated wind speed of wind turbine m/s";
    parameter Real alpha=0.27 "hellsman constant for unstable air above human inhabitat area";
    parameter Real RatedPower=1000 "Rated Poweroutput at Rated windspeed W";
    Real WindSpeed(start=3) "windspeed seen by rotor at install height m/s";
    Real WindEnergy "Energy Generated from Wind in kWh";
    
    outer Real WindSpeed10 "windspeed at 10m";
    
    
  equation
    
    WindSpeed=WindSpeed10*(InstallHeight/10)^alpha;
    
/*    when {WindSpeed<=RatedSpeed,WindSpeed>=CutInSpeed} then
      P=0.6*(WindSpeed)^3;     
    elsewhen {WindSpeed>RatedSpeed} then
      P=RatedPower;     
    elsewhen {WindSpeed<CutInSpeed} then
      P=0;
    end when; 
*/

    P=0.6*(WindSpeed)^3;   
     
    der(WindEnergy)=P*2.7777777777777776e-7;
    
    Q = 0;
    RunningCost = 0;
    
  end WindTurbine;

end Wind;