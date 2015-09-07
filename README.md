---
title: Read Me for JSF project
output: html_document
---

# 1-build-time-slice.R

What it does:
 - creates a function to load files from detailedcontracts
 - builds a list of 12 monthly time slices
 - subsets the data by approx. 60 covariates of interest
 - builds a data table of the 12 time slices
 - saves the dt as an annual "slice" (e.g. contracts-1999.Rdata)
 
Output:
- a time slice of the contracts data for a given fiscal year across 62 covariates 
 
# 2-clean-time-slice.R

What it does:
- loads an annual contracts data file
- subsets it by maj_agency_cat (DOD, State, and Homeland Security)
- separates strings of codes and desriptions into separate columns
- saves the annual time slice as an r data file (e.g. "clean-1999.Rdata")

Output:
- a "clean" time slice of the contracts data for a given fiscal year

# 3-find-unique-observations.R

What it does:
- loads a time annual time slice of the contracts data
- loads two nx3 dfs of PMC firms and PMC psc codes
- creates a grep function which uses a vector of search terms through a column of the clean contracts data
- creates a vector, x, with the appropriate search terms to isolate PMC obs
- merges dfs from PMC duns and PMC obs into a single df
- takes the merged d.f. and combines it with the clean time slice to retrieve all unique observations

Output:
- an annual time slice of the contracts data containing only observations relevant to private military companies hired by the DOD, State, and Homeland Security

# 4-build-master-dataset.R

What it does:
- uses a function to load each clean, unique annual time slice of the data
- creates a list of the  time slices
- creates a master datatable from the rbindlist

Output:
- a "master" datatable with all PMC obs across 14 fiscal years

# 5-descriptive-analysis.R

# 6-data-visualization.R


