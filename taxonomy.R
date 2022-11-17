library(phyloseq); packageVersion("phyloseq")
library(plyr); packageVersion("plyr")
library(tidyverse); packageVersion("tidyverse")

# read in rds files
Point_Reyes_fish_2021_phyloseq_obj_80 <- readRDS(file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_80.rds")
Point_Reyes_fish_2021_phyloseq_obj_90 <- readRDS(file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_90.rds")
Point_Reyes_fish_2021_phyloseq_obj_95 <- readRDS(file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_95.rds")
Point_Reyes_fish_2021_phyloseq_obj_97 <- readRDS(file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_97.rds")
Point_Reyes_fish_2021_phyloseq_obj_99 <- readRDS(file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99.rds")
# read rds files with rarefied table 
Point_Reyes_fish_2021_phyloseq_obj_99_rarefied <- readRDS(file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99_rarefied.rds")

# export taxonomy table to df
Tax99 <- as.data.frame(tax_table(Point_Reyes_fish_2021_phyloseq_obj_99))
Tax97 <- as.data.frame(tax_table(Point_Reyes_fish_2021_phyloseq_obj_97))
Tax95 <- as.data.frame(tax_table(Point_Reyes_fish_2021_phyloseq_obj_95))
Tax90 <- as.data.frame(tax_table(Point_Reyes_fish_2021_phyloseq_obj_90))
Tax80 <- as.data.frame(tax_table(Point_Reyes_fish_2021_phyloseq_obj_80))

# remove rows with unassigned and add column with percent similarity blastn
Tax99_red <- filter(Tax99, Kingdom != "Unassigned") # 44 entries
Tax99_red$Percent_similarity <- c("0.99")
Tax97_red <- filter(Tax97, Kingdom != "Unassigned") # 67 entries
Tax97_red$Percent_similarity <- c("0.97")
Tax95_red <- filter(Tax95, Kingdom != "Unassigned") # 80 entries
Tax95_red$Percent_similarity <- c("0.95")
Tax90_red <- filter(Tax90, Kingdom != "Unassigned") # 131 entries
Tax90_red$Percent_similarity <- c("0.90")
Tax80_red <- filter(Tax80, Kingdom != "Unassigned") # 133 entries
Tax80_red$Percent_similarity <- c("0.80")

# get unique row names
hash_id_99 <- row.names(Tax99_red)
length(hash_id_99) # 44
hash_id_97 <- row.names(Tax97_red)
length(hash_id_97) #67
hash_id_95 <- row.names(Tax95_red)
length(hash_id_95) #80
hash_id_90 <- row.names(Tax90_red)
length(hash_id_90) #131
hash_id_80 <- row.names(Tax80_red)
length(hash_id_80) # 133

# find intersection 97 to 99 hash ids
hash_intersect_97 <- intersect(hash_id_99, hash_id_97)
length(hash_intersect_97) #44 

# remove intersect hash ids from 97 df
Tax97_fill <- Tax97_red %>% filter(!row.names(Tax97_red) %in% hash_intersect_97)
nrow(Tax97_fill) # 23
nrow(Tax99_red) # 44 
Tax99_bind <- bind_rows(Tax99_red, Tax97_fill)
nrow(Tax99_bind) #67

# hash id from Tax99_bind
hash_id_bind <- row.names(Tax99_bind)
length(hash_id_bind) #67

# find intersection 95 to hash_id_bind 
hash_intersect_95 <- intersect(hash_id_bind, hash_id_95)
length(hash_intersect_95) #67 

# remove intersect hash ids from 95 df
Tax95_fill <- Tax95_red %>% filter(!row.names(Tax95_red) %in% hash_intersect_95)
nrow(Tax95_fill) # 13
nrow(Tax99_bind) # 67 
# bind rows
Tax99_bind <- bind_rows(Tax99_bind, Tax95_fill)
nrow(Tax99_bind) #80

# hash id from Tax99_bind
hash_id_bind <- row.names(Tax99_bind)
length(hash_id_bind) #80

# find intersection 90 to hash_id_bind 
hash_intersect_90 <- intersect(hash_id_bind, hash_id_90)
length(hash_intersect_90) #80 

# remove intersect hash ids from 90 df
Tax90_fill <- Tax90_red %>% filter(!row.names(Tax90_red) %in% hash_intersect_90)
nrow(Tax90_fill) # 51
nrow(Tax99_bind) # 80 
# bind rows
Tax99_bind <- bind_rows(Tax99_bind, Tax90_fill)
nrow(Tax99_bind) #131

# hash id from Tax99_bind
hash_id_bind <- row.names(Tax99_bind)
length(hash_id_bind) #131

# find intersection 80 to hash_id_bind 
hash_intersect_80 <- intersect(hash_id_bind, hash_id_80)
length(hash_intersect_80) #131

# remove intersect hash ids from 80 df
Tax80_fill <- Tax80_red %>% filter(!row.names(Tax80_red) %in% hash_intersect_80)
nrow(Tax80_fill) # 2
nrow(Tax99_bind) # 131 
# bind rows
Tax99_bind <- bind_rows(Tax99_bind, Tax80_fill)
nrow(Tax99_bind) #131

# create column of original species names 
Tax99_bind$Species_original <- Tax99_bind$Species

# assign species names using percent similarity cut-offs and known local species within families and genera 
Tax99_bind["1619bfbfbf170f029b6bb07e1743aa6b", "Species"] <- c("Sebastes spp.")
Tax99_bind["74078649161809205b28820e559709ca", "Species"] <- c("Sebastes spp.")

Tax99_bind["d7a7cc948e01e8b0244d4ec4a4d2a96d", "Species"] <- c("Clupea sp.")
Tax99_bind["713bc81ae26f1bfd1f4ba40e0d1f9a0c", "Species"] <- c("Clupea sp.")
Tax99_bind["fa2c598db26e768bcdf874ba80f15fc0", "Species"] <- c("Clupea sp.")
Tax99_bind["b8a7541fbc5050bcc6e818a0b8f178f3", "Species"] <- c("Clupea sp.")

Tax99_bind["e907926b916c99c2df748176ded2816c", "Species"] <- c("Pholis spp.")
Tax99_bind["065bb83115ea3cd11dca01c27cadaa86", "Species"] <- c("Pholis spp.")

Tax99_bind["58ad03e4480d57d138900787cf9749a8", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["4ed9678ca1808f8142bf8d234b0c3416", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["47f39da2a5f249e1446eec484f81349f", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["b19123e4480b4745bb35043eeca9dd82", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["e4f4f4afbc9766927ff2dbf509bcc25f", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["dde963c72cb1ed393c6a30bed7f01f4f", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["5ce60c451f3fc488898fd202299ba851", "Species"] <- c("Pleuronectidae spp.")
Tax99_bind["ce60dca33039cd6cd1b8c8536e9f43fa", "Species"] <- c("Pleuronectidae spp.")

Tax99_bind["199a94f506402a97399cab35d67a4a5e", "Species"] <- c("Phanerodon vacca")
Tax99_bind["df36fd500c8c3b1b1bcf0af474fcc984", "Species"] <- c("Phanerodon vacca")
Tax99_bind["1fc05250f0e232d3d733bede8a11122a", "Species"] <- c("Phanerodon vacca")
Tax99_bind["8786f3ca621cad1b86b7bf43b38927c4", "Species"] <- c("Phanerodon vacca")

Tax99_bind["36cb7d1d51cccfa42393fba669b5ad3c", "Species"] <- c("Cottidae spp.")
Tax99_bind["14c1d2582b7f6504d101562456aeb1a0", "Species"] <- c("Cottidae spp.")
Tax99_bind["587c9a06cb3c544f4b3b7ee1192c49bb", "Species"] <- c("Cottidae spp.")
Tax99_bind["1845e3066fc61a10224e7787c06eb6bf", "Species"] <- c("Cottidae spp.")
Tax99_bind["de0fe0630b03912a42c1c2a2f77ca862", "Species"] <- c("Cottidae spp.")

Tax99_bind["2b9fdd3aaacca720b2073b0edee689a0", "Species"] <- c("Engraulis sp./Engraulis mordax*")
Tax99_bind["812e8b400d7c936c16a28ef16b9e146d", "Species"] <- c("Engraulis sp./Engraulis mordax*")
Tax99_bind["d848a2ec80b41203c85b97076ed339ac", "Species"] <- c("Engraulidae/Engraulis mordax*")

Tax99_bind["c4b051ff7b56c49727720f39594d18b6", "Species"] <- c("Citharichthys sp.")

Tax99_bind["783b88f96c3437e808c598a199571cf6", "Species"] <- c("Paralichthyidae spp.")
Tax99_bind["4ec5fc0b99562f2e1418e22b1c56ef97", "Species"] <- c("Paralichthyidae spp.")

Tax99_bind["03bea5eeb77cd24af5e762cce8d2e8ba", "Species"] <- c("Paralichthys sp./Paralichthys californicus*")
Tax99_bind["1d0eec386e5ce198c80c429120faa24f", "Species"] <- c("Paralichthys sp./Paralichthys californicus*")
Tax99_bind["fca739178be0061f435f7c3660b3ef21", "Species"] <- c("Paralichthys sp./Paralichthys californicus*")

Tax99_bind["b4fe2bc95841ff8c85773cf18f0532dc", "Species"] <- c("Embiotoca sp./Embiotoca lateralis*")
Tax99_bind["e0b687edcf957054a5f9a56ce1a91d86", "Species"] <- c("Embiotoca sp./Embiotoca lateralis*")
Tax99_bind["b58dea87f1a2aac5299ccc97b48fc4c7", "Species"] <- c("Embiotoca sp./Embiotoca lateralis*")

Tax99_bind["2ad17405713ddb357695497e50150b80", "Species"] <- c("Triakidae")

Tax99_bind["63ab65275d6d512155179c87dcea0584", "Species"] <- c("Myliobatidae/Myliobatus californicus*")
Tax99_bind["be0a2cee82cec9bf8bd06175def97323", "Species"] <- c("Myliobatidae/Myliobatus californicus*")
Tax99_bind["0fbbd45b7defe88573020cf37c5d565f", "Species"] <- c("Myliobatidae/Myliobatus californicus*")

Tax99_bind["d11548ca6567612209ada9feca6ccfdf", "Species"] <- c("Myliobatiformes")
Tax99_bind["07199023e09d718f2992614687413e44", "Species"] <- c("Myliobatiformes")

Tax99_bind["2a8cd19b6e93f464ed687e1a88eacbf2", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["e29c445577c17928bf59f6322b75a154", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["c52905fcbe03a15a9ddfb372311215d9", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["11b8ed23829f95898b506ca5d35edf41", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["305a56a009866801c1f7510821689e47", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["3c478b4945257084f2b25473148db2f0", "Species"] <- c("Syngnathidae spp.")

Tax99_bind["9128e53b95f6abd5aa439e2769e97bb8", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["589a3561d8ddc06bc295059c6cc62d5f", "Species"] <- c("Syngnathidae spp.")
Tax99_bind["e108651a6d775989038df3a4676e7eb9", "Species"] <- c("Syngnathidae spp.")

Tax99_bind["28559ff50a148c565145c340beb1573c", "Species"] <- c("Gobiidae spp.")
Tax99_bind["177c6e7d62e4d4a6cafaec82b2174b82", "Species"] <- c("Gobiidae spp.")
Tax99_bind["e77ce86a98c7a05f18c4847dc3932601", "Species"] <- c("Gobiidae spp.")
Tax99_bind["087be4c9562e638ac1f3d77f4c5599f1", "Species"] <- c("Gobiidae spp.")
Tax99_bind["d8971e6ce852bbec2f2b79ef7e711afc", "Species"] <- c("Gobiidae spp.")
Tax99_bind["b45e61479ccf07b2caf17f74f8b68a24", "Species"] <- c("Gobiidae spp.")
Tax99_bind["072e3c820485ffebc4dc6fc859c1e0d6", "Species"] <- c("Gobiidae spp.")
Tax99_bind["cffa91b879331061e50c40a064c0e641", "Species"] <- c("Gobiidae spp.")
Tax99_bind["05bdaf674fea56b779e7372d51eea019", "Species"] <- c("Gobiidae spp.")
Tax99_bind["38b257f643a93cf1181e900d752a99a5", "Species"] <- c("Gobiidae spp.")
Tax99_bind["4ff0ce04df2b9c6fe37577488bda657f", "Species"] <- c("Gobiidae spp.")
Tax99_bind["fb8fd8484c0f843b4066e5d7f2659bc5", "Species"] <- c("Gobiidae spp.")
Tax99_bind["089ff29e42a7503b3434085906175530", "Species"] <- c("Gobiidae spp.")
Tax99_bind["148e26fcb2c0367c6e26fe4ba73afb2f", "Species"] <- c("Gobiidae spp.")
Tax99_bind["7c71959d7c454c7cc70aeda34775a9f8", "Species"] <- c("Gobiidae spp.")
Tax99_bind["c679bcb640ca4cb68a6e352517aa1660", "Species"] <- c("Gobiidae spp.")

Tax99_bind["8acdf5306f37bc8e0517aaeaa495f19f", "Species"] <- c("Sciaenidae spp.")
Tax99_bind["d50c2312ec1989e9087e1e2f36b4382e", "Species"] <- c("Sciaenidae spp.")

Tax99_bind["588da25cb625b652678ca4428b55ba90", "Species"] <- c("Paralichthyidae spp.")
Tax99_bind["b7e91dfccc9b1cc67848806741ec1fdd", "Species"] <- c("Paralichthyidae spp.")

Tax99_bind["7ad2ad4af0febb15d8f9cfc359bcd138", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["e1f8ab7407d16d2f2d5ba42c7593bd43", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["446d5ac4fa34e82a4ae58c2049101fdb", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["c6c28bc054642744d36299bd70a89866", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["b3bbf449b2371014931c1047c2fb699f", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["ef10514dc283b0490f1a1a9277cbde25", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["5a3ebf84a87d38db79a302a41261e6d7", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["caae53ef6b0794ec755824bc7074874d", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["696ec0559a692a6a9440c3dd5165e760", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["6f03f9c824ffa728ebe17a260727383e", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["2c698298d3e06135520a21b5ab95e4c0", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["c5e57d585f4713c0602935e97d0ae1b0", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["61fe8ff54e9df175b7a5a05c53ff0163", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["be056b9d38c153868036c50ed3e3c6c2", "Species"] <- c("Atherinopsidae spp.")
Tax99_bind["2aa00e02427e78bb967ec239c1535151", "Species"] <- c("Atherinopsidae spp.")

Tax99_bind["a058b83ba4d57898e6d04d9829ee3805", "Species"] <- c("Embiotocidae spp.")
Tax99_bind["929ab303292f24662fe0d06afdaa3784", "Species"] <- c("Embiotocidae spp.")

Tax99_bind["511d84f8448fa0e5fcba23dd6a944fcc", "Species"] <- c("Actinopteri spp.")
Tax99_bind["3cd6e69cee6a80e141db54591468cab8", "Species"] <- c("Actinopteri spp.")

# create column for common names
Tax99_bind$Common_name <- Tax99_bind$Species

# add common names
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Amphistichus argenteus", replacement = "barred surfperch")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Clupea pallasii", replacement = "Pacific herring")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Cymatogaster aggregata", replacement = "shiner perch")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Embiotoca jacksoni", replacement = "black surfperch")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Embiotoca sp./Embiotoca lateralis*", replacement = "striped seaperch")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Gasterosteus aculeatus", replacement = "three-spined stickleback")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Hexagrammos decagrammus", replacement = "kelp greenling")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Leptocottus armatus", replacement = "Pacific staghorn sculpin")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Ophiodon elongatus", replacement = "lingcod")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Phanerodon vacca", replacement = "pile perch") # Phanerodon vacca updated taxonomy
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Engraulis sp./Engraulis mordax*", replacement = "Californian anchovy") 
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Engraulidae/Engraulis mordax*", replacement = "Californian anchovy")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Paralichthys sp./Paralichthys californicus*", replacement = "California halibut")
Tax99_bind$Common_name <- Tax99_bind$Common_name %>% gsub(pattern = "Myliobatidae/Myliobatus californicus*", replacement = "bat eagle ray")

# replace null values with string "NA" for consistency
Tax99_bind[is.na(Tax99_bind)] <- c("NA")

# reorder columns
Tax99_bind <- Tax99_bind[, c(1, 2, 3, 4, 5, 6, 10, 7, 11, 9, 8)]
# change column name to Domain
colnames(Tax99_bind)[1] <- "Domain"
# remove domain underscore from levels of Domain
Tax99_bind$Domain <- gsub(Tax99_bind$Domain, pattern = "d__", replacement = "")

length(Tax99_bind$Common_name)
length(unique(Tax99_bind$Common_name)) 
unique(Tax99_bind$Common_name) # print unique common names
unique(Tax99_bind$Species) # print unique taxonomic labels
#write_csv(Tax99_bind, file = "out_files/taxonomy_99_80_percent_similarity.csv")
Tax99_bind$label <- rownames(Tax99_bind)
write_csv(Tax99_bind, file = "out_files/taxonomy_99_80_percent_similarity_with_hashid.csv")

# create phyloseq obj. with updated taxononmy
# convert to matrix
tax_mine_2 <- as.matrix(Tax99_bind, rownames = TRUE, colnames = TRUE)

# replace phyloseq object tax_table with updated taxonomy matrix
tax_table(Point_Reyes_fish_2021_phyloseq_obj_99) <- tax_mine_2
view(tax_table(Point_Reyes_fish_2021_phyloseq_obj_99))
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_99, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99_80.rds")

# replace phyloseq object tax_table with updated taxonomy matrix for rarefied phyloseq object
tax_table(Point_Reyes_fish_2021_phyloseq_obj_99_rarefied) <- tax_mine_2
view(tax_table(Point_Reyes_fish_2021_phyloseq_obj_99_rarefied))
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_99_rarefied, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99_80_rarefied.rds")

# glom on Species 
# merge ASVs that have the same classification at taxonomic rank species (with updated taxonomy); keep NAs to match qiime2 glom
Point_Reyes_fish_2021_phyloseq_obj_99_80_Species = tax_glom(Point_Reyes_fish_2021_phyloseq_obj_99, taxrank = "Species", NArm = FALSE)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_99_80_Species, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99_80_Species.rds")

# glom on Species for rarefied data
# merge ASVs that have the same classification at taxonomic rank species (with updated taxonomy); keep NAs to match qiime2 glom
Point_Reyes_fish_2021_phyloseq_obj_99_80_rarefied_species = tax_glom(Point_Reyes_fish_2021_phyloseq_obj_99_rarefied, taxrank = "Species", NArm = FALSE)
saveRDS(Point_Reyes_fish_2021_phyloseq_obj_99_80_rarefied_species, file = "phyloseq_objects/Point_Reyes_fish_2021_phyloseq_obj_99_80_rarefied_species.rds") 
