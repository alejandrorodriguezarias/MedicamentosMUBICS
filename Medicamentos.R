library(dplyr)
library(readxl)
library(Rcpi)
dataset <- read_excel("dataset_Chembl_Cytokines.xlsx")
tmp <- dataset$CANONICAL_SMILES
tmp <- data.frame("smiles" = dataset$CANONICAL_SMILES, "type" = dataset$STANDARD_TYPE_UNITSj, "value" = dataset$STANDARD_VALUE, "organism" = dataset$ASSAY_ORGANISM)
tmp<- filter(tmp,tmp$type=="IC50 (nM)")
tmp<- filter(tmp,tmp$organism=="Homo sapiens")
tmp

x <- readMolFromSDF("C:/Users/Alex/Desktop/master/prueba.sdf")
extractDrugALOGP(x.mol)
#View(dataset_Chembl_Cytokines)
tmp[4]
install.packages("xlsx")
library(xlsx)
write.xlsx(tmp$smiles, "C:/Users/Alex/Desktop/master/smiles.xlsx")

extractDrugALOGP(x)
extractDrugAIO(x)

library(ChemmineOB)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ChemmineR")

library(ChemmineR)

n <-smiles2sdf(as.character(tmp[1,1,1]))
y <- convertFormat("SMI","SDF",tmp[1,1,1])

extractDrugALOGP(n[1])
extractDrugAIO(n)

sdfset <- read.SDFset("C:/Users/Alex/Desktop/master/prueba.sdf") 

conn <- initDb("test.db")
ids<-loadSdf(conn, sdfset, function(sdfset) data.frame(rings(sdfset,type="count",upper=6, arom=TRUE))
             