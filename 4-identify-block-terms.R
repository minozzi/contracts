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
load("~/Data/MDAP/r-data/mdap-jassm.RData")

setkey(dat)

##------------------
# let's look at SECs
table(mdap_obs$sec)

##-------------------------------------------------- 
# Subset out the obs which do not have a precise SEC
false_obs <- mdap_obs[sec != "555"]

false_obs <- false_obs[ order(-rank(sec))]

View(false_obs)

## remove true positives so that only the false contracts are left in d.t.
## spot check to ID false contracts for this MDAP

false_obs[24, contract_descrip] # looks okay

false_obs <- false_obs[4:6] ## let's remove these ones from mdap_obs

setkey(mdap_obs, unique_transaction_id)

mdap_obs <- mdap_obs[!false_obs] 

##---------
# save data
save(mdap_obs, file = "~/Data/MDAP/r-data/mdap-jassm.RData")

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
