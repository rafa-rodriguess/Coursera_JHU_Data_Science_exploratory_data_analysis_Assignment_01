library(zip)
library(sqldf)
options(warn=-1)

Sys.setlocale("LC_TIME","English_United States.1252")

downloadZipFile <- function(url, zipdest){
        #Download Zip File
        if (!file.exists(zipdest)){
                download.file(url,zipdest)
                unzip(zipdest)
        }
}

loadFile <- function(myfile, myfile_sql_filter){
        #household_power_consumption
        household_power_consumption <- read.csv.sql(myfile, myfile_sql_filter, header = TRUE, sep = ";")
        household_power_consumption
}

#download and unzip file
downloadZipFile("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "exdata_data_household_power_consumption.zip")

#load filtering all the used rows
household_power_consumption <- loadFile("household_power_consumption.txt", "select * from file where Date in ('1/2/2007','2/2/2007')")

#create Date
household_power_consumption$Date <- strptime(paste(household_power_consumption$Date, household_power_consumption$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 

png("plot3.png")
par(cex=1)
with(household_power_consumption, plot(Date, Sub_metering_1, col="black", type="l", xlab="", ylab="Global Active Power (kilowatts)"))
with(household_power_consumption, lines(Date,Sub_metering_2, col="red"))
with(household_power_consumption, lines(Date,Sub_metering_3, col="blue"))     
legend("topright",
       legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red","blue"),
       lty=1, cex=0.8,y.intersp=0.9
)
dev.off()

