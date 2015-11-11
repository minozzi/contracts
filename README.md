---
title: Read Me for JSF project
output: html_document
---

# Where's the data?
file path: "~/Box Sync/contracts-data/MDAP/r-data"

# 0-decompress-contracts-data.R

Input:
- 180 compressed time slices of the contract data

What the script does:
- unzips each of the 180 yearmo raw contracts files

Output:
- 180 uncompressed raw contract files by year and month (e.g. 200303, 200304, etc.)

# 1-build-cols-to-grep.R

Input:
- 180 year-month time slices of the contract data

What it does:
 - creates a function to load files from detailedcontracts
 - creates a function to load a time slice, and subset by five relevant variables
 - mclapply the function and a list of files to create a single 38 million x 5 data table
 - cleans out missing values across all five covariates (approx. 1.8 million contract events)

 
Output:
- clean-cols-to-grep.RData: a 36.2 million x 5 data table of unique contract events


# 2-create-mdap-list

Input:
- mdap-list.xlsx (an excel file of mdap program names, SEC codes, and search/ block terms)


What the script does:
- loads an excel file of grep terms into RStudio, saves it as an RData file
- cleans the MDAP-list RData file to get ride of extra spaces, etc.
- creates dedicated columns for each SEC code, grep term, and block terms (23 total)
- does addition cleaning of the MDAP-list so that a grep function can pull the correct values

Output:
- mdap-grep.RData (a data table containing a list of 161 unique MDAPS)

# 3-search-cols-to-grep

Input:
- mdap-grep.RData (a data table containing a list of 161 unique MDAPS)
- clean-cols-to-grep.RData: a 36.2 million x 5 data table of unique contract events to search through

What the script does
- creates a "master_grep" function which searches each column of "clean-cols-to-grep" using the row information from "mdap-grep"
- executing the script using a bash file in the terminal will apply the function to each MDAP in the list

Output:
- 161 RData files each dedicated to a separate MDAP (e.g. MDAP_A-10_Thunderbolt.RData)


# 4-create-mdap-cols

Input:
- 161 RData files each dedicated to a separate MDAP 

What the script does:
- creates a function to load each MDAP
- row binds each MDAP RData file into a single, 405k by two column data table (the complete list of MDAPs from our master dataset)

Output:
- mdapcols.RData: a single data table with approx. 405k rows by two columns (unique_trasactions_id, and mdap)

# 5-descriptive-analysis-of-mdap-cols

Input:
- mdapcols.RData: a single data table with approx. 405k rows by two columns (unique_trasactions_id, and mdap)

What the script does:
- uses basic data.table commands to identify the distrubtion and count of MDAPS
- identifies overlap in contract events and MDAPS (e.g. a single contract event relevant to both the F-15 and JDAM munition)

Output:
- data visualization of the mdap-cols data table (histograms, tables, etc.)
