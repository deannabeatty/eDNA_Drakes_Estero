# initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2

 # classify sequences with mitohelper reference database (10.5281/zenodo.6336244)
 # blast classify sequences 0.99
 qiime feature-classifier classify-consensus-blast --i-query qza/rep_seqs_fish_2021_dada2_de_novo_97.qza --i-reference-reads 12S-16S-18S-seqs.qza --i-reference-taxonomy 12S-16S-18S-tax.qza --o-classification qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_99.qza --p-perc-identity 0.99 --p-evalue 0.00001
 # blast classify sequences 0.97
 qiime feature-classifier classify-consensus-blast --i-query qza/rep_seqs_fish_2021_dada2_de_novo_97.qza --i-reference-reads 12S-16S-18S-seqs.qza --i-reference-taxonomy 12S-16S-18S-tax.qza --o-classification qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_97.qza --p-perc-identity 0.97 --p-evalue 0.00001 
 # blast classify sequences 0.95
 qiime feature-classifier classify-consensus-blast --i-query qza/rep_seqs_fish_2021_dada2_de_novo_97.qza --i-reference-reads 12S-16S-18S-seqs.qza --i-reference-taxonomy 12S-16S-18S-tax.qza --o-classification qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_95.qza --p-perc-identity 0.95 --p-evalue 0.00001
 # blast classify sequences 0.90
 qiime feature-classifier classify-consensus-blast --i-query qza/rep_seqs_fish_2021_dada2_de_novo_97.qza --i-reference-reads 12S-16S-18S-seqs.qza --i-reference-taxonomy 12S-16S-18S-tax.qza --o-classification qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_90.qza --p-perc-identity 0.90 --p-evalue 0.00001
 # blast classify sequences 0.80
 qiime feature-classifier classify-consensus-blast --i-query qza/rep_seqs_fish_2021_dada2_de_novo_97.qza --i-reference-reads 12S-16S-18S-seqs.qza --i-reference-taxonomy 12S-16S-18S-tax.qza --o-classification qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_80.qza --p-perc-identity 0.80 --p-evalue 0.00001

 # remove sequences that remain unassigned at 0.80 similarity
 qiime taxa filter-seqs --i-sequences qza/rep_seqs_fish_2021_dada2_de_novo_97.qza --i-taxonomy qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_80.qza --p-exclude Unassigned --o-filtered-sequences qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80.qza 
 # remove sequences from the count table that remained unassigned at 0.80 similarity
 qiime taxa filter-table --i-table qza/table_fish_2021_dada2_de_novo_97.qza --i-taxonomy qza/rep_seqs_fish_2021_dada2_de_novo_97_mitofish_blast_taxonomy_12S_16S_18S_80.qza --p-exclude Unassigned --o-filtered-table qza/table_fish_2021_dada2_de_novo_97_unassigned_80_removed.qza
 # export sequences as fasta
 qiime tools export --input-path qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80.qza --output-path qza/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80.fasta
