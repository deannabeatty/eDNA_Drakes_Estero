library(dplyr)
library(Biostrings)

# import qiime filtered ref database seq & tax files from 10.5281/zenodo.6336244 exported to tsv with qiime2; format for mitohelper python tool --------------------------------------

db_12S_tax_derep_uniq <- read.csv(file = "qza_files/12S-tax-derep-uniq/taxonomy.tsv")

# split the Feature.ID.Taxon string to obtain Feature and Taxon
feat_split <- strsplit(db_12S_tax_derep_uniq$Feature.ID.Taxon, "\t")
# view transposed string split taxonomy
#view(t(data.frame(feat_split)))

# make dataframe
db_12S_tax_derep_uniq_split <- data.frame(t(data.frame(feat_split)))

# split the taxonomy string to obtain unique taxonomy, creates a list
s_tax <- strsplit(db_12S_tax_derep_uniq_split$X2, ";")

# view transposed string split taxonomy
view(t(data.frame(s_tax)))

# transpose the taxonomy and add accessions
db_12S_tax_derep_uniq_2 <- data.frame(Accession = db_12S_tax_derep_uniq_split$X1, 
                                      Superkingdom = t(data.frame(s_tax))[,1], 
                                      Phylum = t(data.frame(s_tax))[,2], 
                                      Class = t(data.frame(s_tax))[,3], 
                                      Order = t(data.frame(s_tax))[,4], 
                                      Family = t(data.frame(s_tax))[,5], 
                                      Genus = t(data.frame(s_tax))[,6],
                                      Species = t(data.frame(s_tax))[,7])                                                


# read in fasta file of qiime2 formatted sequences
db_12S_seq_derep_uniq <- readDNAStringSet(filepath = "qza_files/12S-seqs-derep-uniq/dna-sequences.fasta")
Accession <- names(db_12S_seq_derep_uniq)
Sequence <- paste(db_12S_seq_derep_uniq)
db_12S_seq_derep_uniq_df <- data.frame(Accession, Sequence)

# now left join sequences to taxonomy in one df
db_12S_tax_seq_derep_uniq <- left_join(db_12S_tax_derep_uniq_2, db_12S_seq_derep_uniq_df, by = "Accession")

# clean the taxonomy names 
db_12S_tax_seq_derep_uniq$Superkingdom <- gsub(db_12S_tax_seq_derep_uniq$Superkingdom, pattern = "d__", replacement = "")
db_12S_tax_seq_derep_uniq$Phylum <- gsub(db_12S_tax_seq_derep_uniq$Phylum, pattern = "p__", replacement = "")
db_12S_tax_seq_derep_uniq$Class <- gsub(db_12S_tax_seq_derep_uniq$Class, pattern = "c__", replacement = "")
db_12S_tax_seq_derep_uniq$Order <- gsub(db_12S_tax_seq_derep_uniq$Order, pattern = "o__", replacement = "")
db_12S_tax_seq_derep_uniq$Family <- gsub(db_12S_tax_seq_derep_uniq$Family, pattern = "f__", replacement = "")
db_12S_tax_seq_derep_uniq$Genus <- gsub(db_12S_tax_seq_derep_uniq$Genus, pattern = "g__", replacement = "")
db_12S_tax_seq_derep_uniq$Species <- gsub(db_12S_tax_seq_derep_uniq$Species, pattern = "s__", replacement = "")

# add columns to match tsv file from mitohelper website
db_12S_tax_seq_derep_uniq$`Gene definition` <- c("")
db_12S_tax_seq_derep_uniq$`taxid` <- c("")
db_12S_tax_seq_derep_uniq$OrderID <- c("")
db_12S_tax_seq_derep_uniq$FamilyID <- c("")

# reorder columns to match mitohelper tsv
db_12S_tax_seq_derep_uniq <- db_12S_tax_seq_derep_uniq[ , c(1, 10, 11, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13) ]

write_tsv(db_12S_tax_seq_derep_uniq, file = "mitohelper_reference/12S_tax_seq_derep_uniq_Mar2022_for_mitohelper_exact.tsv")
