# SAS Capstone

Code and processing diagrams from my SAS capstone project for completing the M.S. in Data Analytics  
The project uses SAS Enterprise Miner and SAS Studio to compare supervised machine learning algorithms that predict customer churn  
  
## SEMMA  

The [SEMMA](http://support.sas.com/documentation/cdl/en/emcs/66392/HTML/default/viewer.htm#n0pejm83csbja4n1xueveo2uoujy.htm) (Sample, Explore, Modify, Model, Assess) methodology from SAS was used for analysis.  
Each step in the methodology corresponds with a group of processing nodes in SAS Enterprise Miner.

## Processing Diagrams  

Processing diagrams are used in SAS Enterprise Miner to produce results from input data  

## Processing Diagram: Data Exploration

First, a processing diagram was created to explore the data:  
Explore Diagram: [Explore](https://github.com/jarhoads/SASCapstone/blob/master/process/Churn%20Data%20Exploration.xml)  
![ExploreProcessingDiagram](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/explore.jpg)  
This produces statistical information on variable importance and distributions that can be helpful in feature selection.  

## Processing Diagram: Data Transformation and Model Development  

A processing diagram is used to prepare the data for modeling, implement machine learning algorithms, and assess the results.  
Data Preparation and Modeling Diagram: [Churn Data Modeling](https://github.com/jarhoads/SASCapstone/blob/master/process/Churn%20Data%20Modeling.xml)  
![OverallProcessingDiagram](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/process.JPG)  

## SAS Code: Creating a Table for Cumulative Lift and Percentage of Captured Responses  

SAS Enterprise Miner provides a lot of useful features, but sometimes it needs to be extended with SAS code.  
In this case, I needed a table to show the cumulative lift and percentage of captured responses (correctly classified records).
The cumulative lift and percentage of captured responses were used as the primary selection criteria for the machine learning classifiers.  
SAS Studio was used as an IDE to write the code and run it.  

SAS Code: [ModelCompare](https://github.com/jarhoads/SASCapstone/blob/master/SAS%20code/ModelCompare.sas)  
This code creates a table with the cumulative lift and percentage of captured responses for the training and validation data.  
![LiftTable](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/lifttable.jpg)  

For more on cumulative lift, percentage of captured responses, and machine learning classification:  

* [Lift](http://www2.cs.uregina.ca/~dbd/cs831/notes/lift_chart/lift_chart.html)  
* [Cumulative Lift and Percentage of Captured Responses - Teradata Documentation](https://docs.teradata.com/reader/ZsliwWktT_ddgidLvXg~6A/KTIqC7PzJRfuyVXOQIXk9g)  
* [Machine Learning Classification](https://towardsdatascience.com/supervised-machine-learning-classification-5e685fe18a6d)  

## SAS Code: Confusion/Classification Matrix for Test Data  

A SAS code node is used to create a classification (confusion) table with frequency results from test data.  
This is needed because the holdout test data (for comparing models) is scored but not included in the Model Comparison node results.  

The scored test data results are stored in the macro variable `&em_import_test`  
![TestScore](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/testscore.JPG)  

The variables `F_Churn` and `I_Churn` contain the actual predicted value of the churn variable  
![ChurnVariables](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/churnvars.JPG)  

These variables can be used with `PROC FREQ` to created a frequency table for the scored test data  
```sas
proc freq
data=&em_import_test;
    tables F_Churn*I_Churn;
run;
```  

This results in a frequency table that can be used to evaluate and compare test data results with those of training and validation data.  
![FrequencyTable](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/freqtable.jpg)  

## Model Evaluation and Selection  

The final models were evaluated for overfitting using both ROC Index (AUC) and overall accuracy (frequency table).  

The ROC curves show the decision tree has a deteriorating ROC curve through validation and test data (most likely due to overfitting)  
![ROCCurves](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/ROC.jpg)  

Overall accuracy was best for logistic regression (78.92% accuracy)  
![OverallAccuracy](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/accuracy.jpg)

Model selection was based on performance in cumulative lift and percentage of captured reposnses.  
As a business application it's more important for the model to perform well at finding the top 20% of customers likely to churn (leave).  
In this case, the neural network performed best for cumulative lift and percentage of captured responses through the second decile.  
![RankOrderAccuracy](https://raw.githubusercontent.com/jarhoads/SASCapstone/master/docs/testlift.jpg)  

For more on the machine learning methods used and business applications of customer churn:  

* [Logistic Regression](https://en.wikipedia.org/wiki/Logistic_regression)  
* [Decision Tree](https://en.wikipedia.org/wiki/Decision_tree_learning)  
* [Neural Network](https://en.wikipedia.org/wiki/Neural_network)  
* [Gradient Boosting](https://en.wikipedia.org/wiki/Gradient_boosting)  
* [Ensemble](https://en.wikipedia.org/wiki/Ensemble_learning)  
* [Customer Churn](https://hbr.org/2014/10/the-value-of-keeping-the-right-customers)  
* [AI and Customer Churn](https://towardsdatascience.com/how-to-leverage-ai-to-predict-and-prevent-customer-churn-f84d653a76fb)  
* [Customer Churn and Business](https://www.datascience.com/blog/what-is-a-churn-analysis-and-why-is-it-valuable-for-business)  
* [Current Research on Customer Churn and Retention](https://www.hbs.edu/faculty/Pages/item.aspx?num=53571)  
