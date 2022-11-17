# initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2

# filter reference database (10.5281/zenodo.6336244) by accessions (5 per spp.) from the NEP species list
 qiime feature-table filter-seqs --i-data 12S-seqs-derep-uniq.qza --m-metadata-file mitohelper_reference/comparing_records/accessions-Feature-ID.txt --o-filtered-data 12S-seqs-derep-uniq_NEP_5_max_p_sp.qza

 conda deactivate

# activate qiime2 2022.2 for use of rescript 
 source activate qiime2-2022.2

# filter reference taxonomy table (10.5281/zenodo.6336244) by accessions (5 per spp.) from the NEP species list
qiime rescript filter-taxa --i-taxonomy 12S-tax-derep-uniq.qza --m-ids-to-keep-file mitohelper_reference/comparing_records/accessions-Feature-ID.txt --o-filtered-taxonomy 12S-tax-derep-uniq_NEP_5_max_p_sp.qza

conda deactivate

# activate qiime2
 source activate qiime2-2020.2

# merge filtered reference sequences with our clustered eDNA sequences
 qiime feature-table merge-seqs --i-data 12S-seqs-derep-uniq_NEP_5_max_p_sp.qza qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80.qza --o-merged-data qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp.qza

# mafft alignment
 qiime alignment mafft --i-sequences qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp.qza --o-alignment qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment.qza

# mask noisy positions
 qiime alignment mask --i-alignment qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment.qza --o-masked-alignment qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment_masked.qza
 
 # fasttree
 qiime phylogeny fasttree --i-alignment qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment_masked.qza --o-tree qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment_masked_unrooted_tree.qza

 # midpoint root
 qiime phylogeny midpoint-root --i-tree qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment_masked_unrooted_tree.qza --o-rooted-tree qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment_masked_rooted_tree.qza

# export qza as nwk
 qiime tools export --input-path qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_12S-seqs-derep-uniq_NEP_5_max_p_sp_alignment_masked_rooted_tree.qza --output-path qza/tree/