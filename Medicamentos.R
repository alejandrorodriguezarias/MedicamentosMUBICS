library(dplyr)
library(readxl)
library(Rcpi)
#Filtramos la base de datos para tener solo los valores referentes a IC50 y Homo Sapiens
dataset <- read_excel("dataset_Chembl_Cytokines.xlsx")
tmp <- dataset$CANONICAL_SMILES
tmp <- data.frame("smiles" = dataset$CANONICAL_SMILES, "type" = dataset$STANDARD_TYPE_UNITSj, "value" = dataset$STANDARD_VALUE, "organism" = dataset$ASSAY_ORGANISM)
tmp<- filter(tmp,tmp$type=="IC50 (nM)")
tmp<- filter(tmp,tmp$organism=="Homo sapiens")
tmp


library(rcdk)
anle138b = parse.smiles("C1OC2=C(O1)C=C(C=C2)C3=CC(=NN3)C4=CC(=CC=C4)Br")
descriptors = get.desc.names(type="all")
descriptorsvalues = eval.desc(anle138b,descriptors)
             
    
             