###############################
# MDAP Grepper                #
# Adam Lauretig               #
# October 25, 2015            #
###############################
rm(list = ls())
options(stringsAsFactors = FALSE)

library(parallel)
library(data.table)

load("~/Data/MDAP/r-data/clean-cols-to-grep.RData") # All contracts
load("~/Data/MDAP/r-data/mdap_grep.RData") # List of MDAPS by SEC and descrip

## CREATE GREP FUNCTION
master_grep <- function (x){
        item <- mdap_grep[x] 
        cat(x, "\n")
        sec_results <- lapply(3:6, function(s){ 
                sec_code <- (item[[1, s]])
                if(is.na(sec_code) == FALSE)
                {
                        sec_match <- as.list(grep(sec_code, dat$sec, ignore.case = TRUE))
                        sec_match[]
                } else {}
        })
        sec_results <- (unlist(sec_results)) 
        grep_results <- lapply(7:13, function(q){
                g <- (item[[1, q]])
                if(is.na(g) == FALSE)
                {
                        grep_match <- as.list(grep(g, dat$sec_descrip, ignore.case = TRUE))
                        grep_match[]
                } else {}
        })
        grep_results <- (unlist(grep_results))
        
        contract_results <- lapply(7:13, function(q){
                g <- (item[[1, q]])
                if(is.na(g) == FALSE)
                {
                        contract_match <- as.list(grep(g, dat$contract_descrip, ignore.case = TRUE))
                        contract_match[]
                } else {}
        })
        contract_results <- (unlist(contract_results))
        
        l <- c(sec_results, grep_results, contract_results) #putting all the row results together
        l <- list(unique(l)) #deleting duplicates
        
        cases <- lapply(l, function(p){ #getting the rows returned
                outcomes <- dat[p]})
        
        mdap <- rbindlist(cases)
        out<-paste("~/data/contracts/MDAP/MDAP_",x,"_notblocked",".Rdata", sep = "")
        save(list = "mdap", file = out)
}

## 
strt <- Sys.time()
mdap_out <- mclapply(1:166, master_grep, mc.cores = 10)
print(Sys.time() - strt)
