source("/Applications/R.app/Contents/Resources/GUI-tools.R")
library(zoo)

quartz();

if(.Platform$OS.type=="windows") {
  quartz<-function() windows()
}

data <- read.csv("~/Code/EnergySim/Scenarios/Basics_res.csv", sep=",", head=TRUE)

zoo_data <- zoo(data) #TODO: use a subset of data, not all of it

daily_averages <- aggregate(zoo_data, zoo_data$day, mean)
daily_averages <- daily_averages[0:365]

col0margin <- c(0,0,1,0)
margin <- c(3,2,3,0)

col_annot = "#999999"
col_lines = "#000000"

samples_per_day = 48
seconds_per_hour = 3600
samples_per_year = samples_per_day*365

summer_day_range = floor(188/365*samples_per_year):floor(189/365*samples_per_year)
winter_day_range = floor(7/365*samples_per_year):floor(8/365*samples_per_year)
fallspring_day_range = floor(98/365*samples_per_year):floor(99/365*samples_per_year)

row.names(data) <- data$time
plot.new()                    
  #par(omi=c(0,0,0,0))                      #outer margins 
  par(mfrow=c(8,5))                        #number of rows and columns
  par(cex=0.5)            #label size
  par(bty="n")            #box type = none
  par(las=1)              #label alignment = always horiz
  par(col = col_lines, col.axis=col_annot, col.lab=col_annot, col.main=col_annot, col.sub=col_annot)


####### TEMPERATURE

par(mar=col0margin)
plot.new()
title(main="Temperature")#, line=-5)
par(mar=margin)

# temperature yearly
plot(daily_averages$system.T-273,type='l', xlab="", ylab="C", axes=F, ylim=c(-20, 40))
title(main="Yearly")
axis(1, at=0:11*31536000/12, labels=c("J","F","M","A","M","J","J","A","S","O","N","D"),tick=T, col=col_annot)
axis(2, col=col_annot)

# temperature summer
plot(data$time[summer_day_range], data$system.T[summer_day_range]-273, type='l',  xlab="", ylab='kW', axes=F, ylim=c(-20, 40))
axis(1, col=col_annot, at=0:24*seconds_per_hour+data$time[summer_day_range][1], labels=0:24)
axis(2, col=col_annot)
title(main="Summer Day")

# temperature winter
plot(data$time[winter_day_range], data$system.T[winter_day_range]-273, type='l', xlab="", ylab="", axes=F, ylim=c(-20, 40))
axis(1, col=col_annot, at=0:24*seconds_per_hour+data$time[winter_day_range][1], labels=0:24)
title(main="Winter Day")

# temperature fall/spring
plot(data$time[fallspring_day_range], data$system.T[fallspring_day_range]-273, type='l', xlab="", ylab="", axes=F, ylim=c(-20, 40))
axis(1, col=col_annot, at=0:24*seconds_per_hour+data$time[fallspring_day_range][1], labels=0:24)
title(main="Spring/Fall Day")


####### ELECTRICITY DEMAND
par(mar=col0margin)
plot.new()
title(main="Electricity Demand")#, line=-5)
par(mar=margin)

# elec_demand yearly
plot(data$time,data$hour,type='l', xlab="", ylab="kWh", axes=F)
title(main="Yearly")
axis(1, at=0:11*86400, labels=c("J","F","M","A","M","J","J","A","S","O","N","D"),tick=T, col=col_annot)
axis(2, col=col_annot)

# elec_demand summer
plot(data$time, data$house.v, type='l',  xlab="", ylab='kW', axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)
title(main="Summer Day")

# elec_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)
title(main="Winter Day")

# elec_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)
title(main="Spring/Fall Day")


####### NAT GAS DEMAND
par(mar=col0margin)
plot.new()
title(main="Natural Gas Demand")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1, col=col_annot)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)


####### ELECTRICITY COST
par(mar=col0margin)
plot.new()
title(main="Electricity Cost")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1, col=col_annot)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)


####### NAT GAS COST
par(mar=col0margin)
plot.new()
title(main="Natural Gas Cost")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1, col=col_annot)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)


####### TOTAL ENERGY COST
par(mar=col0margin)
plot.new()
title(main="Total Energy Cost")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1, col=col_annot)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)


####### ELECTRICITY USE
par(mar=col0margin)
plot.new()
title(main="Electricity Use ")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1, col=col_annot)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)


####### ELECTRICITY SOURCES
par(mar=col0margin)
plot.new()
title(main="Electricity Sources")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1, col=col_annot)
axis(2, col=col_annot)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1, col=col_annot)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1, col=col_annot)

quartz.save("report.pdf", type="pdf")
system("open report.pdf")
