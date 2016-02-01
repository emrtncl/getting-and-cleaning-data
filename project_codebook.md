# Codebook for the Getting and Cleaning Data Course Project
## This document will list steps taken to get the data into the final clean format

1. Original data downloaded from the coursera website. Two sets of data labeled with "_train" and "_test" were imported into R.
2. Each set contain 3 components: "X", "y" and "subject". "X" component contains data regarding the features listed in "features.txt", "y" contains activity types a vector of integers from 1 to 6 and subject contains a numeric identifier for the subjects that participated in this study. 
3. From the features vector (a character vector with length 561) indices of all the features that contained "mean()" and "std()" were extracted. Column indices were used to extract appropriate columns from the combined "X_train" and "X_test". The number of variables for both "mean_data" and "std_data" dataframes ended up being 33. The other features were ignored. 
4. For the "mean_data" and "std_data" dataframes column names were assigned with appropriate column names. From there aggregate() function (stats package) was used to group the data by subject and activity and compute the mean (argument FUN = mean) for the groupings. Same logic was followed for the standard deviation computation with the exception that standard deviation was computed for each grouping (argument FUN = sd). There are 30 subjects and 6 activity types resulting in 180 resulting computations for both mean and standard deviation. 
5. Two seperate dataframes were combined to get the final clean data.      
