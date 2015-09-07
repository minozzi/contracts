## =============================================================================
## Title:  Build annual time slice of contracts data
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Take twelve monthly time slices of the contracts data and 
## build an annual time slice with the relevant columns

## N.B. Repeat this process for each annual time slice by changing input and
## saved file names where appropriate (filenames and save functions)

##----------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##------------------------
# set working directory
# setwd("~/Data/contracts")

##-----------
# set options
options(stringsAsFactors = FALSE)
default.stringsAsFactors() # now FALSE

##--------------
# load libraries
library(data.table)
library(parallel)

##------------------------------------
# detect number of cores on my machine
detectCores() # detects physical and virtual cores

##----------------------------------------------
# List the files in the contracts data directory
filenames <- list.files(path = "~/Data/contracts", 
                        pattern = "detailedcontracts1999*", # change for each yr
                        full.names = TRUE)

##---------------------------------------------------
# Build a vector of the columns from dat to subset by
vars <- c("unique_transaction_id",
                              "fiscal_year",
                              "signeddate",
                              "dollarsobligated",
                              "maj_agency_cat", 
                              "maj_fund_agency_cat", 
                              "agencyid",
                              "mod_agency", 
                              "contractingofficeagencyid", 
                              "fundingrequestingagencyid",
                              "contractingofficeid", 
                              "fundingrequestingofficeid",
                              "mod_parent",
                              "vendorname",
                              "vendoralternatename", 
                              "vendorlegalorganizationname", 
                              "vendordoingasbusinessname", 
                              "parentdunsnumber",
                              "dunsnumber", 
                              "streetaddress",
                              "streetaddress2",
                              "streetaddress3",
                              "city",
                              "state",
                              "zipcode",
                              "vendorcountrycode",
                              "contractactiontype",
                              "modnumber",
                              "descriptionofcontractrequirement",
                              "typeofcontractpricing",
                              "contractfinancing",
                              "multiyearcontract",
                              "contingencyhumanitarianpeacekeepingoperation",
                              "placeofperformancezipcode",
                              "placeofperformancecongressionaldistrict",
                              "majorprogramcode",
                              "claimantprogramcode",
                              "principalnaicscode",
                              "piid",
                              "psc_cat", 
                              "productorservicecode", 
                              "systemequipmentcode",
                              "informationtechnologycommercialitemcategory",
                              "isforeigngovernment",
                              "isforeignownedandlocated",
                              "fundedbyforeignentity")

##--------------------------------------
# Build a function to subset the columns
get_columns <- function(i){
        load(filenames[i])
        setDT(dat)
        cat(i, "\n")
        dat[ , vars, with = FALSE]
}

##---------------------------------------
# take twelves slices and build two lists
dt_list1 <- mclapply(X = 1:6, 
                     FUN = get_columns, 
                     mc.cores = 6)

dt_list2 <- mclapply(X = 7:9, 
                     FUN = get_columns, 
                     mc.cores = 6)

dat1 <- rbindlist(dt_list1)

dat2 <- rbindlist(dt_list2)

rm(list = c("dt_list1", "dt_list2"))

##------------------------------------------------------------
# Build a new data frame with all twelve slices, call it "dat"
dat <- rbind(dat1, dat2)

##--------------------------------------------
# Save new annual time slice by contracts-year
save(list = "dat", 
     file = "~/Data/contracts/contracts-1999.RData") # change for each yr

##-----------------------------
# Commands to input in Terminal
# cd ~/Data/contracts
# Rscript 1-build-PMC-data-set.R

###############################################################################
## EOF
###############################################################################
