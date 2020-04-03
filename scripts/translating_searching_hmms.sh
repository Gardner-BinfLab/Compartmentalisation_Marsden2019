mkdir annotations 
name=$(basename $1)
translate -q $1 >annotations/$name\_translated
hmmsearch --cut_ga --domtblout $name\_translated_pfam32.domtblout pfam_dna_binding_hmms ./annotations/$name\_translated >annotations/$name\_translated_pfam32.hmmsearch



