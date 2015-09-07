## =============================================================================
## Title:  Identifying unique PMC contracts
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data 
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Subset and clean a single annual slice of the contracts data

##------
# set wd
# setwd("~/Data/contracts")

##----------------------------------------
# erase previous objects in system memory
rm(list=ls())  

#---------------
# load libraries
library(plyr)
library(tidyr)

##---------
# load data
load("~/Data/contracts/contracts-1999.rdata") # change for each yr

##--------------------- 
# add rownumbers to dat
dat$rownumber = 1:nrow(dat)

#---------------------------------------------------------
# split strings for variables with unique id : description

dat <- separate(dat, signeddate, 
                c("signed_year", "signed_month", "signed_day"), 
                "-", 
                extra = "merge")

dat <- separate(dat, maj_agency_cat, 
                     c("maj_agency_cat", "maj_agency"), 
                     ": ", 
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

dat <- separate(dat, informationtechnologycommercialitemcategory, 
                          c("tech_cat", "tech_descrip"),  
                          ": ",
                          extra = "merge")

## Make into R Date format
dat$effectivedate          <- as.Date(dat$effectivedate, "%m/%d/%Y")
dat$last_modified_date     <- as.Date(dat$last_modified_date, "%m/%d/%Y")
dat$signeddate             <- as.Date(dat$signeddate, "%m/%d/%Y")
dat$currentcompletiondate  <- as.Date(dat$currentcompletiondate, "%m/%d/%Y")
dat$ultimatecompletiondate <- as.Date(dat$ultimatecompletiondate, "%m/%d/%Y")
dat$lastdatetoorder        <- as.Date(dat$lastdatetoorder, "%m/%d/%Y")

##----------------------------------------------------------------------- 
# let's only save those contracts within State, DOD, or Homeland Security
dat <- dat[dat$maj_agency_cat == "9700" |
                   dat$maj_agency_cat == "7000" |
                   dat$maj_agency_cat == "1900", ]

##---------------------------------------------
# save the partially-cleaned and subsetted data
save(dat, file = "~/Data/contracts/clean-1999.rdata") # change for each year

###############################################################################
## EOF
###############################################################################
