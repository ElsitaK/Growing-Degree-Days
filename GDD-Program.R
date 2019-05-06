#calculate daily and cumulative Growing Degree Days based on daily maximum and minimum temperatures
#thresholds for use can be specified
#2 options provided: starting to accumulate GDD on January 1st and on March 1st
#Formula follows "Method 2" in:
#McMaster, Gregory S., and W. W. Wilhelm. “Growing Degree-Days: One Equation, Two Interpretations.” Agricultural and Forest Meteorology 87, no. 4 (1997): 291–300.

library(lubridate)
library(plyr)
library(dplyr)

setwd('~/Growing-Degree-Days/Modified-Tmax-Tmin')

#set thresholds
#BASED ON CORN, can be modified for any crop
upper.Threshold <- 30
lower.Threshold <- 10
base <- 10

#if you want to look at one csv data:
#temperatures <- read.csv('tasmin_tasmax_GFDL.ESM2M_rcp85.K.csv',stringsAsFactors=FALSE)

#get the data
#append csv files together
files = list.files(pattern="*.csv")

for (i in files){
  temperatures <- read.csv(i)
  #str(temperatures) #look
  
  #get filename before changing the column names
  filename <- file.path('~/Growing-Degree-Days/GDD-20-GCMs', paste0("tasmin", "_", names(temperatures)[3], "csv"))
  
  #rename columns
  colnames(temperatures)[3] <- "MaxTempC"
  colnames(temperatures)[4] <- "MinTempC"
  #str(temperatures)
  
  #creating a new column each for max and minimum temperatures, applying the thresholds to each value
  ###set upper theshold
  for (i in 1:30681) {
    if (temperatures$MaxTempC[i] > upper.Threshold) {
      temperatures$newMaxTempC[i] <- upper.Threshold
    } else {
      temperatures$newMaxTempC[i] <- temperatures$MaxTempC[i]
    }
  }
  
  ###set lower threshold
  for (i in 1:30681) {
    if (temperatures$MaxTempC[i] < lower.Threshold) {
      temperatures$newMaxTempC[i] <- lower.Threshold
    }
  }
  
  for (i in 1:30681) {
    if (temperatures$MinTempC[i] < lower.Threshold) {
      temperatures$newMinTempC[i] <- lower.Threshold
    }  else {
      temperatures$newMinTempC[i] <- temperatures$MinTempC[i]
    }
  }
  
  #the actual formula to calculate GDD each day
  temperatures$dailyGDD <- with(temperatures,(((newMaxTempC + newMinTempC)/2) - base))
  
  #get year in column
  temperatures$Date2 <- as.Date(temperatures$Date) #make it in date format
  temperatures$Year <- year(as.Date(temperatures$Date2,"%Y/%m/%d"))
  
  #get the number of days for each year
  #takes leap years into account
  #critical for designating when to start counting on March 1st each year (day 60 or 61) 
  DaysPerYear <- temperatures %>% count(Year)
  #add one more row (year 2100 with 366 days, necessary for future calculations)
  DaysPerYear[85,1] <- 2100
  DaysPerYear[85,2] <- 366
  DaysPerYear$cumDPY <- NA
  #get cumulative number of days
  DaysPerYear$cumDPY[1] <- DaysPerYear$n[1]
  for (i in 2:84){
    DaysPerYear$cumDPY[i] = DaysPerYear$cumDPY[i-1]+DaysPerYear$n[i]
  }
  
  #####################calculate daily GDD starting Jan 1
  temperatures$cumGDD <- NA
  
  a=1
  for (i in 1:84){
    b=DaysPerYear$cumDPY[i]
    temperatures$cumGDD[a] <- temperatures$dailyGDD[a]
    for (j in (a+1):b){
      temperatures$cumGDD[j] <- temperatures$dailyGDD[j]+temperatures$cumGDD[j-1]
    }
    a=a+DaysPerYear$n[i]
  }  
  
  #change column name to Jan 1
  names(temperatures)[10]<-paste("cumGDDJan1")
  
  
  ################calculate daily GDD starting March 1
  temperatures$cumGDD <- NA
  
  #March 1 is 60 or 61 ordinal day in a leap year
  
  a=61 #first day leap-year (2016)
  for (i in 1:84){
    print(a)
    b=DaysPerYear$cumDPY[i]
    print(b)
    temperatures$cumGDD[a] <- temperatures$dailyGDD[a]
    for (j in (a+1):b){
      temperatures$cumGDD[j] <- temperatures$dailyGDD[j]+temperatures$cumGDD[j-1]
    }
    p=DaysPerYear$n[i+1]
    q=DaysPerYear$n[i]
    if (p > 365) {
      a=a+DaysPerYear$n[i]+1
    } else if (q > 365){
      a=a+DaysPerYear$n[i]-1
    } else {
      a=a+DaysPerYear$n[i]
    }
  }
  
  #change column name to March 1
  names(temperatures)[11]<-paste("cumGDDMar1")
  
  #include a column for ordinal date
  temperatures$Ordinal <- yday(temperatures$Date)
  
  #write it 
  write.csv(temperatures,file=filename) 
}
