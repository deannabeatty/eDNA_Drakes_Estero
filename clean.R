library(tidyverse)
library(dplyr)
library(readxl)

# clean seine data --------------------------------------------------------------

# Drake's Estero seine surveys 2021
DE_2021_seine <-  read_xlsx(path = "raw/2021 Fish Data.xlsx", sheet = "Drakes", trim_ws = TRUE)

# filter out extra rows with NA (from a sum function in 1 cell)
DE_2021_seine <- filter(DE_2021_seine, Bay != "NA")

# rename last column to notes
DE_2021_seine <- rename(DE_2021_seine, notes = ...11)

# write csv
write.csv(DE_2021_seine, file = "clean/DE_2021_seine.csv", row.names = FALSE)

# clean eDNA metadata -----------------------------------------------------

# Drake's Estero metadata eDNA samples
DE_2021_eDNA <-  read_xlsx(path = "raw/PRNS_Drakes_Estero.xlsx", sheet = "metadata", trim_ws = TRUE)

# remove unneccesary columns
DE_2021_eDNA <- subset(DE_2021_eDNA, select = -c(Site_number, Time_collected, Time_filtered, Interim_time, notes,
                                                 date_extracted, ng_uL_DNA_extracted, final_DNA_ng_uL))

write.table(DE_2021_eDNA, file = "clean/DE_2021_eDNA_metadata.txt", sep = "\t", row.names = FALSE, quote = FALSE)
