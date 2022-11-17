library(tidyverse)
library(dplyr)

# import clean seine data
DE_2021_seine <- read_csv(file = "clean/DE_2021_seine.csv")

# convert factor seine to character
DE_2021_seine$Seine <- as.character(DE_2021_seine$Seine)

# create summaries of seine data for inverts & fish ------------------------------------------

# inclusive of all inverts & verts (fish)

# calculate relative abundances of each Species per seine
# loop through list of unique seine names to subset the df; 
# group_by Species and sum abundances of each Species, calculate sum of counts for each seine (N), 
# calculate relative abundances of each Species, check that sum of relative abundances per seine equal 100% 

# subset by columns of interest
DE_2021_seine_subset <- subset(DE_2021_seine, select = c(Seine, Species, Count))

# obtain unique list of seine names
seine_unique <- unique(DE_2021_seine_subset$Seine)

# create list
seine_table <- list()

for(i in seq_along(seine_unique)) {
  X=subset(DE_2021_seine_subset, Seine == seine_unique[i])
  temp = X %>% group_by(Species) %>% summarise_each(funs(sum (Count)))
  temp$Seine = seine_unique[i]
  temp$N =  sum(temp$Count) 
  temp$RelAbund <- ( (temp$Count / temp$N) * 100 )
  temp$SumRelAbund <- sum(temp$RelAbund) 
  seine_table[[i]] <- temp
  
  print(temp)
}

# bind items in seine_table list with rbind/bind_rows
seine_table <- bind_rows(seine_table)

write.csv(seine_table, file = "summary/DE_2021_seine_summary.csv", 
           row.names = FALSE, quote = FALSE)

# create summaries of seine data for fish only -------------------------------

# filter out inverts & create new summary
# creating a vector of inverts
invert = c("Crangon", "Green crab", "Yellow shore crab",
"Grass shrimp")
# creating a vector of fish species
fish = c("Pipefish","Stickleback","Staghorn sculpin","Arrow goby","Midshipman")

# filter dataframe by vector of fish species
DE_2021_seine_fish <- filter(DE_2021_seine, Species %in% fish) 
                                        
# calculate relative abundances of each Species per seine
# loop through list of unique seine names to subset the df; 
# group_by Species and sum abundances of each Species, calculate sum of counts for each seine (N), 
# calculate relative abundances of each Species, check that sum of relative abundances per seine equal 100% 

# subset by columns of interest
DE_2021_seine_fish_subset <- subset(DE_2021_seine_fish, select = c(Seine, Species, Count))

# obtain unique list of seine names
seine_unique <- unique(DE_2021_seine_fish_subset$Seine)

# create list
seine_fish_table <- list()

for(i in seq_along(seine_unique)) {
  X=subset(DE_2021_seine_fish_subset, Seine == seine_unique[i])
  temp = X %>% group_by(Species) %>% summarise_each(funs(sum (Count)))
  temp$Seine = seine_unique[i]
  temp$N =  sum(temp$Count) 
  temp$RelAbund <- ( (temp$Count / temp$N) * 100 )
  temp$SumRelAbund <- sum(temp$RelAbund) 
  seine_fish_table[[i]] <- temp
  
  print(temp)
}

# bind items in seine_fish_table list with rbind/bind_rows
seine_fish_table <- bind_rows(seine_fish_table)

write.csv(seine_fish_table, file = "summary/DE_2021_seine_fish_summary.csv", 
           row.names = FALSE, quote = FALSE)
