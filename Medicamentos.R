library(dplyr)
library(readxl)
library(Rcpi)
#Filtramos la base de datos para tener solo los valores referentes a IC50 y Homo Sapiens
dataset <- read_excel("dataset_Chembl_Cytokines.xlsx")
medicamentos <- dataset$CANONICAL_SMILES
medicamentos <- data.frame("smiles" = dataset$CANONICAL_SMILES, "type" = dataset$STANDARD_TYPE_UNITSj, "value" = dataset$STANDARD_VALUE, "organism" = dataset$ASSAY_ORGANISM)
medicamentos<- filter(medicamentos,medicamentos$type=="IC50 (nM)")
medicamentos<- filter(medicamentos,medicamentos$organism=="Homo sapiens")
medicamentos

#obtenemos los smiles
smiles <- medicamentos$smiles
vectorDescriptores <- data.frame()
library(rcdk)
for(i in 1:length(smiles)) {
  anle138b = parse.smiles(as.vector(smiles[i]))
  descriptors = get.desc.names(type="all")
  descriptorsvalues = eval.desc(anle138b,descriptors)
  descriptorsvalues
  vectorDescriptores <- rbind(vectorDescriptores,descriptorsvalues)
}
    
             