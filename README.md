---
title: Read Me for JSF project
output: html_document
---

# 0-decompress-contracts-data.R

What it does:

Output:

# 1-build-cols-to-grep.R

What it does:
 - creates a function to load files from detailedcontracts
 - builds a list of 12 monthly time slices
 - subsets the data by approx. 60 covariates of interest
 - builds a data table of the 12 time slices
 - saves the dt as an annual "slice" (e.g. contracts-1999.Rdata)
 
Output:
- a 38 million x 5 column data table
 

