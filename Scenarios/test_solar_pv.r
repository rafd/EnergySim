#source('~/Code/EnergySim/Scenarios/test_solar_pv.r')

data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

plot(data$time,data$com.bdg.solar_panel.P, cex=0.2)

