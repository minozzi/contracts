---
title: Read Me for JSF project
output: html_document
---

# 0-decompress-contracts-data.R

What it does:
- unzips each of the 180 yearmo raw contracts files

Output:
- 180 uncompressed raw contract files by year and month (e.g. 200003)

# 1-build-cols-to-grep.R

What it does:
 - creates a function to load files from detailedcontracts
 - builds a list of 12 monthly time slices
 - subsets the data by approx. 60 covariates of interest
 - builds a data table of the 12 time slices
 - saves the dt as an annual "slice" (e.g. contracts-1999.Rdata)
 
Output:
- a 38 million x 5 data table
 

