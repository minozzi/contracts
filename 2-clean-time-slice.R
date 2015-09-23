## =============================================================================
## Title:  Clean an annual time slice of the contracts data 
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data 
## Last Updated: 23 September 2015
## Data Source: USASpending.gov
## Operating System: Mac OS 10.10.5
## Statistical Software: RStudio Version 0.99.473
## =============================================================================

## Script Purpose: Subsect and clean a single annual slice of the contracts data

##------
# set wd
# setwd("~/Data/")

##----------------------------------------
# erase previous objects in system memory
rm(list=ls())  

#---------------
# load libraries
library(data.table)
library(tidyr)

##-----------
# set options
options(stringsAsFactors = FALSE)
# default.stringsAsFactors() # now FALSE

##---------
# load data
load("~/Data/contracts/annual-contracts/contracts-2014.RData")
dat <- as.data.table(dat)
setkey(dat)

##------------------------- 
# remove useless covariates
dat[ , majorprogramcode := NULL]
dat[ , isforeigngovernment := NULL]
dat[ , isforeignownedandlocated := NULL]
dat[ , informationtechnologycommercialitemcategory := NULL]
dat[ , fundedbyforeignentity := NULL]        
        
##--------------------------------------
# turn negative dollars obligated into 0
neg_dol <- dat[dat$dollarsobligated < 0, ]  

neg_dol$dollarsobligated <- 0

dat <- rbind(neg_dol, dat)

table(duplicated(dat$unique_transaction_id))

dat <- dat[!duplicated(unique_transaction_id)]

rm(neg_dol)

##---------------------- 
# subset by major agency
dat <- separate(dat, maj_agency_cat, 
                c("maj_agency_cat", "maj_agency"), 
                ": ", 
                extra = "merge")

# DOD, State, and DHS
dat <- dat[dat$maj_agency_cat == "9700" |
                   dat$maj_agency_cat == "7000" |
                   dat$maj_agency_cat == "1900", ]

#---------------------------------------------------------------
# split strings for other variables with unique id : description
dat <- separate(dat, signeddate, 
                c("signed_year", "signed_month", "signed_day"), 
                "-", 
                extra = "merge")

dat <- separate(dat, maj_fund_agency_cat, 
                c("maj_fund_agency_cat", 
                  "maj_fund_agency"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, agencyid, 
                c("agency_id", "agency"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, mod_agency, 
                c("mod_agency_id", "mod_agency"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, contractingofficeagencyid, 
                c("contracting_agency_id", "contracting_agency"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, fundingrequestingagencyid, 
                c("funding_request_agency_id", "funding_request_agency"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, contractingofficeid, 
                c("contracting_office_id", "contracting_office"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, fundingrequestingofficeid, 
                c("funding_request_office_id", "funding_request_office"), 
                ": ", 
                extra = "merge")

dat <- separate(dat, systemequipmentcode, 
                c("sec", "sec_descrip"),  
                ": ", 
                extra = "merge")

dat <- separate(dat, principalnaicscode, 
                c("naics", "naics_descrip"),  
                ": ",
                extra = "merge")

dat <- separate(dat, productorservicecode, 
                c("psc", "psc_descrip"),  
                ": ",
                extra = "merge")

dat <- separate(dat, claimantprogramcode, 
                c("cpc", "cpc_descrip"),  
                ": ",
                extra = "merge")

dat <- separate(dat, placeofperformancecountrycode, 
                c("pop_country_code", "pop_country"),  
                ": ",
                extra = "merge")

setnames(dat, "vendorcountrycode", "vendor_country")

##-----------------------------------
# save the time slice of cleaned data
# change for each annual time slice
save(dat, file = "~/Data/contracts/clean-contracts/clean-2014.rdata") 

rm(dat)

###############################################################################
## EOF
###############################################################################
