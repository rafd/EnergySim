data <- read.csv("~/Code/EnergySim/Scenarios/ModelTest/sim/EnergySimTest_res.csv", sep=",", head=TRUE)

col0margin <- c(0,0,1,0)
margin <- c(3,2,3,0)

row.names(data) <- data$time
#quartz (height=10,width=9)     
plot.new()                    
  #par(omi=c(0,0,0,0))                      #outer margins 
  par(mfrow=c(7,5))                        #number of rows and columns
  par(cex=0.5)            #label size
  par(bty="n")


####### ELECTRICITY DEMAND
par(mar=col0margin)
plot.new()
title(main="Electricity Demand")#, line=-5)
par(mar=margin)

# elec_demand yearly
plot(data$time,data$Hour,type='l', xlab="", ylab="kWh", axes=F)
title(main="Yearly")
axis(1, at=0:11*86400, labels=c("J","F","M","A","M","J","J","A","S","O","N","D"),tick=T)
axis(2)


# elec_demand summer
plot(data$time, data$house.v, type='l',  xlab="", ylab='kW', axes=F)
axis(1)
axis(2)
title(main="Summer Day")

# elec_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)
title(main="Winter Day")

# elec_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)
title(main="Spring/Fall Day")


####### NAT GAS DEMAND
par(mar=col0margin)
plot.new()
title(main="Natural Gas Demand")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1)
axis(2)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)


####### ELECTRICITY COST
par(mar=col0margin)
plot.new()
title(main="Electricity Cost")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1)
axis(2)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)


####### NAT GAS COST
par(mar=col0margin)
plot.new()
title(main="Natural Gas Cost")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1)
axis(2)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)


####### TOTAL ENERGY COST
par(mar=col0margin)
plot.new()
title(main="Total Energy Cost")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1)
axis(2)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)


####### ELECTRICITY USE
par(mar=col0margin)
plot.new()
title(main="Electricity Use ")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1)
axis(2)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)


####### ELECTRICITY SOURCES
par(mar=col0margin)
plot.new()
title(main="Electricity Sources")#, line=-5)
par(mar=margin)

# nat_gas_demand yearly
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3})), axes=F)
axis(1)
axis(2)

# nat_gas_demand summer
plot(data$time, data$house.v, type='l', xlab="", ylab=expression(paste("m"^{3}/"s")), axes=F)
axis(1)

# nat_gas_demand winter
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)

# nat_gas_demand fall/spring
plot(data$time, data$house.v, type='l', xlab="", ylab="", axes=F)
axis(1)