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

png("Plot1.png")
hist(as.numeric(df$Global_active_power), main="Global Active Power", ylim=c(0,1200), col="red", xlab="Global Active Power (kilowatts)")
dev.off()