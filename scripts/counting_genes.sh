for file in ./data/*.gtf
	do
		basename $file >>./data/gtf_names.txt		
		grep protein_coding  $file | cut -f 3 | grep -c gene >>./data/gene_counts.txt

done
		
paste gtf_names.txt gene_counts.txt >./data/ensembl_gene_counts_bacterial.txt
