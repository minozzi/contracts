## =============================================================================
## Title:  Descriptive Analysis of JSF Data
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: Basic descriptive analysis of the JSF data

library(data.table)
library(ggplot2)

## load data
load("~/Data/MDAP/r-data/mdap-cols.RData")

setDT(mdap)

View(mdap)

table(is.na(mdap$unique_transaction_id))
mdap_no_obs <- mdap[is.na(unique_transaction_id), ]

## Four MDAPS have 0 obs in our dataset
# Amphibious Combat Vehicle (ACV)
# Mobile Landing Platform (MLP)
# VH-92A Presidential Helicopter
# Tactical Networking Radio Systems (TNRS) 

# Let's remove the empty MDAPs 
setkey(mdap, mdap)
mdap <- mdap[!"Amphibious Combat Vehicle (ACV)"]
mdap <- mdap[!"Mobile Landing Platform (MLP)"]
mdap <- mdap[!"VH-92A Presidential Helicopter"]
mdap <- mdap[!"Tactical Networking Radio Systems (TNRS)"]

mdap_freq <- mdap[, .N, by = mdap]
mdap_freq <- mdap_freq[ order(-rank(N))]
View(mdap_freq)

mean(mdap_freq$N) # 2520 obs
median(mdap_freq$N) # 856 obs

mode <- function(x) {
        ux <- unique(x)
        ux[which.max(tabulate(match(x, ux)))]
}

mode(mdap_freq$N) # 2 contract events (not the most informative, I suppose)
# maybe a modal range is more appropriate?

## Four MDAPS have 0 obs in our dataset
# Amphibious Combat Vehicle (ACV)
# Mobile Landing Platform (MLP)
# VH-92A Presidential Helicopter
# Tactical Networking Radio Systems (TNRS) 


## Distribution of MDAP counts
qplot(mdap_freq$N,
      geom = "histogram",
      binwidth = 1000,  
      main = "Histogram of MDAPs by number of contract events", 
      xlab = "MDAP contract events",  
      fill = I("blue"), 
      col = I("red"), 
      alpha = I(.2),
      ylim = c(0,100),
      xlim = c(0, 60000))


mdap <- mdap[order(mdap)]
qplot(mdap$mdap,
      geom = "histogram",
      binwidth = "1",
      main = "Histogram of MDAPs by number of contract events", 
      xlab = "MDAP",
      ylab = "Count of Contract Events")
      xlim = c(0,161),
      ylim = c(0, 60000))

      
setkey(mdap, unique_transaction_id)
mdap_unique <- mdap[unique(unique_transaction_id), ]

mdap_overlap <- mdap[duplicated(unique_transaction_id), ] # 14,588 contract events have duplicate SECs (3%)

save(list = c(mdap_freq, ) 
     file = "~/Data/MDAP/r-data/mdap-descriptive.RData")
     
##=============================================================================================================================
## END OF FILE
##=============================================================================================================================
