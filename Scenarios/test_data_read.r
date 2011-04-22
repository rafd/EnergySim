#source('~/Code/EnergySim/Scenarios/test_data_read.r')

data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

plot(data$time, data$T, type="p", cex=0.2)
points(data$time, data$RH, type="p", cex=0.2, col=2)
points(data$time, data$D, type="p", cex=0.2, col=3)
points(data$time, data$V, type="p", cex=0.2, col=4)