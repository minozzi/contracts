###############################
# MDAP Grepper                #
# Adam Lauretig               #
# October 25, 2015            #
###############################
rm(list = ls())
options(stringsAsFactors = FALSE)

library(data.table)
library(foreign)
library(memisc)

###############################
load("~/Data/MDAP/r-data/mdap_list.RData") # Austin's list of MDAPs
cat("MDAPs loaded \n")
mdapdat2 <- mdap_list
rm(mdap_list)

#S1, S2, and S3 are creating discrete cells for each group of grep terms, for
#each MDAP
S1 <- mdapdat2[, list(SEC = unlist(strsplit(sec, ","))), 
               by = seq_len(nrow(mdapdat2))]

S1[, Time := sequence(.N), by = seq_len]

d <- dcast.data.table(S1, seq_len ~ Time, value.var = "SEC")

setnames(d, c("rownumber","sec1", "sec2", "sec3", "sec4"))

rm(S1)

mdapdat2 <- merge(mdapdat2, d, by = "rownumber")

rm(d)

S2 <- mdapdat2[, list(GREP = unlist(strsplit(grep_terms, ","))), 
               by = seq_len(nrow(mdapdat2))]

S2[, Time := sequence(.N), by = seq_len]

d2 <- dcast.data.table(S2, seq_len ~ Time, value.var="GREP")

setnames(d2, c("rownumber","grep1", "grep2", "grep3", "grep4", "grep5", "grep6", 
               "grep7"))

rm(S2)

mdapdat2 <- merge(mdapdat2, d2, by = "rownumber")

rm(d2)

mdap_grep <- subset(mdapdat2, select = c(1:2, 5:15)) 
# Subsetting MDAP names, and the suite of Grep terms

rm(mdapdat2)

mdap_grep <- data.table(mdap_grep)

setnames(mdap_grep, c("mdap"), c("MDAP_name"))

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

cat("data cleaned \n")

save(mdap_grep, file = "~/Data/MDAP/r-data/mdap_grep.RData")
rm(mdap_grep)
