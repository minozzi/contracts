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

###############
# The Grepper #
###############
mdap_grep<-mdap_grep[order(rownumber)]

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
  
  l<-list(unique(l)) #deleting duplicates
  
  cases<-lapply(l, function(p){ #getting the rows returned
    outcomes<-dat[p]})
  mdap<-rbindlist(cases) #our MDAP data file
  
  blocker <- lapply(15:23, function(b){ #blocking known terms which don't apply
    y <- (item[[1, b]])
    if(is.na(y) == FALSE)
    {
      contract_match <- as.list(grep(y, mdap$contract_descrip, ignore.case = TRUE))
      contract_match[]
    } else {}
  })
  blocker <- (unlist(blocker))
  mdap<-subset(mdap,!1:nrow(mdap) %in% blocker==TRUE) #removing the rows
  
  mdap_ids<-data.table(mdap[,unique_transaction_id]) #only the IDs
  setnames(mdap_ids, c("unique_transaction_id"))
  
  out<-paste("~/data/contracts/MDAP/MDAP_",item[[1,2]],"_blocked",".Rdata", sep = "")
  save(list = "mdap_ids", file = out)
  invisible(NULL)
}

##### 
strt <- Sys.time()
mdap_out <- mclapply(1:166, master_grep, mc.cores = 10)
print(Sys.time() - strt)
