data <- read.csv("~/Code/EnergySim/Scenarios/ThermalBuilding_res.csv", sep=",", head=TRUE)


plot(data$time, data$T-273, type="l", ylim=c(-25,30), xlim=c(0,86400))

#lines()
points(data$time, data$T_out-273, type="l", col="#FF0000")
points(data$time, data$heater_power/500, type="l", col="#FF00FF")