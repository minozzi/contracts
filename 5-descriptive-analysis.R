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
library(reshape2)

## load data
load("~/Data/JSF/data/JSF.RData")

setDT(JSF)

## Total Dollars Spent on F-35
JSF$dollarsobligated[is.na(JSF$dollarsobligated)] <- 0

sum(JSF$dollarsobligated) # $ 23,822,644,394

## Spending over time
fy_spending <- JSF[ , .(dollarsobligated = sum(dollarsobligated)), 
                    by = fiscal_year]

fy_spending <- fy_spending[ order(rank(dollarsobligated))]

fy_spending$lndollarsobligated <- log(fy_spending$dollarsobligated)

ggplot(data = fy_spending, 
       aes(x = fiscal_year, y = dollarsobligated)) + 
        scale_x_continuous(breaks = c(2003, 2004, 2005, 2006, 2007, 2008, 
                                      2009, 2010, 2011, 2012, 2013, 2014)) + 
        scale_y_continuous(limits=c(0, 4000000000)) +
        labs(title = "Spending on the F-35 Program by Fiscal Year") + 
        labs(x = "Fiscal Year") +
        labs(y = "Contract Value (USD)") +
        geom_line() +
        theme_bw()

pdf("~/Data/JSF/viz/fy_spending.pdf")
ggplot(data = fy_spending, 
       aes(x = fiscal_year, y = lndollarsobligated)) + 
        scale_x_continuous(breaks = c(2003, 2004, 2005, 2006, 2007, 2008, 
                                      2009, 2010, 2011, 2012, 2013, 2014)) + 
        scale_y_continuous(limits=c(0, 23)) +
        labs(title = "Spending on the F-35 Program by Fiscal Year") + 
        labs(x = "Fiscal Year") +
        labs(y = "Ln Contract Value (USD)") +
        geom_line() +
        theme_bw()
dev.off()



## Contract dollars by firm
firm_dollars <- JSF[ , .(dollarsobligated.Sum = sum(dollarsobligated)), 
                     by = mod_parent]

firm_dollars <- firm_dollars[ order(-rank(dollarsobligated.Sum))]

firm_dollars <- firm_dollars[1:25, ]

## Contract dollars by DOD agency
agency_dollars <- JSF[ , .(dollarsobligated.Sum = sum(dollarsobligated)), 
                       by = mod_agency]

agency_dollars <- agency_dollars[ order(-rank(dollarsobligated.Sum))]

## Why does the Army distribute more JSF contract $$ than the Air Force?

## Contract dollars by DOD office
office_dollars <- JSF[ , .(dollarsobligated.Sum = sum(dollarsobligated)), 
                       by = contracting_office]

office_dollars <- office_dollars[ order(-rank(dollarsobligated.Sum))]

office_dollars <- office_dollars[1:50, ]

## Contract dollars by PSC code
psc_dollars <- JSF[ , .(dollarsobligated.Sum = sum(dollarsobligated)), 
                    by = psc_descrip]

psc_dollars <- psc_dollars[ order(-rank(dollarsobligated.Sum))]

psc_dollars <- psc_dollars[1:50, ]

## Contract dollars by CD
state_dollars <- JSF[ , .(dollarsobligated.Sum = sum(dollarsobligated)), 
                      by = state]

state_dollars <- state_dollars[ order(-rank(dollarsobligated.Sum))]

state_dollars <- state_dollars[1:41, ]

###############################################################################
## EOF
###############################################################################
