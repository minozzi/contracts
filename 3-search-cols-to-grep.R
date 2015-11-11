## =============================================================================
## Title:  Identifying unique MDAP contracts
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Contracts Data
## Last Updated: 21 Oct. 2015
## Specs: Mac OS 10.11, RStudio v. 0.99.486
## =============================================================================

## Script Purpose: Grep through data table to find contract events related to
## a specific MDAP
## Packages Required: data.table, parallel

## N.B. for best performanc, run this script using a bash file in the Terminal
## e.g. cd ~/Data/MDAP/r-data, Rscript 3-search-cols-to-grep.R
## With parallel processing this may take upwards of 5 hrs

rm(list = ls())
options(stringsAsFactors = FALSE)

##--------------
# load libraries
library(parallel)
library(data.table)

##---------
# load data
load("~/Data/MDAP/r-data/clean-cols-to-grep.RData") # All contracts
load("~/Data/MDAP/r-data/mdap_grep.RData") # List of MDAPS by SEC and descrip

##---------------
# order mdap rows
mdap_grep<-mdap_grep[order(rownumber)]

##------------------------
# grep function
master_grep<-function (x){
        item<-mdap_grep[x] 
        
        sec_results<-lapply(3:6, function(s){ #exact match searching the 3 sec columns
                #Cleaning extra quotes from the contracts
                sec_code<-(item[[1, s]])
                if(is.na(sec_code) == FALSE)
                {
                        sec_match<-dat[, which(sec %in% sec_code)]
                        sec_match[]
                } else {}
        })
        sec_results<-(unlist(sec_results)) #so that we can put these together later
        
        grep_results<-lapply(7:14, function(q){ #exact match searching the sec_descriptions
                g<-(item[[1, q]])
                if(is.na(g) ==FALSE)
                {
                        grep_match<-dat[,  which(sec_descrip %in% g)]
                        grep_match[]
                } else {}
        })
        grep_results<-(unlist(grep_results))
        
        contract_results <- lapply(7:14, function(q){ #grepping 
                g <- (item[[1, q]])
                if(is.na(g) == FALSE)
                {
                        contract_match <- as.list(grep(g, dat$contract_descrip, ignore.case = TRUE))
                        contract_match[]
                } else {}
        })
        contract_results <- (unlist(contract_results))
        
        l <- c(sec_results, grep_results, contract_results) #putting all the row results together
        #l <- c(sec_results, grep_results) #putting all the row results together
        
        l <- list(unique(l)) #deleting duplicates
        
        cases <- lapply(l, function(p){ #getting the rows returned
                outcomes <- dat[p]})
        mdap <- rbindlist(cases) #our MDAP data file
        
        blocker <- lapply(15:23, function(b){ #blocking known terms which don't apply
                y <- (item[[1, b]])
                if(is.na(y) == FALSE)
                {
                        contract_match <- as.list(grep(y, mdap$contract_descrip, ignore.case = TRUE))
                        contract_match[]
                } else {}
        })
        
        blocker <- (unlist(blocker))
        
        mdap <- subset(mdap,!1:nrow(mdap) %in% blocker == TRUE) #removing the rows
        
        mdap_ids <- data.table(mdap[ , unique_transaction_id]) #only the IDs
        
        setnames(mdap_ids, c("unique_transaction_id"))
        
        mdap_ids[ , mdap := item[[1,2]]]
        
        out <- paste("~/Data/MDAP/r-data/MDAP_",item[[1,2]],"_blocked",".Rdata", 
                   sep = "")
        
        save(list = "mdap_ids", file = out) 
        
        invisible(NULL)
}

################################################################################
# strt <- Sys.time()
# test <- master_grep(1)
mclapply(1:161, master_grep, mc.cores = 4)
# print(Sys.time() - strt)
################################################################################

#---------------------------------------
# erase previous objects in system memory
rm(list=ls())  

##=============================================================================
## END OF FILE
##=============================================================================
