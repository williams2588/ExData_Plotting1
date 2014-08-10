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

x <- df$dateTime
y <- df$Global_active_power

daterange=c(as.POSIXct(min(x)),as.POSIXct(max(x)))
png("Plot2.png")
plot.new()
plot(x, y, type = "n", xaxt="n", xlab = "", ylab="Global Active Power (kilowatts)")
lines(x, y)
axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="day"), format="%a")
dev.off()
