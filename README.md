# PreemptiveCode
Code for designed preemptive model.
- Source to download libsvm: https://www.csie.ntu.edu.tw/~cjlin/libsvm/
- Source to download RDF implementation: http://cda.psych.uiuc.edu/statistical_learning_course/Windows-Precompiled-RF_MexStandalone-v0.02-/
- 1. splitCV : Split complete data file to train and test for 5 random cross validation 
- 2. extractFeatures : Extract features for the given input files, calls countryTimeZone, extractBOW and extractBOW_Test
- 3. dimReduction : Reduces dimension of train data to handle data sparsity
- 4. shuffleData : Shuffle data in each split to avoid classifier bias
- 5. classifier : Apply different classifier, make use of libsvm, rdf and evaluateAlgo
- In the code, we have illustrated for "Approval" information need preemption.
