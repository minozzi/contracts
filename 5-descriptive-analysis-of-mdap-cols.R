## =============================================================================
## Title:  Descriptive Analysis of JSF Data
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Basic descriptive analysis of the JSF data

library(data.table)

load("~/Data/MDAP/r-data/mdap-cols.RData")

setDT(mdap)

View(mdap)

table(is.na(mdap$unique_transaction_id))
mdap_no_obs <- mdap[is.na(unique_transaction_id), ]

## Five MDAPS have 0 obs in our dataset
# Amphibious Combat Vehicle (ACV)
# Mobile Landing Platform (MLP)
# VH-92A Presidential Helicopter
# Tactical Networking Radio Systems (TNRS) 

# FGM-172 Predator Short Range Assault Weapon (SRAW)

# Let's remove the empty MDAPs 
setkey(mdap, mdap)
mdap <- mdap[!"Amphibious Combat Vehicle (ACV)"]
mdap <- mdap[!"FGM-172 Predator Short Range Assault Weapon (SRAW)"]
mdap <- mdap[!"Mobile Landing Platform (MLP)"]
mdap <- mdap[!"VH-92A Presidential Helicopter"]
mdap <- mdap[!"Tactical Networking Radio Systems (TNRS) (formerly Joint Tactical Radio System (JTRS))"]

## Save the new file
save(mdap, file = "~/Data/MDAP/r-data/mdap-cols.RData")

rm(list=ls()) 

################################################################################
################################################################################

library(data.table)
library(ggplot2)

load("~/Data/MDAP/r-data/mdap-cols.RData")

setDT(mdap)

mdap_freq <- mdap[, .N, by = mdap] # 156 out of 161 MDAPs represented

mdap_freq <- mdap_freq[ order(-rank(N))] # rank by number of contract events
View(mdap_freq)

mean(mdap_freq$N) # 2600 contract events per MDAP on average
sd(mdap_freq$N) # 6,137 standard deviation
median(mdap_freq$N) # 942 contract events, a strong right skew to the dist.

mode <- function(x) {
        ux <- unique(x)
        ux[which.max(tabulate(match(x, ux)))]
}

mode(mdap_freq$N) # 5668 contract events (not the most informative, I suppose)
# maybe a modal range is more appropriate?

## Bar plot of contract events per MDAP
qplot(factor(mdap), 
      data = mdap, 
      geom = "bar",
      main = "Distribution of MDAPs by contract event count", 
      xlab = "MDAP",
      ylab = "Count of Contract Events")
      xlim = c(0,161),
      ylim = c(0, 60000))

## Distribution of MDAP counts
qplot(mdap_freq$N,
      geom = "histogram",
      binwidth = 1000,  
      main = "Histogram of MDAPs by number of contract events", 
      xlab = "MDAP contract events", 
      ylab = "MDAP count",
      ylim = c(0,100),
      xlim = c(0, 60000))

## Let's look at contract event overlap
setkey(mdap, unique_transaction_id)

mdap_overlap <- mdap[duplicated(unique_transaction_id), ] # 14,581 contract events have duplicate SECs (3%)

mdap_overlap_freq <- mdap_overlap[, .N, by = mdap] # 106 MDAPs have some overlap

mdap_overlap_freq <- mdap_overlap_freq[ order(-rank(N))] # rank by number of contract events

View(mdap_overlap_freq)      

mean(mdap_overlap_freq$N) #  138contract events per MDAP on average
sd(mdap_overlap_freq$N) # 481 standard deviation
median(mdap_overlap_freq$N) # 14.5

save(list = c(mdap, mdap_freq, mdap_overlap, mdap_overlap_freq) 
     file = "~/Data/MDAP/r-data/mdap-descriptive.RData")
     
##=============================================================================================================================
## END OF FILE
##=============================================================================================================================

###############################
# MDAP Descriptive Stats      #
# Adam Lauretig               #
# November 11, 2015           #
###############################
rm(list = ls())
options(stringsAsFactors = FALSE)

library(parallel)
library(data.table)
load("~/Dropbox/Data/MDAP/r-data/mdap-cols.RData")

setkey(mdap, unique_transaction_id)

########
# Looking at those contracts which are listed to multiple MDAPS #
########

transact_count<-mdap[,.N,by=unique_transaction_id]

transact_count_mult<-transact_count[, subset(transact_count, N>1)]

sum(transact_count_mult$N) #28,813 contract events that overlap

mult<-merge(transact_count_mult, mdap, by= "unique_transaction_id")

mdap_multi<-mult[,.N,by=mdap]
#Quick notes: Aegis BMD is multi-listed the most, followed by EA-6 Prowler, and 
#the SBIRS, F-22, and MLV.


########
# Looking at those contracts which are listed to single MDAPS #
########

transact_count_single<-transact_count[, subset(transact_count, N==1)]

sing<-merge(transact_count_single, mdap, by = "unique_transaction_id")

mdap_single<-sing[,.N,by=mdap]


########
# Comparing single and multiple contracts recipients #
########

compare<-merge(mdap_single, mdap_multi, by = "mdap")
setnames(compare, c("mdap", "single_contracts", "multiple_contracts"))

hist(compare$single_contracts)
hist(compare$multiple_contracts)

hist(log1p(compare$single_contracts))
hist(log1p(compare$multiple_contracts))

plot(compare$single_contracts, compare$multiple_contracts, pch=20)
plot(log1p(compare$single_contracts), log1p(compare$multiple_contracts), pch=20)


########
# standardizing and plotting to see what the trends look like #
########
plot(compare$single_contracts, compare$multiple_contracts, pch=20)

plot(log1p(compare$single_contracts), log1p(compare$multiple_contracts), pch=20)
##looks like a fairly linear relationship between the two

single_stan<-(log1p(compare$single_contracts)-mean(log1p(compare$single_contracts))/
                sd(log1p(compare$single_contracts)))

multi_stan<-(log1p(compare$multiple_contracts)-mean(log1p(compare$multiple_contracts))/
               sd(log1p(compare$multiple_contracts)))

plot(single_stan, multi_stan, pch=20)
abline(h=0, v=0)
