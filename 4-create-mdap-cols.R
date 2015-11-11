## =============================================================================
## Title:  Create MDAP cols to merge into master dataset
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 21 Nov. 2015
## Specs: Mac OS 10.11, RStudio v. 0.99.486, R v. 3.2
## =============================================================================

## Script Purpose: rbindlist 161 separate mdap data tables into a single data table 
## for descriptive analysis

## Packages Required: data.table, parallel

##-----------
# set options
options(stringsAsFactors = FALSE)
#options(mc.cores = detectCores())

##--------------
# load libraries
library(data.table)
library(parallel)

##----------------------------------------------
# List the files in the contracts data directory
filenames <- list.files(path = "~/Data/MDAP/r-data", 
                        pattern = "MDAP_*", 
                        full.names = TRUE)

##--------------------------------------
# Build a function to subset the columns
get_columns <- function(i){
        load(filenames[i])
        setDT(mdap_ids)
        cat(i, "\n")
        mdap_ids[, .(unique_transaction_id, mdap)]
}

##-------------------------------------------
# take 161 mdap files and build four lists
dt_list1 <- mclapply(X = 1:40, 
                     FUN = get_columns, 
                     mc.cores = 2)

dt_list2 <- mclapply(X = 41:81, 
                     FUN = get_columns, 
                     mc.cores = 2)

dt_list3 <- mclapply(X = 82:132, 
                     FUN = get_columns, 
                     mc.cores = 2)

dt_list4 <- mclapply(X = 133:161, 
                     FUN = get_columns, 
                     mc.cores = 2)

## create four lists
dat1 <- rbindlist(dt_list1)
dat2 <- rbindlist(dt_list2)
dat3 <- rbindlist(dt_list3)
dat4 <- rbindlist(dt_list4)

## remove lists from working memory
rm(list = c("dt_list1", "dt_list2", "dt_list3", "dt_list4"))

##------------------------------------------------------------
# Build a new data table, call it "dat"
mdap <- rbind(dat1, dat2, dat3, dat4)
rm(list = c("dat1", "dat2", "dat3", "dat4"))

##-------------------------
# clean up MDAP description
mdap$mdap <- gsub("_", " ", mdap$mdap)

##--------------------
# Save new data table
save(list = "mdap", 
     file = "~/Data/MDAP/r-data/mdap-cols.RData") 
