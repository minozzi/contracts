## =============================================================================
## Title:  Decompress raw contracts data
## Author: Austin Knuppe (knuppe.2@osu.edu)
## Project: Government Contracts Data
## Last Updated: 7 Sept 2015
## Data Source: USASpending.gov
## =============================================================================

## Script Purpose: decompress each monthly time slice of the contracts data and 
## save it

# Set working directory
setwd("~/Data/contracts")

# Read through all files, load each one, then save 
files <- list.files()

for(fn in files){
        load(fn)
        save(List = "dat",  file = fn)}

## =============================================================================        
## END OF FILE
## =============================================================================    
