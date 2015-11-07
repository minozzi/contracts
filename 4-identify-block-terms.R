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

load("~/Data/MDAP/r-data/mdap_list.RData")
View(mdap_list)

load("")

setkey(mdap)
table(mdap$sec)
mdap <- mdap[order(-rank(sec))]
View(mdap)

block <- data.table(mdap[sec == "000" | is.na(sec), contract_descrip])
View(block)
test <- data.table(grep('(^|\\s)($|\\s)', block$V1))

#(^|\\s)Austin Knuppe($|\\s)

mdap_list[] <- NA

rm(mdap, block)

## to fix row names when removing duplicate MDAPs
row.names(mdap_list) <- 1:nrow(mdap_list)
mdap_list$rownumber <- row.names(mdap_list)

save(mdap_list, file = "~/Dropbox/Data/MDAP/r-data/mdap_list.RData")

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
