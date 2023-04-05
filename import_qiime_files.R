library(qiime2R) 
library(phyloseq)

# import metadata 
metadata <- read.table("clean/DE_2021_eDNA_metadata.txt", sep = "\t", header = TRUE)

#import taxonomy (includes some unassigned taxa)
Taxonomy_80 <- read_qza("qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_80.qza")
head(Taxonomy_80$data)
Taxonomy_80 <- parse_taxonomy(Taxonomy_80$data)
head(Taxonomy_80)

#import feature table 
Point_Reyes_fish_2021 <- read_qza("qza_files/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza")
#types of information in the imported object
names(Point_Reyes_fish_2021)
#phyloseq object data each row denotes a sequence variant identified by unique hash ID  
Point_Reyes_fish_2021$data[1:5,1:5]
#unique identifier for this object
Point_Reyes_fish_2021$uuid
#type of file, FeatureTable[Frequency]
Point_Reyes_fish_2021$type
#Point_Reyes_fish_2021_table <- Point_Reyes_fish_2021$data

#create phyloseq object on non-rarefied data blast 80% similarity 
Point_Reyes_fish_2021_phyloseq_obj_80 <- qza_to_phyloseq(
  features = "qza_files/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_80.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_80, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_80.rds")
view(tax_table(Point_Reyes_fish_2021_phyloseq_obj_80))

#create phyloseq object on non-rarefied data 90% similarity
Point_Reyes_fish_2021_phyloseq_obj_90 <- qza_to_phyloseq(
  features = "qza_files/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_90.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_90, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_90.rds")

#create phyloseq object on non-rarefied data 95% similarity
Point_Reyes_fish_2021_phyloseq_obj_95 <- qza_to_phyloseq(
  features = "qza_files/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_95.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_95, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_95.rds")

#create phyloseq object on non-rarefied data 97% similarity
Point_Reyes_fish_2021_phyloseq_obj_97 <- qza_to_phyloseq(
  features = "qza_files/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_97.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_97, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_97.rds")

#create phyloseq object on non-rarefied data 99% similarity
Point_Reyes_fish_2021_phyloseq_obj_99 <- qza_to_phyloseq(
  features = "qza_files/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_99.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_99, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99.rds")

#create phyloseq object on rarefied data with 99% percent similarity
Point_Reyes_fish_2021_phyloseq_obj_99_rarefied <- qza_to_phyloseq(
  features = "qza_files/rarefied_table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_99.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_99_rarefied, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99_rarefied.rds")
view(tax_table(Point_Reyes_fish_2021_phyloseq_obj_99_rarefied))

# create phyloseq object on non-clustered and non-rarefied data with 97% similarity
Point_Reyes_fish_2021_phyloseq_obj_nonrarefied_nonclustered <- qza_to_phyloseq(
  features = "qza_files/table_fish_2021_dada2.qza",
  taxonomy = "qza_files/rep_seqs_fish_2021_dada2_mitofish_blast_taxonomy_12S_16S_18S_97.qza",
  metadata = "clean/DE_2021_eDNA_metadata.txt"
)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_nonrarefied_nonclustered, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_nonrarefied_nonclustered.rds")
view(tax_table(Point_Reyes_fish_2021_phyloseq_obj_nonrarefied_nonclustered))
