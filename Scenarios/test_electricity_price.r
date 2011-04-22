
data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

plot(data$time, data$com.bdg.building_temperature-273, type="l", ylim=c(-25,30))
