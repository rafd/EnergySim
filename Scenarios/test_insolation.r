#source('~/Code/EnergySim/Scenarios/test_thermal.r')

data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

plot(data$time, data$insolation, type="l")