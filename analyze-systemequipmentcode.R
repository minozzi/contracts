library(data.table)

load("systemequipmentcode.rdata")

sec <- systemequipmentcode

rm(list = "systemequipmentcode")

setDT(sec)

sec <- sec[systemequipmentcode != "", ] # drop empty strings

freq <- sec[, .N, by = systemequipmentcode] # make frequency table

setkey(freq, systemequipmentcode) 

splits <- do.call(rbind, strsplit(freq$systemequipmentcode, ":")) 
# split systemequipmentode at :

freq$prefix <- splits[, 1]

freq$suffix <- splits[, 2]

freq <- freq[ order(-rank(N))]

View(freq)

freq <- freq[ order(-rank(systemequipmentcode))]

View(freq)

freq <- freq[ order(-rank(prefix))]

View(freq)

freq <- freq[ order(-rank(suffix))]

View(freq)
