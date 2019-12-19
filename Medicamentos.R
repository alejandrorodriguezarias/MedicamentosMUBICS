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
#eliminamos las columnas con marcadores nulos
vectorDescriptores <- Filter(function(x)!all(is.na(x)),vectorDescriptores)
#utilizamos la mediana como umbra para definir las clases IC50LOW e IC50HIGH
tmp <- ifelse(medicamentos$value > median(medicamentos$value), 1, 0)
vectorDescriptores$class <- tmp[1:2031]
vectorDescriptores$class


