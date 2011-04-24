model SpecificCommunityTechnology
  extends EnergySim.System.CommunityTechnology;
  extends EnergySim.System.EconomicTechnology(FixedCost=-1000);

  equation
    RunningCost = 0.01;
    P = -120;
    Q = 0;
        
end SpecificCommunityTechnology;


model SpecificBuildingTechnology
  extends EnergySim.BuildingTech.BuildingTechnology;
  extends EnergySim.System.EconomicTechnology(FixedCost=-60000);

  equation
    RunningCost = 0.01;
    P = -120;
    Q = 0;
    
end SpecificBuildingTechnology;


model SpecificBuilding
  extends EnergySim.Building.Building;
  
  SpecificBuildingTechnology tech[2];

end SpecificBuilding;


model Ontario
  extends EnergySim.System.System;

end Ontario;


model HarbordVillage
  extends EnergySim.System.Community;
  
  SpecificBuilding bdgs_a[3];
  SpecificBuilding bdgs_b[3];
  SpecificCommunityTechnology tech_a[2];
  SpecificCommunityTechnology tech_b[2];
  
end HarbordVillage;


model Basics

  Ontario           sys;
  HarbordVillage    com;
  
  Real day = floor(time / 86400);
  
  inner EnergySim.Temperature outside_temperature;
  
  equation
    outside_temperature = sys.temperature;
  
    connect(sys.i, com.o);
    connect(sys.o, com.i);
  
end Basics;