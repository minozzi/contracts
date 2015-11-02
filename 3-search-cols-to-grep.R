## =============================================================================
## Title:  Identifying unique MDAP contracts
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 21 Oct. 2015
## Specs: Mac OS 10.11, RStudio v. 0.99.486
## =============================================================================

## Script Purpose: Grep through data table to find contract events related to
## a specific MDAP
## Packages Required: data.table

##--------------
# load libraries
library(data.table)

##-----------
# set options
options(stringsAsFactors = FALSE)

##-------------------------------------------------
# load a single time slice of the contracts dataset 
load("~/Data/MDAP/r-data/clean-cols-to-grep.RData") 
load("~/Data/MDAP/r-data/mdap-list.RData") 

setkey(dat)

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

##-----------------------------------------
# identify relevant columns to grep through
# NB - these remain the same for each MDAP search
y1 <- dat$sec # system or equipment code
y2 <- dat$sec_descrip # SEC description
y3 <- dat$contract_descrip # contract description
y4 <- dat$major_program # major program code

##----------------------------------------------------- 
# create a vector of searchable terms across covariates
# THIS SHOULD BE A FUNCTION "set_terms"
x1 <- c("220", "ACD") # mdap[[i], sec]
x2 <- c("C-130", "Hercules") # mdap[[i], grep_terms]

## ------------------------------------
# grep through system or equipment code
mdap_sec <- data.table(grep_for_x_in_y(x1, y1)) 
colnames(mdap_sec)[1] <- "rownumber" # rename col for ease of reference

## ---------------------------
# grep through SEC description
mdap_sec_descrip <- data.table(grep_for_x_in_y(x2, y2)) 
colnames(mdap_sec_descrip)[1] <- "rownumber" # rename col for ease of reference

## --------------------------------
# grep through contract description
mdap_contract_descrip <- data.table(grep_for_x_in_y(x2, y3)) 
colnames(mdap_contract_descrip)[1] <- "rownumber" # rename for ease of reference

##-----------------------------
# grep through majorprogramcode
mdap_program_code <- data.table(grep_for_x_in_y(x2, y4)) 
colnames(mdap_program_code)[1] <- "rownumber" 

##--------------------------------------------------
# Combine grepped data tables from the three columns
obs_rows <- unique(rbindlist(list(mdap_sec, mdap_sec_descrip, mdap_program_code,
                                  mdap_contract_descrip)))

rm(list = c("mdap_sec", "mdap_sec_descrip", "mdap_contract_descrip", 
            "mdap_program_code", "x1", "x2"))

##-------------------------------------------
# build a timeslice with only unique MDAP obs 
setkey(dat, rownumber)
mdap_obs <- dat[obs_rows]

##-------------------------------------------------------- 
# double check that I don't have duplicate contract events
length(unique(mdap_obs$unique_transaction_id)) == nrow(mdap_obs)
rm(obs_rows)

##------------------- 
# save new data table
save(mdap_obs, file = "~/Data/MDAP/r-data/mdap-c130.RData")

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
