function [ output_args ] = splitCV( input_args )
%SPLITCV Splits data into 5 random subsamples 

featurePath = '..\allData_v3_requiredColumns.mat'; %combinedFeatures; file with all the features
destPath = strcat('..\data\ApprovalData_');

load(featurePath);  %combinedFeatures
grpNum = 6;
numCV = 5;
trainRatio = 0.5;

posClassData = (find(labels_v3(:,grpNum)>0));
negClassData = (find(labels_v3(:,grpNum)==0));
trainLength = round(length(posClassData)*trainRatio);
for i=1:numCV   
    ids = ceil(rand([trainLength 1]).*length(posClassData));
    flag = 1;
    while(flag)
        if(length(unique(ids)) >= trainLength)
            flag = 0;
        else
            tempIds = ceil(rand([trainLength 1]).*length(posClassData));
            ids = [ids;tempIds];            
        end            
    end    
    uIds = unique(ids);
    ids = uIds(1:trainLength);
    posTrainIds = posClassData(ids);
    posTestIds = posClassData(~ismember([1:length(posClassData)],ids));
    
    ids = ceil(rand([trainLength 1]).*length(negClassData));    
    flag = 1;
    while(flag)
        if(length(unique(ids)) >= trainLength)
            flag = 0;
        else
            tempIds = ceil(rand([trainLength 1]).*length(negClassData));
            ids = [ids;tempIds];
        end
    end
    uIds = unique(ids);
    ids = uIds(1:trainLength);
    negTrainIds = negClassData(ids);
    negTestIds = negClassData(~ismember([1:length(negClassData)],ids));
    
    
    trainData = allData_v3(posTrainIds,:);
    trainData(end+1:end+length(negTrainIds),:) = allData_v3(negTrainIds,:);
    trainLabel = ones(length(posTrainIds),1);
    trainLabel(end+1:end+length(negTrainIds),1) = 0;
    
    testData = allData_v3(posTestIds,:);
    testData(end+1:end+length(negTestIds),:) = allData_v3(negTestIds,:);
    testLabel = ones(length(posTestIds),1);
    testLabel(end+1:end+length(negTestIds),1) = 0;
    
    save(strcat(destPath,num2str(i),'.mat'),'trainData','trainLabel','testData','testLabel','-v7.3');
    disp(strcat('Cross Validation ',num2str(i),' written.'));
    
end

end

