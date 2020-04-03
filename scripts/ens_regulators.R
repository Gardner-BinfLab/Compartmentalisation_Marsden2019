##reading in ensembl bacterial gene regulators
ens_bacterial_gene_regulators <- read.table("./data/ens_bacterial_regulators.txt")
ens_plant_fungal_regulators <- read.table("./data/ens_plant_fungal_regulators.txt")
ens_animal_regulators <- read.table("./data/ens_animal_regulators.txt")

ens_total_regulators <- rbind(ens_bacterial_gene_regulators, ens_plant_fungal_regulators,ens_animal_regulators)
ens_total_regulators <- ens_total_regulators[,c(1,4)]
colnames(ens_total_regulators) <- c("num_regs", "org_names")


regs_Check <- data.frame()
##Matching up organisms 
for(i in 1:nrow(Ensembl_final)){
  index <- grep(Ensembl_final[i,1], ens_total_regulators$org_names)
  num_regs <- ens_total_regulators[index,1]
  try(regs_Check <- rbind(regs_Check, data.frame(Ensembl_final[i,1],num_regs,Ensembl_final[i,2], Ensembl_final[i,3], Ensembl_final[i,4])))
}
colnames(regs_Check) <- c("org_name", "num_regs", "num_genes","genome_len", "type")

library(ggplot2)
ggplot(regs_Check, aes(colour=type, x=log10(num_genes), y=log(num_regs))) + 
  geom_jitter() +
  theme_bw()
##ill trim this manually
write.csv(regs_Check, "ENS_final.csv")

