## =============================================================================
## Title:  Create a list of MDAPs
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 26 Oct. 2015
## Specs: Mac OS 10.11, RStudio v. 0.99.486
## =============================================================================

## Script Purpose: Create a list of unique MDAPs to identify
## Packages Required: data.table, xlsx

##------
# set wd
#setwd("~/Data/contracts")

##--------------
# load libraries
library(data.table)
library(xlsx)

##-------------------------------------------------
# load excel sheet of MDAPS from FY 1999 -- FY 2016
mdap_list  <- read.xlsx("~/Box Sync/contracts-data/MDAP/mdap_list.xlsx", 1)
mdap_list <- data.table(mdap_list)
setkey(mdap_list)
mdap_list <- mdap_list[, .N, by = .(mdap, sec, grep_terms, block_terms)]
mdap_list <- mdap_list[ order(-rank(N))]

##------------------- 
# save new data table
save(mdap_list, 
     file = "~/Box Sync/contracts-data/MDAP/mdap-list.RData")

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
