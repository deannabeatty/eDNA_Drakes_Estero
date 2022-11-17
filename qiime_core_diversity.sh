# initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2

 # core diversity
 qiime diversity core-metrics --i-phylogeny --i-table qza/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza --p-sampling-depth 29000 --m-metadata-file clean/DE_2021_eDNA_metadata.txt --output-dir core_diversity