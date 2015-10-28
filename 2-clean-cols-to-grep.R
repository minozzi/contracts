## =============================================================================
## Title:  Clean the cols-to-grep data table
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 21 October 2015
## System Requirements: Mac OS 10.11 (El Capitan); RStudio Desktop 0.99.486
## =============================================================================

## Script Purpose: clean cols-to-grep.RData
## Packages Required: data.table

##--------------
# load libraries
library(data.table)

##-----------
# set options
options(stringsAsFactors = FALSE)

##---------
# load data
load("~/Data/MDAP/r-data/cols_to_grep.RData")
setkey(dat)

##------------------------------------
# add NAs to empty cells in data table

dat$sec[which(dat$sec == "")] <- NA
dat$sec_descrip[which(dat$sec_descrip == "")] <- NA
dat$contract_descrip[which(dat$contract_descrip == "")] <- NA
dat$major_program[which(dat$major_program == "")] <- NA

dat$sec[which(dat$sec == " ")] <- NA
dat$sec_descrip[which(dat$sec_descrip == " ")] <- NA
dat$contract_descrip[which(dat$contract_descrip == " ")] <- NA
dat$major_program[which(dat$major_program == " ")] <- NA

table(is.na(dat$sec)) # 22,082,728 missing
table(is.na(dat$sec_descrip)) # 23,760,752 missing
table(is.na(dat$contract_descrip)) # 3,487,617 missing
table(is.na(dat$major_program)) # 37,147,595

##-------------------------------------------------------
# remove rows which contain no useful information to grep

dat2 <- data.table(dat[is.na(sec) & is.na(sec_descrip) & is.na(major_program) & 
                    is.na(contract_descrip), ])
# 1,857,731 have no useful information for identifying MDAPS

## let's remove them
dat2 <- data.table(dat2[, unique_transaction_id])
setnames(dat2, "V1", "unique_transaction_id")
setkey(dat, unique_transaction_id)
dat <- dat[!dat2, ] 
rm(dat2)

dat2 <- dat[sec == "000" & sec_descrip == "NONE" & is.na(major_program) &
                    is.na(contract_descrip), ]
dat2 <- data.table(dat2[, unique_transaction_id])
setnames(dat2, "V1", "unique_transaction_id")
setkey(dat, unique_transaction_id)
dat <- dat[!dat2, ] 
rm(dat2)

## Looks like we're left with 36,281,606 left to grep through

##---------------------------
# add rownumber column to dat
dat$rownumber <- row.names(dat)
View(dat)

##---------
# save data
save(dat, file = "~/Data/MDAP/r-data/clean-cols-to-grep.RData")

##=============================================================================
## END OF FILE
##=============================================================================
