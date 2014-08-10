#===================
# load data
#===================

library("data.table")

#read data from current working directory
srcfile <- "household_power_consumption.txt"
colClass <- rep("character", 9) 
df <- fread(srcfile, sep = ";", header = TRUE, colClasses = colClass)

#do initial fast filter to reduce data frame size
df <- df[ which(df$Date=='1/2/2007' | df$Date =='2/2/2007' | df$Date =='3/2/2007'),]

#construct POSIX date/time field to be used for plotting time series
dateTime <- paste(df$Date, df$Time)
dateTime <- as.POSIXct(strptime(as.character(dateTime), "%d/%m/%Y %H:%M:%S"))

#add POSIX date/time to data frame
df <- data.frame(dateTime, df)

#apply final date/time filter
df <- df[ which(df$dateTime >= as.POSIXct('2007-02-01 00:00:00 EST') & df$dateTime <= as.POSIXct('2007-02-03 00:00:00 EST')),]


#===================
# make plot
#===================

png("Plot4.png")
par(mfrow=c(2,2))

# prepare plot 1
x <- df$dateTime
y <- df$Global_active_power
daterange=c(as.POSIXct(min(x)),as.POSIXct(max(x)))
plot(x, y, type = "n", xaxt="n", xlab = "", ylab="Global Active Power")
lines(x, y)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")

#prepare plot 2
x <- df$dateTime
y <- df$Voltage
daterange=c(as.POSIXct(min(x)),as.POSIXct(max(x)))
plot(x, y, type = "n", xaxt="n", xlab = "datetime", ylab="Voltage")
lines(x, y)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")


#prepare plot 3
x <- df$dateTime
y1 <- as.numeric(df$Sub_metering_1)
y2 <- as.numeric(df$Sub_metering_2)
y3 <- as.numeric(df$Sub_metering_3)
daterange=c(as.POSIXct(min(x)),as.POSIXct(max(x)))
plot(x, y1, type = "n", xaxt="n", xlab = "", ylab="Energy sub metering")
lines(x, y1)
par(col="red")
lines(x, y2)
par(col="blue")
lines(x, y3)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")
par(col="black")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1,1), lwd=c(2.5,2.5), col=c("black","red","blue"), bty="n")

#prepare plot 4
x <- df$dateTime
y <- df$Global_reactive_power
daterange=c(as.POSIXct(min(x)),as.POSIXct(max(x)))
plot(x, y, type = "n", xaxt="n", xlab = "datetime", ylab="Global_reactive_power")
lines(x, y)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")
dev.off()