# Growing-Degree-Days

## Description
This code calculates future Growing Degree Days using projected daily maximum and minimum temperatures from the MACA downscaled climate dataset (Abotzoglou & Brown, 2012; available at https://climate.northwestknowledge.net/MACA/data_csv.php). Data used are from 20 General Circulation Models which were downscaled using the RCP 8.5 emissions scenario for the time period 2016-2099. The Growing degree day formula used follows Method 2 as outlined by McMaster & Wilhelm (2007):



The thresholds used are those used for Corn: 
Upper Threshold = 30C
Lower Threshold = 10C
Base = 10C

Two options are given for when to start accumulating growing degree days -- the conventional way (beginning March 1st) and beginning on January 1st. 

## Methods
