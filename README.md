# Machine Learning with Caret

## Installation
Install these packages first:
1. caret (Wrapper for various ML algorithms)
2. tidyverse (meta package)
3. ranger (for running Random Forest method)

## Acknowledgement
Acknowledging the efforts of Max Kuhn and Hadley Wickham, without who, the world of ML and data science in R wouldn't be the way it is now.
1. Check out Max Kuhn's tutorial of Caret ([The caret Package](https://topepo.github.io/caret/index.html))
2. Check out Hadley's book on R for Data Science. ([R4DS](https://r4ds.had.co.nz))

## Steps involved when using Caret
There are three major approaches to using Caret:
1. Split the data into train and test datasets. Ideally, a split of 80-20 or 75-25 is good enough. But, if there is a class imbalance, there is another workflow to split the data. Read Max's tutorial to find out more.
2. If there are NA values in the datasets, impute the datasets. For categorical values, it may be goo idea to impute the missing values with the mode of the values. For numeric values, there are a few options- median imputation, knn imputation, etc. Read Max's tutorial more for more details.
3. After imputation, it is a good idea to encode your categorical values to 1 and 0. This is because most models expect the datasets in a numerical format. Again, refer to Max's tutorials for more details.
4. After encoding, depending on your dataset, normalize the data. There are many normailization options. See the code comments for more information.
5. Repeat these preprocessing steps for both the train and test datasets.
6. Run the model for the train data.
7. Validate the model against the test data.
8. Calculate the accuracy of the model.
9. Iterate the steps again for another model and you may perform cross validation.
10. Pick the mode with the best accuracy and peformance.
