# create conda env
#conda create --name R_4.1.1
# activate conda env
#conda activate R_4.1.1
# install R 4.1.1
#conda install -c conda-forge r-base=4.1.1

# navigate to tree directory within project
#cd /git_repos/eDNA_Drakes_Estero/qza_files/tree

# start R terminal
#R

# navigate to the folder with the tree
# cd qza/tree/

# above steps in terminal

# install packages
if (!require("BiocManager", quietly = TRUE))
   install.packages("BiocManager")
BiocManager::install("ggtree")

install.packages("phytools",repos="https://cloud.r-project.org",quiet=TRUE)

# load libraries
library(ggtree); packageVersion("ggtree")
library(phytools); packageVersion("phytools")
library(dplyr); packageVersion("dplyr")

# read in newick tree
t <- read.newick(file="tree.nwk") 
# Phylogenetic tree with 253 tips and 252 internal nodes. 133 are OTUs from our sequence data. 120 ref seqs

# plot tree with only node labels with values > 0.5
ggtree(t) + geom_label2(aes(label=label, subset=!is.na(as.numeric(label)) & as.numeric(label) > 0.5))

# read in taxonomy with hash id as "label"
tax <- read.csv(file = "../out_files/taxonomy_99_80_percent_similarity_with_hashid.csv")

# full join dataframe on the tidytree to add taxonomy metadata
t_tax <- full_join(t, tax, by = 'label') 

#plot tree with only node labels with values > 0.5
ggtree(t_tax) + geom_label2(aes(label=label, subset=!is.na(as.numeric(label)) & as.numeric(label) > 0.5))

# read in mitohelper accessions (after filtering) and associated taxonomy for ref. seqs (up to 5 seqs per species)
ref_tax <- read.csv(file = "../mitohelper_reference/comparing_records/Mitohelper_records_accession_taxonomy_five_max_per_spp.csv")
dim(ref_tax) # 120 x 8 

# subset ref_tax to columns of interest
ref_tax_r = ref_tax[ ,c(1, 8)]
dim(ref_tax_r) # 120 x 2

# colors
colfam =  c("#4E79A7", "#A0CBE8", "#F28E2B", "#FFBE7D", "#59A14F", "#8CD17D", "#B6992D", "#F1CE63", "#499894","darkgray", "#86BCB6", "#E15759", "#FF9D9A", "#D37295", "#FABFD2", "#B07AA1", "#D4A6C8", "#9D7660", "#D7B5A6",   "#027b8e",  "#a2ceaa","#3896c4", "#a4a4d5", "#c85200", "#fbb04e", "#b66353", "#638b66")
colspecies =  c("#4E79A7", "#A0CBE8", "#F28E2B", "#FFBE7D", "#59A14F", "#8CD17D", "#B6992D", "#F1CE63", "#499894", "#86BCB6", "#E15759", "#FF9D9A", "#D37295", "#FABFD2", "#B07AA1", "#D4A6C8", "#9D7660", "#D7B5A6",   "#027b8e",  "#a2ceaa","#3896c4", "#a4a4d5", "#c85200", "#fbb04e", "#b66353", "#638b66", "darkblue", "darkgreen", "#d7e1ee", "#7c1158", "#79706E", "#BAB0AC")

# join ref_tax_r to the tidytree
t_tax_ref <- full_join(t_tax, ref_tax_r, by = 'label') 

# plot tree with geom_text2 for bootstraps, showing only those greater than 0.5 
ref_tree_2 = ggtree(t_tax_ref) + 
  geom_text2(aes(label=label, subset=!is.na(as.numeric(label)) & as.numeric(label) > 0.5), size=1, hjust= (-0.2), color = "deepskyblue3") +
  geom_tiplab(aes(label=Species, offset=4, color=Species), size=1, hjust=(-0.2)) + 
  scale_color_manual(values=c(colspecies)) + 
  theme(legend.position = "none") +
  geom_tiplab(aes(label=label_sp, offset=4), size=1, hjust=(-0.2))

ggsave(ref_tree_2, file = "../plots/ggtree_NEP_5_p_sp.png", 
       dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")

# plot tree with geom_text2 for bootstraps 
# color by order
ref_tree_2_order = ggtree(t_tax_ref) + 
  geom_text2(aes(label=label, subset=!is.na(as.numeric(label)) & as.numeric(label) > 0.5), size=1, hjust= (-0.2), color = "deepskyblue3") +
  geom_tiplab(aes(label=Species, offset=4, color=Order), size=1, hjust=(-0.2)) + 
  scale_color_manual(values=c(colfam)) + 
  #theme(legend.position = "none") +
  geom_tiplab(aes(label=label_sp, offset=4), size=1, hjust=(-0.2))

ggsave(ref_tree_2_order, file = "../plots/ggtree_NEP_5_p_sp_order.png", 
       dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")

# plot tree with geom_text2 for bootstraps 
# color by family
ref_tree_2_family = ggtree(t_tax_ref) + 
  geom_text2(aes(label=label, subset=!is.na(as.numeric(label)) & as.numeric(label) > 0.5), size=1, hjust= (-0.2), color = "deepskyblue3") +
  geom_tiplab(aes(label=Species, offset=4, color=Family), size=1, hjust=(-0.2)) + 
  scale_color_manual(values=c(colfam)) + 
  #theme(legend.position = "none") +
  geom_tiplab(aes(label=label_sp, offset=4), size=1, hjust=(-0.2))

ggsave(ref_tree_2_family, file = "../plots/ggtree_NEP_5_p_sp_family.png", 
       dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")
