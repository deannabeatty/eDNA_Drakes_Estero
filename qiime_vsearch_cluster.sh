 # initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2
 
 # vsearch de novo cluster sequences
 qiime vsearch cluster-features-de-novo --i-table qza/table_fish_2021_dada2.qza --i-sequences qza/rep_seqs_fish_2021_dada2.qza --p-perc-identity 0.97 --o-clustered-table qza/table_fish_2021_dada2_de_novo_97.qza --o-clustered-sequences qza/rep_seqs_fish_2021_dada2_de_novo_97.qza