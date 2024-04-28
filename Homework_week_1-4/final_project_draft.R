---
  title: "Final Project - ML201"
author: "William Lautert"
date: '2024-04-27'
output:
  pdf_document: default
html_document: default
---
  
  ### Load library
  
```{r Library, include=FALSE}
library(dslabs)
library(parallel)
library(doParallel)
library(foreach)
library(caret)
library(matrixStats)
library(umap)
library(randomForest)
library(MASS)
library(fastTopics)
```

### Setup computer cores and parallel
```{r setup, include=FALSE}

nc <- detectCores()  - 1
cl <- makeCluster(nc)
registerDoParallel(cl)

```


1.  Data processing:
  -   Load the dataset using the provided code.

```{r}
set.seed(2024-04-27)
data("pbmc_facs", package = "fastTopics")

#training set
x <- as.matrix(pbmc_facs$counts)
y <- pbmc_facs$samples$celltype

#test set
x_test <- as.matrix(pbmc_facs$counts_test)
y_test <- pbmc_facs$samples_test$celltype



#Summary of each dataset
print("Dimension of 'Train matrix' (x):") 
dim(x)
paste("Length of 'Y categories' (y): ", length(y))

print("Dimension of 'Test matrix' (x):")
dim(x_test)

paste("Length of 'Test Y categories' (y): ", length(y_test))

```

```{r}
set.seed(2024-04-27)

cpm <- log2(x/rowSums(x)*10^6 + 1)

pre_process <- preProcess(cpm, method = c("pca","nzv"), verbose = T, pcaComp = 100)

#Train models

#kNN
K <- 50

#Tunning Values
k_values <- data.frame(k = seq(3, K, 2))
control <- trainControl(method = "cv", number = 20, p = .9, allowParallel = TRUE)

train_knn_pca <- train(predict(pre_process, cpm), y = y, method = "knn",
                       tuneGrid = k_values,
                       trControl = control)

y_hat_knn <- predict(train_knn_pca, newdata = predict(pre_process, log2(x_test/rowSums(x_test)*10^6 + 1)))

fit_rf <- train(predict(pre_process, cpm), y = y, method = "rf",
                tuneGrid = data.frame(mtry = seq(5, 30, 3)),
                trControl = trainControl("cv", number = 10, p = 0.9))

plot(fit_rf)

fit_rf <- randomForest(predict(pre_process, cpm), y, mtry = fit_rf$bestTune$mtry)

y_hat <- predict(fit_rf, newdata = predict(pre_process, log2(x_test/rowSums(x_test)*10^6 + 1)),
                 type = "prob")

confusionMatrix(y_hat, factor(y_test))$overall["Accuracy"]


```