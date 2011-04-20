#source('~/Code/EnergySim/Scenarios/test_thermal.r')

data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

# black
plot(data$time, data$com.bdg.building_temperature-273, type="l", ylim=c(-25,30))

# red
points(data$time, data$outside_temperature-273, type="p", col=2, cex=0.2)

# pink
points(data$time, data$com.bdg.heater.Q*0.01, type="l", col=3)
points(data$time, data$com.bdg.ac.Q*0.01, type="l", col=4)

# blue
points(data$time, data$com.bdg.Q*0.01, type="l", col=5)

# yellow
points(data$time, data$com.bdg.P*0.01, type="l", col=6)

lnames <- c('temp_building', 'temp_outside', 'Q_heater', 'Q_ac', 'Q_building', 'P_building') 
legend('bottomleft', lnames, col = 1:6, lty = 1)