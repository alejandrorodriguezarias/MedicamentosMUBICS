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
vectorDescriptores <- vectorDescriptores[complete.cases(vectorDescriptores),]
#utilizamos la mediana como umbra para definir las clases IC50LOW e IC50HIGH
tmp <- ifelse(medicamentos$value > median(medicamentos$value), 1, 0)
vectorDescriptores$class <- tmp[1:2031]
vectorDescriptores$class <- NULL
vectorDescriptores
#version cutre de división de grupos
nEntrenamiento = round(0.8 * nrow(vectorDescriptores))
entrenamiento<-sample(1:nrow(vectorDescriptores),nEntrenamiento)
conjunto_entrenamiento<-vectorDescriptores[entrenamiento,]
conjunto_test<-vectorDescriptores[-entrenamiento,]
y = tmp[entrenamiento]
library(class)
predicho <- knn(conjunto_entrenamiento,conjunto_test,cl=factor(y),k=5, l=0, prob=FALSE, use.all=TRUE)
vectorDescriptores$class <- tmp[1:2029]
probando <- vectorDescriptores[-entrenamiento,]




#Random Forest

library(randomForest)
train_rows <- sample(nrow(vectorDescriptores), 0.8 * nrow(vectorDescriptores), replace = FALSE)
train_set <- vectorDescriptores[train_rows, ]
test_set <- vectorDescriptores[-train_rows, ]

vectorDescriptores$CanonicalSmiles <- NULL
tmp <- ifelse(medicamentos$value > median(medicamentos$value), 0, 1)
vectorDescriptores$class <- as.factor(tmp[1:3559]) 

#Random Forest para ver las variables importantes
model_var_importantes <- randomForest(class ~ . , data = train_set, mtry = 100, importance=TRUE)
varImpPlot(model_var_importantes)

#Random Forest de todas las variables
model <- randomForest(class ~ . , data = train_set, mtry = 100)

test_set_predictions <- predict(model, test_set, type = "class")
caret::confusionMatrix(test_set_predictions, test_set$class)


#Random Forest eligiendo algunas variables importantes
model <- randomForest(class ~ MDEN.22+MDEC.23+ECCEN+BCUTp.1h+BCUTc.1h+BCUTc.1l+WTPT.1+WTPT.4+WTPT.5+SPC.5+VP.5 , 
                      data = train_set, mtry = 3)


test_set_predictions <- predict(model, test_set, type = "class")
caret::confusionMatrix(test_set_predictions, test_set$class)




#KNN (casi la misma versión que la otra knn pero aquí se escalan los valores)

library(class)
set.seed(222)
scaled_descriptors <- vectorDescriptores %>% mutate_if(is.numeric, .funs=scale)
labels <- scaled_descriptors$class
scaled_descriptors$class <- NULL
scaled_descriptors <- Filter(function(x)!all(is.na(x)),scaled_descriptors)
scaled_descriptors <- scaled_descriptors[complete.cases(scaled_descriptors),]


train_rows <- sample(nrow(scaled_descriptors), 0.8 * nrow(scaled_descriptors), replace = FALSE)
train_set <- scaled_descriptors[train_rows, ]
test_set <- scaled_descriptors[-train_rows, ]
train_labels <- labels[train_rows]
test_set_labels <- labels[-train_rows]


test_set_predictions <- knn(train = train_set, test = test_set, 
                            cl= train_labels, k = 20)

caret::confusionMatrix(table(test_set_predictions, test_set_labels))

