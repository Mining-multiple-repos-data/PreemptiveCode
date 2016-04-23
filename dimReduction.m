
ipPath = '..\features\ApprovalData_'; %Path to input data that is, original data file for every information need here for instance, Approval
opPath = '..\featuresReduced\ApprovalData_'; %Path to output data where reduced features are stored for every information need here for instance, Approval

for i = 1:5 %i corresponds to train split, we have 5 cross validatation hence i ranges from 1 to 5

    disp(i);
    load(strcat(ipPath,num2str(i),'.mat'));
    
    trainActual = trainFeatures(:,1:3); % 1 to 3 are binary or categorical features, not considered as bag of words
    testActual = testFeatures(:,1:3);
    bowFeaturesTrain = trainFeatures(:,4:end); % Fields from 4th till end are respresented as bag of words. They correspond to field description, software name and software version  
    bowFeaturesTest = testFeatures(:,4:end);
    
    bowFeaturesTrain=double(bowFeaturesTrain);
    [V score d]=princomp(bowFeaturesTrain);
    topK=find(cumsum(d)/sum(d)>0.95,1);
    hcaV=V(:,1:topK);
    trainMean=mean(bowFeaturesTrain);
    
    normTrain=bowFeaturesTrain-repmat(trainMean,size(bowFeaturesTrain,1),1);
    normTest=bowFeaturesTest-repmat(trainMean,size(bowFeaturesTest,1),1);
    newTrainFeatures=bowFeaturesTrain*hcaV;
    newTestFeatures=bowFeaturesTest*hcaV;
    
    clear trainFeatures testFeatures;
    
    trainFeatures = [trainActual,newTrainFeatures];
    testFeatures = [testActual,newTestFeatures];

    save(strcat(opPath,num2str(i),'.mat'),'trainFeatures','trainLabel','testFeatures','testLabel','-v7.3');
    clear trainActual testActual bowFeaturesTrain bowFeaturesTest trainFeatures testFeatures trainLabel testLabel V score d hcaV topK trainMean normTrain normTest newTrainFeatures newTestFeatures;
end