function [ output_args ] = shuffleData( input_args )
%SHUFFLEDATA Shuffles the data to eliminate classifier bias

clear; clc;
rootDataFile = '..\featuresReduced\ApprovalData_'; %Path to reduced features file. for instance here, Approval data
numCV = 5;

for i = 1:numCV
    disp(i);
   load(strcat(rootDataFile,num2str(i),'.mat'));
    
    shuffleIdx = randperm(size(trainFeatures,1));
    feats = trainFeatures(shuffleIdx,:);
    labels = trainLabel(shuffleIdx);
    
    clear trainFeatures trainLabel;
    trainFeatures = feats;
    trainLabel = labels;
    
    save(strcat(rootDataFile,num2str(i),'.mat'),'trainFeatures','trainLabel','testFeatures','testLabel','-v7.3');
    clear trainFeatures trainLabel testFeatures testLabel;
    
end

end

