file=dna_binding_hmms
while IFS= read  line
	do
		echo $line
		grep $line Pfam-A.hmm | cut -f 4 -d " " >>dna_binding_hmm_accesions
done <"$file"		
