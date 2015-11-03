## =============================================================================
## Title:  Spot check and clean MDAP
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 23 Oct. 2015
## Specs: Mac OS 10.11, RStudio v. 0.99.486, R v. 3.2.2
## =============================================================================

## Script Purpose: remove false positives from each MDAP
## Packages Required: data.table

##--------------
# load libraries
library(data.table)

##-----------
# set options
options(stringsAsFactors = FALSE)

##-------------------------------------------------
# load a single time slice of the contracts dataset 
# Let's use the F-15 MDAP as an example
load("~/Desktop/r-data/mdap/Austin-MDAP/mdap-f15.RData")
setkey(mdap_obs)

##------------------
# let's look at SECs
table(mdap_obs$sec)
## 124 and AFF are correct, 2AFF and 3AFF aren't right!

##-------------------------------------------------
# remove contract events with SECs from other MDAPs
mdap_obs <- mdap_obs[sec %in% c("124", "AFF", "000")]

##-------------------------------------------------- 
# Subset out the obs which do not have a precise SEC
false_obs <- mdap_obs[sec == "000", .(rownumber, contract_descrip)]

table(false_obs$contract_descrip)

false_obs[1:10, contract_descrip] ## all these look correct

rm(false_obs)

#false_obs[1, contract_descrip] # correct contract event
#false_obs <- false_obs[-1]
#setkey(mdap_obs, rownumber)
#mdap_obs <- mdap_obs[!false_obs] 

##---------
# save data
save(mdap_obs, file = "~/Desktop/r-data/mdap/Austin-MDAP/mdap-f15-clean.RData")

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
