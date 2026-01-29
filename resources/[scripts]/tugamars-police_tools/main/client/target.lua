ISOXT, ISQBT=false;
OXT="ox_target";
QBT="qb-target";

if(GetResourceState(OXT) == "started" and Config.General.Target == "ox_target") then ISOXT=true; Log("Target system: ox-target"); end
if(GetResourceState(QBT) == "started" and Config.General.Target == "qb_target") then ISQBT=true; Log("Target system: qb_target"); end
