for file in ./data/*37.gff3
	do	
		basename $file >>./data/org_names.txt
		grep sequence-region $file | cut -f 6 -d " " | paste -sd+ | bc >>./data/genome_lengths.txt
done
paste ./data/org_names.txt ./data/genome_lengths.txt >ensembl_bacterial_lengths.txt