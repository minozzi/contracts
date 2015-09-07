## =============================================================================
## Title:  Build master dataset of JSF obs
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Build a master data set of all the clean, subsettted time slices 

##----------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##------------------------
# set working directory
# setwd("~/Data/PMC")

##--------------
# load libraries
library(data.table)
library(parallel)

##-----------
# set options
options(mc.cores = detectCores())

##----------------------------------------------
# List the files in the contracts data directory
filenames <- list.files(path = "~/Data/JSF/data/", 
                        pattern = "unique*",
                        full.names = TRUE)

##--------------------------------------
# Build a function to load time slices
load_slices <- function(i){
        load(filenames[i])
        setDT(pmc_obs)
        cat(i, "\n")
        pmc_obs[ , with = FALSE]
}

dt_list <- mclapply(X = 1:16, 
                    FUN = load_slices, 
                    mc.cores = 12)

dat <- rbindlist(dt_list)

rm(dt_list)

save(list = "dat", 
     file = "~/Data/JSF/data/JSF.RData")

##---------------
# in the terminal

# cd ~/Data/JSF/r-scripts
# Rscript 4-build-master-dataset.R

###############################################################################
## EOF
###############################################################################
