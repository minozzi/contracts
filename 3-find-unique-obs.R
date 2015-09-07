## =============================================================================
## Title:  Identifying unique JSF contracts
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Identify unique contracts related to the JSF program

## N.B. This script must be applied to each annual time slice of the data

##---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##------
# set wd
#setwd("~/Data/contracts")

##--------------
# load libraries
library(reshape) # another Hadley Wickham creation!

##--------------------------------------------------------------------------
# load a single time slice from the clean, subsetted contracts dataset 
load("~/Data/contracts/clean-2014.rdata") # change filename for each yr

##-----------------------------------------------------------
# Identify unique JSF obs by their system equipment code, 198

# drop empty strings  
jsf_sec <- dat[dat$sec != "", c("rownumber", "sec")]

jsf_sec <- jsf_sec[jsf_sec$sec != "000", ] 

# subset time slice by unique JSF SEC
jsf_sec <- subset(jsf_sec, sec == "198")

jsf_sec <- jsf_sec[, "rownumber"]

jsf_sec <- as.data.frame(jsf_sec)

colnames(jsf_sec)[1] <- "rownumber" # we'll use this df to merge with dat

##-------------------------------------------------------------------
# create a function to grep column y for a vector of search terms, x
grep_for_x_in_y <- function(x, y)
        # grep for each element in x within y, then format results
        # Arguments:
        #   x: vector of character strings to search for
        #   y: vector of character strings in which to search
        # Returns:
        #   integer vector of positions in y with something in x
{
        position_list <- lapply(x, function(x_element)
                grep(x_element, y, ignore.case = TRUE))
        position_vector <- do.call(c, position_list)
        sort(unique(position_vector))
}

## create a vector of searchable terms across five covariates
x <- c("JSF", 
       "F-35",  
       "JOINT STRIKE FIGHTER", 
       "Joint Strike Fighter Program",
       "STOVL")

## -----------------
# funding_request_office

y <- dat$funding_request_office

jsf_funding_request_office <- as.data.frame(grep_for_x_in_y(x, y)) 

colnames(jsf_funding_request_office)[1] <- "rownumber" # rename for ease of reference

## -------------------------------
# descriptionofcontractrequirement

y <- dat$descriptionofcontractrequirement

jsf_descriptionofcontractrequirement<- as.data.frame(grep_for_x_in_y(x, y)) 

colnames(jsf_descriptionofcontractrequirement)[1] <- "rownumber" # rename for ease of reference

##-------------------------------------------------------------
# combine JSF datasets into single data frame to merge with dat

require(reshape) 

JSF_obs_rows <- merge_all(jsf_sec,
                          jsf_funding_request_office,
                          jsf_descriptionofcontractrequirement,
                          by = "rownumber",
                          all = TRUE)

JSF_obs_rows <- as.data.frame(JSF_obs_rows)

colnames(JSF_obs_rows)[1] <- "rownumber"

##------------------------------------------
# build a timeslice with only unique JSF obs 

JSF_obs <- merge(JSF_obs_rows,
                 dat,
                 by = "rownumber")

JSF_obs <- merge(jsf_sec,
                 dat,
                 by = "rownumber")

##-----------------------
# save JSF obs time slice
save(list = "JSF_obs", 
     file = "~/Data/JSF/data/JSF-2014.RData") # change filename for each year

###############################################################################
## EOF
###############################################################################
