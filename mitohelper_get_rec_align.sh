# initialize conda
 conda init

# activate mitohelper environment 
 source activate mitohelper

# these scripts can be called from within the mitohelper repository cloned from https://github.com/aomlomics/mitohelper 
# get records (accessions) from the reference database for NEP species
python mitohelper.py getrecord --input_file ../eDNA_Drakes_Estero/mitohelper_reference/WOS_search_spp_lists/all_estuaries_spp_list.csv --output_prefix ../eDNA_Drakes_Estero/mitohelper_reference/get_record/12S_tax_seq_derep_uniq_Mar2022/all_estuaries_genus_species_12S_tax_seq_derep_uniq_Mar2022 --database_file ../eDNA_Drakes_Estero/mitohelper_reference/12S_tax_seq_derep_uniq_Mar2022_for_mitohelper_exact.tsv --tax_level 7 --taxout --fasta

# get alignment of NEP species records to D. rerio reference sequence provided by mitohelper repository
python mitohelper.py getalignment -i ../eDNA_Drakes_Estero/mitohelper_reference/get_record/12S_tax_seq_derep_uniq_Mar2022/all_estuaries_genus_species_12S_tax_seq_derep_uniq_Mar2022_L7.fasta -o ../eDNA_Drakes_Estero/mitohelper_reference/get_alignment/12S_tax_seq_derep_uniq_Mar2022/all_estuaries_genus_species_12S_tax_seq_derep_uniq_Mar2022_L7_alignment -r testdata/Zebrafish.12S.ref.fasta --blastn-task blastn

# get alignment of our eDNA sequences to D. rerio reference sequence provided by mitohelper repository
python mitohelper.py getalignment -i ../eDNA_Drakes_Estero/qza_files/rep_seqs_fish_2021_dada2.fasta/dna-sequences.fasta  -o ../eDNA_Drakes_Estero/mitohelper_reference/get_alignment/rep_seqs_fish_2021_dada2_alignment -r testdata/Zebrafish.12S.ref.fasta --blastn-task blastn

# get alignment of our eDNA sequences (after removing seqs with < 0.80 similarity to the reference database) to D. rerio reference sequence provided by mitohelper repository
python mitohelper.py getalignment -i ../eDNA_Drakes_Estero/qza_files/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80.fasta/dna-sequences.fasta -o ../eDNA_Drakes_Estero/mitohelper_reference/get_alignment/rep_seqs_fish_2021_dada2_de_novo_97_remove_unassigned_80_alignment -r testdata/Zebrafish.12S.ref.fasta --blastn-task blastn