## =============================================================================
## Title:  Create a list of MDAPs
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 21 Oct. 2015
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
dat <- read.xlsx("~/Data/MDAP/r-data/mdap_list.xlsx", 1)

dat <- data.table(dat)
setkey(dat)

dat <- dat[, .N, by = .(mdap, sec, grep_terms, block_terms)]
dat <- dat[ order(-rank(N))]

# 96 MDAPs lasted longer than 5 years, good cut point instead of all 214?
# 86/96 have unique system equipment codes which is a great thing!

dat2 <- dat[1:96, ]

##----------------------------------------------
# create a slimmed down version of the MDAP list
mdap_list <- dat2[, .(sec, grep_terms, block_terms)]

##------------------- 
# save new data table
save(list = c("dat", "mdap_list"), 
     file = "~/Data/MDAP/r-data/mdap-list.RData")

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
