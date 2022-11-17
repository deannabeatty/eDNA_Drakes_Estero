# initialize conda
 conda init

# activate qiime2
 source activate qiime2-2020.2

 # dada2 to remove erroneous sequences 
 qiime dada2 denoise-paired --i-demultiplexed-seqs qza/import_trimmed.qza --p-trunc-len-f 200 --p-trunc-len-r 200 --o-representative-sequences qza/rep_seqs_fish_2021_dada2.qza --o-table qza/table_fish_2021_dada2.qza --o-denoising-stats qza/stats_fish_2021_dada2.qza

 # export to seqs to fasta
 qiime tools export --input-path qza/rep_seqs_fish_2021_dada2.qza --output-path qza/rep_seqs_fish_2021_dada2.fasta
