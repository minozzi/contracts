## =============================================================================
## Title:  Build data table of columns to grep
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 21 October 2015
## System Requirements: Mac OS 10.11 (El Capitan); RStudio Desktop 0.99.486
## =============================================================================

## Script Purpose: build an 38 million x 4 data table of columns to grep through
## Packages Required: data.table, parallel, tidyr

##--------------
# load libraries
library(data.table)
library(parallel)
library(tidyr)

##-----------
# set options
options(stringsAsFactors = FALSE)
#options(mc.cores = detectCores())

##----------------------------------------------
# List the files in the contracts data directory
filenames <- list.files(path = "~/Data/contracts/raw-contracts", 
                        pattern = "detailedcontracts*", 
                        full.names = TRUE)

##---------------------------------------------------
# Build a vector of the columns from dat to subset by
vars <- c("unique_transaction_id", "systemequipmentcode", "majorprogramcode",
          "descriptionofcontractrequirement")

##--------------------------------------
# Build a function to subset the columns
get_columns <- function(i){
        load(filenames[i])
        setDT(dat)
        cat(i, "\n")
        dat[ , vars, with = FALSE]
}

##-------------------------------------------
# take 181 yearmo files and build four lists
dt_list1 <- mclapply(X = 1:45, 
                     FUN = get_columns, 
                     mc.cores = 3)

dt_list2 <- mclapply(X = 46:91, 
                     FUN = get_columns, 
                     mc.cores = 3)

dt_list3 <- mclapply(X = 92:137, 
                     FUN = get_columns, 
                     mc.cores = 3)

dt_list4 <- mclapply(X = 138:180, 
                     FUN = get_columns, 
                     mc.cores = 3)

## create four lists
dat1 <- rbindlist(dt_list1)
dat2 <- rbindlist(dt_list2)
dat3 <- rbindlist(dt_list3)
dat4 <- rbindlist(dt_list4)

## remove lists from working memory
rm(list = c("dt_list1", "dt_list2", "dt_list3", "dt_list4"))

##------------------------------------------------------------
# Build a new data table, call it "dat"
dat <- rbind(dat1, dat2, dat3, dat4)
rm(list = c("dat1", "dat2", "dat3", "dat4"))

##------------------------------
# Split SEC from SEC description
require(tidyr)
dat <- separate(dat, systemequipmentcode, c("sec", "sec_descrip"), ": ", 
                extra = "merge")

##--------------
# rename columns
setnames(dat, "majorprogramcode", "major_program")
setnames(dat, "descriptionofcontractrequirement", "contract_descrip")

##--------------------------------------------
# Save new data table
save(list = "dat", 
     file = "~/Data/MDAP/r-data/cols_to_grep.RData") 

##----------------------------------------
# erase previous objects in system memory
rm(list=ls()) 

##-------------------------------
# Commands to execute in Terminal
# cd ~/Data/MDAP/r-scripts
# Rscript 1-build-cols-to-grep.R
        
## =============================================================================        
## END OF FILE
## =============================================================================        
