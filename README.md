# Growing-Degree-Days

## Description
This code calculates future Growing Degree Days using projected daily maximum and minimum temperatures from the MACA downscaled climate dataset (Abotzoglou & Brown, 2012; available at https://climate.northwestknowledge.net/MACA/data_csv.php). Data used are from 20 General Circulation Models which were downscaled using the RCP 8.5 emissions scenario for the time period 2016-2099. The Growing degree day formula used follows Method 2 as outlined by McMaster & Wilhelm (2007):

![GDD Formula](https://github.com/ElsitaK/Test/GDD.Formula.png)

The thresholds used are those used for Corn: 
Upper Threshold = 30C, 
Lower Threshold = Base = 10C

Two options are given for when to start accumulating growing degree days -- the conventional way (beginning March 1st) and beginning on January 1st. 

## Methods
1. The file "Data-Clean-Up.R" imports all downloaded csv files, removes existing metadata, converts temperatures to Celsius and writes a series of new csv files (one for each GCM) incorporating the date, daily maximum and daily minimum temperatures. These are saved in a new folder "~/Modified-Tmax-Tmin". 
2. The file "GDD-Program.R" imports the modified csv files and calculates and records cumulative growing degree days. It creates a new file for each GCM which appends the daily GDD, cumulative GDD calculated from January 1st onwards, cumulative GDD calculated from March 1st onwards, and the ordinal date to the original dataset with date, maximum and minimum temperatures. These files are saved to a new folder "~/GDD-20-GCMs".

## Required R packages

- lubridate
- plyr
- dplyr

## Contact
Author: elsita.k@gmail.com
