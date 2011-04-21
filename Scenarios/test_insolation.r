#source('~/Code/EnergySim/Scenarios/test_thermal.r')

data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

day <- 175;

plot(data$time, data$insolation, type="p", cex=0.2, xlim=c(3600*24*(day-1),3600*24*day))