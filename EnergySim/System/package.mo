within EnergySim;

encapsulated package System
  import Modelica.SIunits.Temperature;


  encapsulated package Grid

    function electricity_demand

    end electricity_demand;

  end Grid;


  encapsulated package Region
    import Modelica.SIunits.Temperature;
    import Modelica.SIunits.Time;
    import Modelica.SIunits.Height;
    import Modelica.SIunits.Velocity;
    import Modelica.SIunits.Conversions.to_day;
   
    //================================================================================================
    //Model for simulate ambient temperature of the region
    //0 Celsius = 273 Kelvin
    //1 month = 30 days
    //Time Units: Seconds 
    //Temperature Units: Kelvin
    //Created by Kun Xie 2010/03/07
    //================================================================================================
    model temperature_ambient
      
      "Temperature Group"
      parameter Temperature MaxTempYear=295 "Max Daily Average Temperature of the Year";
      parameter Temperature MinTempYear=268.5 "Min Daily Average Temperature of the Year";
      parameter Temperature DailyFluctuation=9 "Temperature different within a day";
      parameter Integer PeakMonth=7 "Month where the Peak Temperature is (01~12)";
      parameter Temperature TemperatureIncremental=0.2 "Annual Increase in average temperature due to climate change";
      parameter Height RefHeightT = 134 "reference height at where temperature is measured";
      Temperature TemperatureYear "Temperature profile for a Year,start at Jan/01";
      Temperature TemperatureDay "Temperature profile for a day,start at 0:00";
      Temperature TemperatureChange "Annual Base Temperature Change";
      Temperature TemperatureAmbient "Modeled Ambient Temperature";
      
    equation
      TemperatureChange = MaxTempYear - MinTempYear;
      
      //Assumption: Daily Average Temperature follows sinosoidal curve with min at 2:00 and max at 13:00
      TemperatureDay = (DailyFluctuation/2)*sin((2*Modelica.Constants.pi/24)*(time/60/60-2));
      
      //Assumption: PeakTemperature at middle of the month
      //Assumption: Annual Temperature follows sinosoidal path.   
      TemperatureYear = (TemperatureChange/2)*cos((2*Modelica.Constants.pi/12)*(time/60/60/24/30-(PeakMonth+0.5)))+((MaxTempYear+MinTempYear)/2-273)+(TemperatureIncremental*time/60/60/24/30/12);
      
      //Assumption: Constant daily flunctuation all year round.
      TemperatureAmbient  = TemperatureYear +TemperatureDay "in celsius for intuition";   
    
    end temperature_ambient;
  
  
    //================================================================================================
    // Model for ambient wind of the region, consist of specs of wind speed distribution, probability of direction
    // Future Goal to generate wind speed on hourly bases,direction dynamics based on parameters
    // Hopefully this will be realized with some random number generate function I can find online
    // Default data are from Canada wind atlas for postal code Annex M5R3G5
    // Created by Kun Xie 2010/03/07
    // Added Wind Roses expression
    //================================================================================================ 
    
    model wind_ambient
     
      
        parameter Height RefHeightW=50 "in m, refrence height where the wind speed is measured";
        parameter Velocity RefMeanVelocity=4.15  "in m/s, the mean wind velocity at reference height";
        parameter Real WelburShape=1.81 "welbur shape parameter at reference";
        parameter Real WelburScale=4.67 "welbur scale parameter at reference";
        parameter Real Roughness = 0.25 "roughness factor affecting vertical velocity profile";
        parameter Real Roses[12]={0.102325,0.0388489,0.0067749,0.0516968,0.0908508,0.086731,0.139404,0.1922,0.16925,0.0388184,0.0483398,0.0309143};
        //numerical values to discribe wind roese start at 0 for north and 30 degrees apart, clockwise direction, default value is for Annex.
    
    
    equation
        
    end wind_ambient;

    //================================================================================================
    // Model for describing solar influx of the region of the region
    // Input: Local standard time, Longitude/Latitude of the location
    // Output: DynamicSolarInsulation W/m^2
    // Default data are from Annex
    // Created by Kun Xie 2010/03/07
    // Added Wind Roses expression
    //================================================================================================ 

  
   model solar_influx
      parameter Time LST=12*60*60 "local standard time in seconds, default value 12:00:00 PM";
      parameter Real STML=75 "Standard Time Meridian Longitude";
      parameter Real Longitude = 79.62 "longitude of location";
      parameter Real Latitude = 43.58 "latitude of locatoin";
      parameter Real OpticalDepth = 0.144 "local optical depth";
      parameter Real Reflectivity = 0 "reflectivity around the subject of interest, 0.8 for snow, 0.2 for grass";
      parameter Real SkyDiffuseFactor = 0.08 "radiation factors diffused from sky";
      parameter Real DegreeToRad=2*Modelica.Constants.pi/360 "the degree to rad conversion factor";
      Real DayOfTheYear;
      Real B "intermediate vairiable for calculation, unit Rad";
      Real ET "intermediate vairiable for calculation, unit Min";
      Real Solartime "time of the day that solar influx existed, unit Min"; 
      Real HourAngle ;
      Real SolarDeclination;
      Real SolarAltitudeAngle;
      Real SolarAzumuthAngle;
      Real DynamicSolarInsolation;
      
      equation
      
      DayOfTheYear = integer(time/24/60/60);
      B=360*(DayOfTheYear-81)/364*DegreeToRad;
      ET= 9.81*sin(2*B)-7.53*cos(B)-1.55*sin(B);
      Solartime = (LST+ET+(STML-Longitude))/60;
      HourAngle=(Solartime-12*60)/4;
      SolarDeclination=23.45*sin(360*(284+DayOfTheYear)/365*DegreeToRad);
      SolarAltitudeAngle=(1/DegreeToRad)*asin(sin(Latitude*DegreeToRad)*sin(SolarDeclination*DegreeToRad)+cos(Latitude*DegreeToRad)*cos(SolarDeclination*DegreeToRad)*cos(HourAngle*DegreeToRad));
      SolarAzumuthAngle=(1/DegreeToRad)*asin(cos(SolarDeclination*DegreeToRad)*sin(HourAngle*DegreeToRad)/cos(SolarAltitudeAngle*DegreeToRad));
      DynamicSolarInsolation=1353*(1+0.034*cos(360*DayOfTheYear/365.25*DegreeToRad));
      
    end solar_influx;
    
    
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
