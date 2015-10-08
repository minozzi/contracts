
## GOAL: Identify contract events unique to 17 private military companies from GWOT contracts

## Set up
options(stringsAsFactors = FALSE)
library(data.table)

## Load data
load("~/Box Sync/contracts-data/gwot-obs.RData")
setkey(dat) 

## Write a function to grep a column of data
grep_for_x_in_y <- function(x, y)
        # grep for each element in x within y, then format results
        # Arguments:
        #   x: vector of character strings to search for
        #   y: vector of character strings in which to search
        # Returns:
        #   integer vector of positions in y with something in x
{
        position_list <- lapply(x, function(x_element)
                grep(x_element, y, ignore.case = TRUE)) # WM: maybe need fixed = TRUE?
        position_vector <- do.call(c, position_list)
        sort(unique(position_vector))
}

## provide a vector of search terms (specific firms)
x <- c("BLACKWATER LODGE AND TRAINING",
       "ACADEMI",
       "XE SERVICES",
       "U.S. TRAINING CENTER",
       "TRIPLE CANOPY INC.",
       "ARMORGROUP INTERNATIONAL PLC",
       "AEGIS DEFENCE SERVICES LTD",
       "ERINYS",
       "OLIVE GROUP",
       "BLUE HACKLE LLC",
       "SALLYPORT GLOBAL HOLDINGS",
       "TRANS ATLANTIC GENERAL TRADING",
       "TITAN CORPORATION",
       "CUSTER BATTLES",
       "SOC LLC",
       "G4S SECURE SOLUTIONS",
       "AIRSCAN")

## provide column(s) to grep through
y1 <- dat$mod_parent # parent firm
y2 <- dat$vendorname # contract vendor

## grep through mod_parent
dat1 <- as.data.frame(grep_for_x_in_y(x, y1))
colnames(dat1)[1] <- "rownumber" # WM: or dat1?

## grep through vendorname
dat2 <- as.data.frame(grep_for_x_in_y(x, y2))
colnames(dat2)[1] <- "rownumber"

## bind both together in a list
obs_rows <- sort(unique(c(dat1$rownumber, dat2$rownumber)))

## remove dat1 and dat2
rm(list = c("dat1", "dat2"))

## merge original df with row numbers to retrieve the full covariate profile of each contract event
military_provider_firm <- dat[obs_rows] # because of data.table, no need for ","

## double check that I don't have duplicate contract events
length(unique(military_provider_firm$unique_transaction_id)) ==
  nrow(military_provider_firm)

## remove row number list
rm(obs_rows)

## save new data frame
save(list = "military_provider_firm",
     file = "~/Box Sync/contracts-data/military-provider-firm.RData")
