within EnergySim.System;

encapsulated package MiscDevices "misc end-user devices, such as computers, tv, etc."

  function electricity_demand "electricity demand due to misc devices"
    input Time s "second value, since year start";
    
  end electricity_demand;
  
  function heat_generation "heat generated due to misc devices"
    input Time s "second value, since year start";
  
  end heat_generation;
  
end MiscDevices;