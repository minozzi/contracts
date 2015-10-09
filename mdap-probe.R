## =============================================================================
## Title:  Identifying unique MDAP contracts
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 9 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Plausibility probe for identifying specific MDAP contracts 
## Let's see if we can ID all DOD contracts related to the V-22 Osprey aircraft

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##------
# set wd
# setwd("~/Data/contracts")

##--------------
# load libraries
library(data.table)
library(parallel)

##-----------
# set options
options(mc.cores = detectCores())
options(stringsAsFactors = FALSE)

##-------------------------------------------------
# load a single time slice of the contracts dataset 
load("~/Data/contracts/clean-contracts/clean-2002.rdata") # change for each yr

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

##----------------------------------------------------- 
# create a vector of searchable terms across covariates
x1 <- c("212", "AVQ")
x2 <- c("V-22", "Osprey", "V22", "V22 VERTICAL LIFT AIRCRAFT")

##-----------------------------------------
# identify relevant columns to grep through
y1 <- dat$sec
y2 <- dat$descriptionofcontractrequirement

## ---------------
# grep through SEC
mdap_sec <- as.data.table(grep_for_x_in_y(x1, y1)) 
colnames(mdap_sec)[1] <- "rownumber" # rename for ease of reference

## --------------------------------
# grep through contract description
mdap_descrip <- as.data.table(grep_for_x_in_y(x2, y2)) 
colnames(mdap_descrip)[1] <- "rownumber" # rename for ease of reference

##--------------------------------------------
# combine MDAP datasets into single data table 
mdap_obs_rows <- unique(rbindlist(list(mdap_sec, mdap_descrip)))
rm(list = c("mdap_descrip", "mdap_sec", "x1", "x2", "y1", "y2"))

##------------------------------------------
# build a timeslice with only unique JSF obs 
mdap_obs <- merge(mdap_obs_rows, dat, by = "rownumber", all.x = TRUE)
rm(list = c("mdap_obs_rows", "dat"))

##------------------------
# save MDAP obs time slice
save(list = "mdap_obs", 
     file = "~/Data/contracts/clean-contracts/MDAP-2002.RData") # change for each year

rm("mdap_obs")  

##----------------------------------- 
# Create a master dataset of MDAP obs

rm(list = c("x", "grep_for_x_in_y"))

load("~/Data/contracts/clean-contracts/MDAP-1999.RData")
dat_1999 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2000.RData")
dat_2000 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2001.RData")
dat_2001 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2002.RData")
dat_2002 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2003.RData")
dat_2003 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2004.RData")
dat_2004 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2005.RData")
dat_2005 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2006.RData")
dat_2006 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2007.RData")
dat_2007 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2008.RData")
dat_2008 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2009.RData")
dat_2009 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2010.RData")
dat_2010 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2011.RData")
dat_2011 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2012.RData")
dat_2012 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2013.RData")
dat_2013 <- mdap_obs
rm(mdap_obs)

load("~/Data/contracts/clean-contracts/MDAP-2014.RData")
dat_2014 <- mdap_obs
rm(mdap_obs)

dat <- unique(rbindlist(list(dat_1999, dat_2000, dat_2001, dat_2002,
                             dat_2003, dat_2004, dat_2005, dat_2006,
                             dat_2007, dat_2008, dat_2009, dat_2010,
                             dat_2011, dat_2012, dat_2013, dat_2014)))

rm(list = c("dat_1999", "dat_2000", "dat_2001", "dat_2002",
             "dat_2003", "dat_2004", "dat_2005", "dat_2006",
             "dat_2007", "dat_2008", "dat_2009", "dat_2010",
             "dat_2011", "dat_2012", "dat_2013", "dat_2014"))

unique(dat$unique_transaction_id) # all obs appear to be unique!

## DANGER: HOW CAN WE SYSTEMATICALLY ELIMINATE FALSE POSITIVES? ##

## EG: SBIRS and H-3 are MDAPs, but not the V-22 Osprey!
## And I doubt "Polynesians Adventure Tours" is a relevant mod_parent!

## Solution: Another of grepping/ cleaning through the relevant vars? 
## Not sure how else to do this other than personally spot checking obs 

save(list = "dat", 
     file = "~/Data/contracts/clean-contracts/MDAP-V22Osprey.RData") # change for each year

rm("dat")  

###############################################################################
## EOF
###############################################################################
