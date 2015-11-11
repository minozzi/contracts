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

