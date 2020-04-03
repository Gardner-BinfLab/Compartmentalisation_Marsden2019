# Generating genome lengths, gene counts and number of regulators for the Compartmentalisation Marsden 2019 proposal 
As organisms increase in size, they also increase in complexity. Does having an increased number of cellular compartments help with keeping genes apart? 

# Downloading data

Ensembl and Ensembl genomes FTP sites were downloaded and used
```bash
nohup wget -r --no-parent $site &
```
sites: 
ftp://ftp.ensemblgenomes.org/pub/release-43/bacteria/gtf/bacteria_0_collection/

ftp://ftp.ensemblgenomes.org/pub/release-43/fungi/gtf/

ftp://ftp.ensemblgenomes.org/pub/release-43/plants/gtf/

ftp://ftp.ensembl.org/pub/release-96/gtf/

ftp://ftp.ensemblgenomes.org/pub/release-43/bacteria/gff/bacteria_0_collection/

ftp://ftp.ensemblgenomes.org/pub/release-43/fungi/gff/

ftp://ftp.ensemblgenomes.org/pub/release-43/plants/gff/

ftp://ftp.ensembl.org/pub/release-96/gff/

ftp://ensemblgenomes.org/pub/release-43/bacteria/fasta/bacteria_0_collection/

ftp://ensemblgenomes.org/pub/release-43/plants/fasta/  

ftp://ensemblgenomes.org/pub/release-43/fungi/fasta/ 

ftp://ftp.ensembl.org/pub/release-96/fasta/


# Getting gene number and genome length
Counts the number of genes in a .gtf file
```bash
counting_genes.sh 
```

creates a file containing the organism name and the genome length
```bash
get_genome_length.sh 
```

# Predicting number of regulatory genes in each organism 
pfam2go retrieved from: 

http://current.geneontology.org/ontology/external2go/pfam2go 

Get the families of HMMs that are DNA binding
```bash
grep "DNA binding" pfam2go.txt | cut -f 1 -d " " | cut -f 2 -d ":" >dna_binding_hmms
```
Gets every accession in that family from Pfam
```bash
./retrieving_hmms.sh
```

Get the full HMMs

ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz

then run 
```bash
hmmpress Pfam-A.hmm
```

Gets the HMMs of those accessions
```bash
hmmfetch -f Pfam-A.hmm dna_binding_hmm_accesions >pfam_dna_binding_hmms
```

Translates the FASTA files into proteins and tries to find those

```bash
ls ./ens_bacterial_fa/* | parallel -j20 ./translating_searching_hmms.sh
```

This one liner turns the results into a gff 
```bash
for file in *.domtblout ; do cat $file | perl -lane 'if(/nt\s+(\d+)\.\.(\d+)/){($f,$t)=($1,$2); if($f<$t){$str="+"; $fDNA=$f+$F[17]*3-3; $tDNA=$f+$F[18]*3-3;}else{$str="-"; ($fDNA,$tDNA)=($f-3*$F[18]+1,$f-3*$F[17]+3); }  print "$file\thmmsearch\tpolypeptide_domain\t$fDNA\t$tDNA\t$F[7]\t$str\t.\tE-value=$F[6];ID=$F[3];ACC=$F[4];hmm-st=$F[15];hmm-en=$F[16];"; }' | sort -k4n > $file\.gff; done
```

This returns number of predicted regulatory genes in the .gff file 
```bash
wc *.gff >ens_bacterial_regulators.txt	
```


ens_regulators.R cleans up the final document 

ENS_final is the final file
