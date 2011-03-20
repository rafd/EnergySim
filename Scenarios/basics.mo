encapsulated package EnergySim
  
  type Power = Real(final quantity="Power", final unit="J");
  
  
  connector MultiPort
    flow Power P;
  end MultiPort;
  
  
  partial model MultiDevice
    MultiPort i;
    MultiPort o;
    
    Power P "power produced";
    
    equation
      P = o.P - i.P;
    
  end MultiDevice;
  
  
  model System
    extends MultiDevice;

    MultiPort ground;
      
    equation
      connect(i, ground);
    
  end System;


  model Community
    extends MultiDevice;
    
    inner MultiPort comm_io;
    
    equation
      connect(i, comm_io);
      connect(i, o);
    
  end Community;


  model Technology
    extends MultiDevice;

  end Technology;


  model Building 
    extends MultiDevice;
    outer MultiPort comm_io;

    equation
      P = -120;
      connect(comm_io, i);
  end Building;

end EnergySim;

/////////

model Ontario
  extends EnergySim.System;

end Ontario;


model HarbordVillage
  extends EnergySim.Community;
  
  EnergySim.Building buildings[10];
  
end HarbordVillage;


model Basics
  
  Ontario           system;
  HarbordVillage    community;
  
  equation
    connect(system.i, community.o);
    connect(system.o, community.i);
  
end Basics;