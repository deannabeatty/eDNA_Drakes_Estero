library(tidyverse)
library(dplyr)
library(readxl)

# import and bind all estuaries genus species lists from WOS (includes Suisun which was subsequently removed) --------

# import metadata sheets
ES_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Elkhorn_Slough")
SF_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "San_Francisco")
SP_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "San_Pablo")
S_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Suisun")
TB_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Tomales")
B_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Bodega")
DE_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Drakes_Estero")
RR_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Russian_River")
ER_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Eel_River")
H_species_list_WOS_full <- read_xlsx("mitohelper_reference/WOS_search_spp_lists/Fish_species_list.xlsx", trim_ws = TRUE, sheet = "Humboldt")

# row bind all dataframes
WOS_species_all_estuaries <- bind_rows(ES_species_list_WOS_full, SF_species_list_WOS_full, 
                                       SP_species_list_WOS_full, S_species_list_WOS_full,
                                       TB_species_list_WOS_full, B_species_list_WOS_full,
                                       DE_species_list_WOS_full, RR_species_list_WOS_full,
                                       H_species_list_WOS_full
)

# unique genus species for all estuaries (129 unique species; contains duplicates, updated taxonomic labels, higher level taxonomy)
WOS_species_all_estuaries_unique <- as.data.frame(unique(WOS_species_all_estuaries$`Genus species`))
# change column name
colnames(WOS_species_all_estuaries_unique) <- c("genus_species")

# write csv
write_csv(WOS_species_all_estuaries_unique, file = "mitohelper_reference/WOS_search_spp_lists/all_estuaries_spp_list.csv", col_names = FALSE)

# import alignment and taxonomic labels of mitofish ref seqs & filter by Mifish 12S region --------

# import alignment of mitofish ref seqs from get record for all estuaries WOS search spp list to D. rerio
all_get_record_alignment <- read_tsv(file = "mitohelper_reference/get_alignment/12S_tax_seq_derep_uniq_Mar2022/all_estuaries_genus_species_12S_tax_seq_derep_uniq_Mar2022_L7_alignment.alnpositions.tsv")

# remove D. rerio
all_get_record_alignment <- all_get_record_alignment %>% filter(Accession != "NC_002333.2:1020-1971")

#import alignment of our 12S mitogene sequences to D. rerio
our_seqs <- read_tsv(file = "mitohelper_reference/get_alignment/rep_seqs_fish_2021_dada2_alignment.alnpositions.tsv")
our_seqs <- our_seqs %>% filter(Accession != "NC_002333.2:1020-1971")
# min, max, mean of start 
min(our_seqs$Start) #221
max(our_seqs$Start) #403 outside of the range the MiFish primers target

#import alignment to D. rerio of our 12S mitogene sequences after clustering to 97% and removal of seqs with less than 80% similarity to reference database
our_seqs_removal_80 <- read_tsv(file = "mitohelper_reference/get_alignment/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_alignment.alnpositions.tsv")
# remove D. rerio
our_seqs_removal_80 <- our_seqs_removal_80 %>% filter(Accession != "NC_002333.2:1020-1971")
# min, max, mean of start 
min(our_seqs_removal_80$Start) #221
max(our_seqs_removal_80$Start) #230 
mean(our_seqs_removal_80$Start) #229
sd(our_seqs_removal_80$Start) #1.8
min(our_seqs_removal_80$End) #447
max(our_seqs_removal_80$End) #452
mean(our_seqs_removal_80$End) #447
sd(our_seqs_removal_80$End) #0.9

# remove sequences (10) that fall outside of the MiFish target (not present in our seqs after clustering and removal of seqs with <80% similarity to MiFish ref database)
# keep seqs with start position of < 300
our_seqs <- our_seqs %>% filter(Start < 300)
min(our_seqs$Start) #221
max(our_seqs$Start) #230
sd(our_seqs$Start)
min(our_seqs$End) #434
max(our_seqs$End) #452
sd(our_seqs$End)

# get length of reference sequences 
all_get_record_alignment$length <- all_get_record_alignment$End - all_get_record_alignment$Start

# filter reference sequences by 12S mitogene region of interest for MiFish primers
all_get_record_12S_MiFish <- all_get_record_alignment %>% filter(Start < 300, End > 330, length > 100) 

# create column of approx. length in region of interest
all_get_record_12S_MiFish$length_roi <- all_get_record_12S_MiFish$End - 230 # 230 is max of our seqs "start"

# obtain filtered accession numbers for reference records that match MiFish region of mitogene 
all_estuaries_filtered_accessions <- all_get_record_12S_MiFish$Accession

# import get record accession numbers plus taxonomy (385 records, includes Suisun and Eel River which were subsequently removed)
all_get_record_taxonomy <- read_tsv(file = "mitohelper_reference/get_record/12S_tax_seq_derep_uniq_Mar2022/all_estuaries_genus_species_12S_tax_seq_derep_uniq_Mar2022_L7.taxonomy.tsv")

# filter table to keep only those that match MiFish region of mitogene using accession numbers 
all_get_record_taxonomy_filtered <- all_get_record_taxonomy %>% 
  filter(`Feature ID` %in% all_estuaries_filtered_accessions) # 207 records remain

# split the id string to obtain unique taxonomy, creates a list
s_all <- strsplit(all_get_record_taxonomy_filtered$Taxon, ";")
# view transposed string split taxonomy
#view(t(data.frame(s_all)))

# transpose the taxonomy with labels
all_get_record_taxonomy_filtered_t <- data.frame(Accession = all_get_record_taxonomy_filtered$`Feature ID`, Domain = t(data.frame(s_all))[,1], Phylum = t(data.frame(s_all))[,2], Class = t(data.frame(s_all))[,3], Order = t(data.frame(s_all))[,4], Family = t(data.frame(s_all))[,5], `Genus species` = t(data.frame(s_all))[,7] )                                                

dim(all_get_record_taxonomy_filtered_t) # 207 rows x 7 taxomony columns

# clean the taxonomy names 
all_get_record_taxonomy_filtered_t$Domain <- gsub(all_get_record_taxonomy_filtered_t$Domain, pattern = "d__", replacement = "")
all_get_record_taxonomy_filtered_t$Phylum <- gsub(all_get_record_taxonomy_filtered_t$Phylum, pattern = "p__", replacement = "")
all_get_record_taxonomy_filtered_t$Class <- gsub(all_get_record_taxonomy_filtered_t$Class, pattern = "c__", replacement = "")
all_get_record_taxonomy_filtered_t$Order <- gsub(all_get_record_taxonomy_filtered_t$Order, pattern = "o__", replacement = "")
all_get_record_taxonomy_filtered_t$Family <- gsub(all_get_record_taxonomy_filtered_t$Family, pattern = "f__", replacement = "")
all_get_record_taxonomy_filtered_t$Genus.species <- gsub(all_get_record_taxonomy_filtered_t$Genus.species, pattern = "s__", replacement = "")

# write csv of Accession and taxonomy from get record
write_csv(all_get_record_taxonomy_filtered_t, file = "mitohelper_reference/comparing_records/all_estuaries_genus_species_12S_tax_seq_derep_uniq_Mar2022_L7_clean_filtered_taxonomy.csv")

# unique Genus species
species_list_record <- unique(all_get_record_taxonomy_filtered_t$Genus.species) 
# remove leading white space
species_list_record <- trimws(species_list_record, "l")

# some of these genus species names may not be in our WOS list of species and show up due to hit in gene description rather than species label
# vector of wos species list to filter hits with
wos_species_vector <- WOS_species_all_estuaries_unique$genus_species

# remove leading whitespace
all_get_record_taxonomy_filtered_t$Genus.species <- trimws(all_get_record_taxonomy_filtered_t$Genus.species, "l")

# filter by vector of wos species list (reduced to 196 records from 207)
all_get_record_taxonomy_filtered_remove_spurious_hit <- all_get_record_taxonomy_filtered_t %>% filter(Genus.species %in% wos_species_vector)

# unique records for Genus species names; list of hits to genus species found in WOS search including Suisun
species_list_record <- unique(all_get_record_taxonomy_filtered_remove_spurious_hit$Genus.species)

# add column mitofish record for each estuary -----------------------------

# add column MitoFish record & populate with ifelse statement for Drakes Estero
DE_species_list_WOS_full <- DE_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(DE_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
DE_species_list_WOS_full <- DE_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]
# distinct genus species and common names
DE_species_list_WOS_unique <- DE_species_list_WOS_full %>% distinct(`Genus species`, `common name`)
# unique genus species (32, 1 'Sebastes sp.' and 1 updated taxonomy; 30)
DE_species_list_WOS_genus_sp_unique <- unique(DE_species_list_WOS_full$`Genus species`)

write_csv(DE_species_list_WOS_full, file = "mitohelper_reference/comparing_records/DE_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for Elkhorn Slough
ES_species_list_WOS_full <- ES_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(ES_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
ES_species_list_WOS_full <- ES_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(ES_species_list_WOS_full, file = "mitohelper_reference/comparing_records/ES_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for San Francisco
SF_species_list_WOS_full <- SF_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(SF_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
SF_species_list_WOS_full <- SF_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(SF_species_list_WOS_full, file = "mitohelper_reference/comparing_records/SF_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for San Pablo
SP_species_list_WOS_full <- SP_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(SP_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
SP_species_list_WOS_full <- SP_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(SP_species_list_WOS_full, file = "mitohelper_reference/comparing_records/SP_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for Suisun
S_species_list_WOS_full <- S_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(S_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
S_species_list_WOS_full <- S_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(S_species_list_WOS_full, file = "mitohelper_reference/comparing_records/S_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for Tomales Bay
TB_species_list_WOS_full <- TB_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(TB_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
TB_species_list_WOS_full <- TB_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(TB_species_list_WOS_full, file = "mitohelper_reference/comparing_records/TB_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for Bodega
B_species_list_WOS_full <- B_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(B_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
B_species_list_WOS_full <- B_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(B_species_list_WOS_full, file = "mitohelper_reference/comparing_records/B_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for Russian River
RR_species_list_WOS_full <- RR_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(RR_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))

# reorder columns
RR_species_list_WOS_full <- RR_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(RR_species_list_WOS_full, file = "mitohelper_reference/comparing_records/RR_WOS_species_list_reference_seq_found.csv")

# add column MitoFish record & populate with ifelse statement for Humboldt
H_species_list_WOS_full <- H_species_list_WOS_full %>% 
  add_column(`MitoFish record` = ifelse(H_species_list_WOS_full$`Genus species` %in% species_list_record, "yes", "no"))
#.after = `Genus species` did not recognize variable

# reorder columns
H_species_list_WOS_full <- H_species_list_WOS_full[, c(1, 2, 8, 3, 4, 5, 6, 7)]

write_csv(H_species_list_WOS_full, file = "mitohelper_reference/comparing_records/H_WOS_species_list_reference_seq_found.csv")

# row bind all dataframes
WOS_species_all_estuaries <- bind_rows(ES_species_list_WOS_full, SF_species_list_WOS_full, 
                                       SP_species_list_WOS_full, S_species_list_WOS_full,
                                       TB_species_list_WOS_full, B_species_list_WOS_full,
                                       DE_species_list_WOS_full, RR_species_list_WOS_full,
                                       H_species_list_WOS_full)

write_csv(WOS_species_all_estuaries, file = "mitohelper_reference/comparing_records/all_estuaries_WOS_species_list_reference_seq_found.csv")

# total species in regional pool (150)
WOS_species_all_estuaries_unique <- WOS_species_all_estuaries %>% distinct(`Genus species`, `common name`)

# list of redundant common names 
remove <- c("Kelp surfperch", "Monkey-faced eel", "Shiner surfperch", "Black surfperch", 
            "Striped surfperch", "Western mosquito fish", "Three-spine stickleback",
            "Threespine stickleback", "Walleye surf perch", "Surfs smelt", "Staghorn Sculpin", 
            "Rainwater killfish", "Dwarf surfperch", "Brown smoothhounds", "Smoothhound shark",
            "Steelhead trout", "White surf perch", "White surfperch", "Starry Flounder", 
            "Pile surfperch", "Shokahazi goby")

# list of family and genus without species            
remove2 <- c("Clupeidae", "Sebasates sp.", "Sebastes spp.")

# filter out spurious records (129 records)
WOS_species_all_estuaries_unique <- WOS_species_all_estuaries_unique %>% 
  filter(!`common name` %in% remove)

# filter out non-species (126 records; 2 are updated taxonomy for the same species)
WOS_species_all_estuaries_unique <- WOS_species_all_estuaries_unique %>% 
  filter(!`Genus species` %in% remove2)

# filter to obtain df of species without a reference record across all estuaries 
WOS_species_all_estuaries_no_ref_record <- filter(WOS_species_all_estuaries, `MitoFish record` == "no") # 107 across estuaries 
# remove genus and family groups (not species)
WOS_species_all_estuaries_no_ref_record <- WOS_species_all_estuaries_no_ref_record %>% filter(!`Genus species` %in% remove2)
# unique genus species list without reference records
no_ref_record_species <- unique(WOS_species_all_estuaries_no_ref_record$`Genus species`) # 51

# filter to Drakes Estero only; 9 without records
WOS_species_Drakes_no_ref_record <- WOS_species_all_estuaries_no_ref_record %>% filter(location == "Drakes Estero")

# subset to the columns of interest 
WOS_species_Drakes_no_ref_record <- WOS_species_Drakes_no_ref_record[ , c(1,2)]

write_csv(WOS_species_Drakes_no_ref_record, file = "mitohelper_reference/comparing_records/Drakes_spp_no_ref_record.csv")

# subset all estuaries to columns of interest
WOS_species_all_estuaries_no_ref_record_subset <- WOS_species_all_estuaries_no_ref_record[ , c(1,2)]

# identify unique genus species without a record (58 records, some records are spurious, alt common name)
WOS_species_all_estuaries_no_ref_record_unique <- WOS_species_all_estuaries_no_ref_record_subset %>% distinct(`Genus species`, `common name`)

# list of redundant record alt. common name 
cn_list <- c("Monkey-faced eel", "Walleye surf perch","Dwarf surfperch",
             "Brown smoothhounds","Smoothhound shark","White surf perch","White surfperch")

# remove redundant records with different common names/spelling
WOS_species_all_estuaries_no_ref_record_unique <- WOS_species_all_estuaries_no_ref_record_unique %>% filter(!`common name` %in% cn_list)

# 51 records of genus species from WOS without ref record
write_csv(WOS_species_all_estuaries_no_ref_record_unique, file = "mitohelper_reference/comparing_records/all_estuaries_spp_no_ref_record.csv")

# Mitofish record all estuaries without Suisun ----------------------------

# row bind all dataframes
WOS_species_all_estuaries_2 <- bind_rows(ES_species_list_WOS_full, SF_species_list_WOS_full, 
                                       SP_species_list_WOS_full,
                                       TB_species_list_WOS_full, B_species_list_WOS_full,
                                       DE_species_list_WOS_full, RR_species_list_WOS_full,
                                       H_species_list_WOS_full)

# total species in regional pool (129)
WOS_species_all_estuaries_unique_2 <- WOS_species_all_estuaries_2 %>% distinct(`Genus species`, `common name`)

# list of redundant common names 
remove <- c("Kelp surfperch", "Monkey-faced eel", "Shiner surfperch", "Black surfperch", 
            "Striped surfperch", "Western mosquito fish", "Three-spine stickleback",
            "Threespine stickleback", "Walleye surf perch", "Surfs smelt", "Staghorn Sculpin", 
            "Rainwater killfish", "Dwarf surfperch", "Brown smoothhounds", "Smoothhound shark",
            "Steelhead trout", "White surf perch", "White surfperch", "Starry Flounder", 
            "Pile surfperch", "Shokahazi goby")

# list of family and genus names without species            
remove2 <- c("Clupeidae", "Sebasates sp.", "Sebastes spp.")

# filter out spurious records (111 records)
WOS_species_all_estuaries_unique_2 <- WOS_species_all_estuaries_unique_2 %>% 
  filter(!`common name` %in% remove)

# filter out non-species (108 records; 2 are updated taxonomy for the same species; 106 species regionally)
WOS_species_all_estuaries_unique_2 <- WOS_species_all_estuaries_unique_2 %>% 
  filter(!`Genus species` %in% remove2)

# filter all species without a reference record
WOS_species_all_estuaries_no_ref_record_2 <- filter(WOS_species_all_estuaries_2, `MitoFish record` == "no") 

# subset all estuaries to columns of interest
WOS_species_all_estuaries_no_ref_record_2_subset <- WOS_species_all_estuaries_no_ref_record_2[ , c(1,2)]

# identify unique genus species without a record (56, some are spurious: families, genus, alt common name)
WOS_species_all_estuaries_no_ref_record_unique_2 <- WOS_species_all_estuaries_no_ref_record_2_subset %>% distinct(`Genus species`, `common name`)

# vector of redundant record alt. common name 
cn_list <- c("Monkey-faced eel", "Walleye surf perch","Dwarf surfperch",
             "Brown smoothhounds","Smoothhound shark","White surf perch","White surfperch")

# remove redundant records with different common names/spelling
WOS_species_all_estuaries_no_ref_record_unique_2 <- WOS_species_all_estuaries_no_ref_record_unique_2 %>% filter(!`common name` %in% cn_list)

# vector of family or genus without species
gs_list <- c("Clupeidae", "Sebasates sp.", "Sebastes spp.")

# remove records with family, or genus with no species listed (46 species across all estuaries except Suisun that lack ref. seqs, 2 are updated taxonomy, 44 species w/o ref records)
WOS_species_all_estuaries_no_ref_record_unique_2 <- WOS_species_all_estuaries_no_ref_record_unique_2 %>% filter(!`Genus species` %in% gs_list)

write_csv(WOS_species_all_estuaries_no_ref_record_unique_2, file = "mitohelper_reference/comparing_records/all_estuaries_except_Suisun_spp_no_ref_record.csv")

# get difference between all species all estuaries and all estuaries without Suisun
Diff <- anti_join(WOS_species_all_estuaries_unique, WOS_species_all_estuaries_unique_2) # 18 suisun specific species

# vector of suisun specific species
suisun_specific_genus_sp <- Diff$`Genus species`

# remove Suisun specific records from "all_get_record_taxonomy_filtered_remove_spurious_hit" 196 with Suisun; 129 without (many redundant species)
get_record_taxonomy_filtered <- all_get_record_taxonomy_filtered_remove_spurious_hit %>% filter(!(Genus.species %in% suisun_specific_genus_sp))

# Accessions for phylogenetic tree ----------------------------------------

# keep only the first 5 records of each species
# individually: 
#Acanthogobius_flavimanus <- get_record_taxonomy_filtered %>% filter(Genus.species == "Acanthogobius flavimanus")
#Acanthogobius_flavimanus <- Acanthogobius_flavimanus[1:5, ]

# for loop
# vector of Genus.species names
species_unique <- unique(get_record_taxonomy_filtered$Genus.species)

# list to accumulate subsetted dataframes
record_table <- list()

for(i in seq_along(species_unique)) {
  X=subset(get_record_taxonomy_filtered, Genus.species == species_unique[i])
  temp=X[1:5, ] #subset to the first 5 rows of reference records for the ith species
  record_table[[i]] <- temp # assign df as the ith item of list
  print(temp)
}

# bind items in record_table list with rbind/bind_rows
record_table <- bind_rows(record_table)

# filter out rows with NA (for those with fewer than 5 records for a species)
record_table <- record_table %>% filter(!is.na(Accession))

# only 120 accessions when retaining up to 5 records max per species to generate phylogenetic tree
  
# change name of column "Accession" to "label" to match tree labels in ggtree 
names(record_table)[names(record_table) == "Accession"] <- "label"

# accession numbers of species for q2-phylogeny tree
accessions <- as.data.frame(record_table$label)
names(accessions)[1] <- "Feature-ID"

accessions$`Feature-ID` <- trimws(accessions$`Feature-ID`, "both")

write.table(accessions, file = "mitohelper_reference/comparing_records/accessions-Feature-ID.txt",
               sep = "\t", quote = FALSE, row.names = FALSE)

# add column of accession plus highest level taxonomy as "Species" to match the taxonomy tip labels from blast assignments of our seqs for ggtree
record_table$label_sp <- paste(record_table$label, record_table$Genus.species)

# remove white space
record_table$label <- trimws(record_table$label, "both")

# write csv 
write_csv(record_table, file = "mitohelper_reference/comparing_records/Mitohelper_records_accession_taxonomy_five_max_per_spp.csv")
