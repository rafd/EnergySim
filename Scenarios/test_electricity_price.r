
data <- read.csv("~/Code/EnergySim/Scenarios/Test_res.csv", sep=",", head=TRUE)

#winter
plot(data$time, data$price, xlim=c(86400*7*0, 86400*7*1), type="s")

#summer
points(data$time - 86400*7*30, data$price, xlim=c(86400*7*30, 86400*7*31), type="s", col=3)
