# Practical-Machine-Learning
## Weight Lifting Exercises Dataset:
Participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: exactly according to the specification (Class A), throwing the elbows to the front (Class B), lifting the dumbbell only halfway (Class C), lowering the dumbbell only halfway (Class D) and throwing the hips to the front (Class E). Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes. 
The data for this project come from this source: http://web.archive.org/web/20161224072740/http:/groupware.les.inf.puc-rio.br/har. 

![alt text](http://web.archive.org/web/20161025043219im_/http://groupware.les.inf.puc-rio.br/static/WLE/on-body-sensing-schema.png)


### Purpose: 
The goal of your project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set.
### Language: 
R (caret)
### Approach:
Decision trees, ranndom forest, generalized boosted regression
### Learning outcome:
- Decision Trees (87.9% accuracy), Random Forest (99.9% accuracy), Generalized Boosted Regression (99.6% accuracy)
- Random Forest is the most accurate algorithm for the dataset among the applied three algorithm
