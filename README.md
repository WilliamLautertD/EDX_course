# ML201 Final Project

**Instructions**

**Task:**
input a named vector gene expression values and predicts what call type it is. 
Optionally, provide a probability for each of the 10 possible cell types. 

**Dataset:**
To develop this function you can use the pbmc_facs$counts and pbmc_facs$samples$celltype dataset we worked on during class. You can load the dataset using this line of code after installing the fastTopics package:

*data("pbmc_facs", package = "fastTopics")*

## Final project function

The function *'predict_cell_prob* predicts the cell type of single data. It preprocesses the training data, trains either a Random Forest or kNN classifier based on the specified model ('response', 'prob', 'vote'), and predicts probabilities for the test data. The function arguments are composed by 7 obligatory arguments (train_matrix, train_label, test_matrix, test_label, model = "rf", and out = "response") and 1 optional argument with a default value of 50 (K = 50). The first two arguments, 'train_matrix' and 'train_label', input gene expression values matrix and name vector used to train the ML model. Then, the arguments 'test_matrix' and 'test_label' are input  gene expression values matrix and name vector used to test the model and predict cell types. The 'model' parameter selects for which ML methods use, either Random Forest ('rf') or k-Nearest Neighbor ('knn'), with 'rf' as default option. Then, the user can choose the final output using the 'out' variable, which either "class", "prob" or "raw" to produce the predicted class, class probabilities or the raw model scores, respectively. The K argument is used in kNN classifications and defines values of K for classification. The final output returns both the accuracy and the confusion matrix as a list. The first element is a "numeric" value showing the final accuracy of the ML model, while the second element is "confusionMatrix" class showing the final statistics related to the selected ML model.  
