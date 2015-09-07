## =============================================================================
## Title:  Build master dataset of JSF obs
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Build a master dataset with all unique JSF obs

##----------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##------------------------
# set working directory
# setwd("~/Data/JSF")

##--------------
# load libraries
library(data.table)
library(parallel)

##-----------
# set options
options(mc.cores = detectCores())
options(stringsAsFactors = FALSE)


##----------------------------------------------------------
# load three data frames of grepped values unique to the JSF


load("~/Data/JSF/data/JSF-descript.RData")
dat1 <- dat
dat1 <- as.data.table(dat1)
rm(dat)

load("~/Data/JSF/data/JSF-fund.RData")
dat2 <- dat
dat2 <- as.data.table(dat2)
rm(dat)

load("~/Data/JSF/data/JSF-sec.RData")
dat3 <- dat
dat3 <- as.data.table(dat3)
rm(dat)

list <- list(dat1, dat2, dat3)

JSF <- rbindlist(list)

rm(list, dat1, dat2, dat3)

##--------------------------------
# detect and remove duplicate rows

summary(duplicated(JSF$unique_transaction_id)) # 2859 unique obs or 646 repeats

JSF <- JSF[!duplicated(JSF), ] # unique contract ID now match rows

##------------
# save JSF obs
save(JSF, "~/Data/JSF/data/JSF.RData")

##---------------
# in the terminal
# cd ~/Data/JSF/r-scripts
# Rscript 4-build-master-dataset.R

###############################################################################
## EOF
###############################################################################
