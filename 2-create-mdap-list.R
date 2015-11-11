## =============================================================================
## Title:  Create a list of MDAPs
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 26 Oct. 2015
## Specs: Mac OS 10.11, RStudio v. 0.99.486
## =============================================================================

## Script Purpose: Create a list to identify the 161 unique MDAPs between FY 1999 -- FY 2016

rm(list = ls())
options(stringsAsFactors = FALSE)

##--------------
# load libraries
library(data.table)
library(foreign)
library(memisc)
library(xlsx)

##-------------------------------------------------
# load excel sheet of MDAPS from FY 1999 -- FY 2016
mdap_list  <- read.xlsx("~/Box Sync/contracts-data/MDAP/mdap_list.xlsx", 1)
mdap_list <- data.table(mdap_list)
setkey(mdap_list)
mdap_list <- mdap_list[, .N, by = .(mdap, sec, grep_terms, block_terms)]
mdap_list <- mdap_list[ order(-rank(N))]

##------------------- 
# save new data table
save(mdap_list, 
     file = "~/Box Sync/contracts-data/MDAP/mdap-list.RData")

mdapdat2 <- mdap_list
remove(mdap_list)

##---------
# SEC codes 
S1 <- mdapdat2[, list(SEC = unlist(strsplit(sec, ","))), by = seq_len(nrow(mdapdat2))]
S1[, Time := sequence(.N), by = seq_len]
d<-dcast.data.table(S1, seq_len ~ Time, value.var="SEC")
setnames(d, c("rownumber","sec1", "sec2", "sec3", "sec4"))
mdapdat2<-merge(mdapdat2, d, by = "rownumber")

##----------
# GREP Terms 
S2 <- mdapdat2[, list(GREP = unlist(strsplit(grep_terms, ","))), by = seq_len(nrow(mdapdat2))]
S2[, Time := sequence(.N), by = seq_len]
d2<-dcast.data.table(S2, seq_len ~ Time, value.var="GREP")
setnames(d2, c("rownumber","grep1", "grep2", "grep3", "grep4", "grep5", "grep6", "grep7", "grep8"))
mdapdat2<-merge(mdapdat2, d2, by = "rownumber")

##-----------
# Block Terms 
S3 <- mdapdat2[, list(BLOCK = unlist(strsplit(block_terms, ","))), by = seq_len(nrow(mdapdat2))]
S3[, Time := sequence(.N), by = seq_len]
d3<-dcast.data.table(S3, seq_len ~ Time, value.var="BLOCK")
setnames(d3, c("rownumber","block1", "block2", "block3", "block4", "block5", "block6", "block7", "block8", "block9"))
mdapdat2<-merge(mdapdat2, d3, by = "rownumber")

##-----------------------------
# Only the Columns we'll need 
mdap_grep<-subset(mdapdat2, select = c(1:2, 6:26)) #Subsetting MDAP names, and the 
# suite of Grep terms
mdap_grep<-data.table(mdap_grep)
setnames(mdap_grep, c("mdap"), c("MDAP_name"))

##--------------------
# Trimming White Space 
mdap_grep[, sec1 := trimws(sec1)]
mdap_grep[, sec2 := trimws(sec2)]
mdap_grep[, sec3 := trimws(sec3)]
mdap_grep[, sec4 := trimws(sec4)]
mdap_grep[, grep1 := trimws(grep1)]
mdap_grep[, grep2 := trimws(grep2)]
mdap_grep[, grep3 := trimws(grep3)]
mdap_grep[, grep4 := trimws(grep4)]
mdap_grep[, grep5 := trimws(grep5)]
mdap_grep[, grep6 := trimws(grep6)]
mdap_grep[, grep7 := trimws(grep7)]
mdap_grep[, grep8 := trimws(grep8)]
mdap_grep[, block1 := trimws(block1)]
mdap_grep[, block2 := trimws(block2)]
mdap_grep[, block3 := trimws(block3)]
mdap_grep[, block4 := trimws(block4)]
mdap_grep[, block5 := trimws(block5)]
mdap_grep[, block6 := trimws(block6)]
mdap_grep[, block7 := trimws(block7)]
mdap_grep[, block8 := trimws(block8)]

##---------------------------------------------------
# Replacing Spaces with underscores in the MDAP names 
# Gsubbing out spaces in MDAP names
mdap_grep$MDAP_name<-gsub(" ", "_", mdap_grep$MDAP_name)
#This is because Macs don't like slashed in filepaths
mdap_grep$MDAP_name<-gsub("/", "_", mdap_grep$MDAP_name)
remove(S1, S2, S3, d, d2, d3, mdapdat2)


##----------------------------------------------------------
# save new mdap list
save(mdap_grep, file = "~/Data/MDAP/r-data/mdap-grep.RData")
rm(mdap_grep)

##---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
