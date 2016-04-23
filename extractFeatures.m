clear; clc;
numCV = 5;
allData = '..\allData_v3_requiredColumns.mat';
ipPath = '..\data\';
opPath = '..\features\';
ioFile = 'ApprovalData_';


load(allData);
c = 5
%for c = 1:numCV    
    load(strcat(ipPath,ioFile,num2str(c),'.mat')); % 'trainData','trainLabel','testData','testLabel'
    
    % (1) Column1 - ID: Just leave it
%     trainFeatures(:,1) = trainData(:,1);
%     testFeatures(:,1) = testData(:,1);
%     disp('1 done');
    
    % (2) Column3 - Take Unique Values
    uniquePlatforms = unique(allData_v3(:,3));
    for i = 1:size(trainData,1)
        trainFeatures(i,1) = find(ismember(uniquePlatforms,trainData(i,3)));
    end
    for i = 1:size(testData,1)
        testFeatures(i,1) = find(ismember(uniquePlatforms,testData(i,3)));
    end
    disp('2 done');
    
    % (3) Column6 - binary
    for i = 1:size(trainData,1)
        if(strcmp(trainData(i,6),'NULL'))
            trainFeatures(i,2) = 0;
        else
            trainFeatures(i,2) = 1;
        end
    end
    for i = 1:size(testData,1)
        if(strcmp(testData(i,6),'NULL'))
            testFeatures(i,2) = 0;
        else
            testFeatures(i,2) = 1;
        end
    end
    disp('3 done');
    
    % (4) Column7 - Date: 15 (3*7) labels
    % Sunday morning is 1, Saturday evening is 21
    load('countryTimeZone.mat');
    for i = 1:size(trainData,1)
        countryID = find(ismember(countryTimeZone(:,1),trainData(i,8)));
        actualTime = datetime(trainData(i,7)) + (datetime(datevec(countryTimeZone{countryID,2})) - datetime(1970,1,1,5,30,00));
        
        dayNumber = weekday(actualTime);
        currHour = hour(actualTime);
        if(currHour >= 12 && currHour <= 16)
            timeID = 2;
        elseif(currHour < 12)
            timeID = 1;
        elseif(currHour > 16)
            timeID = 3;
        end
        
        trainFeatures(i,3) = (dayNumber-1)*3 + timeID;
    end
    for i = 1:size(testData,1)
        countryID = find(ismember(countryTimeZone(:,1),testData(i,8)));
        actualTime = datetime(testData(i,7)) + (datetime(datevec(countryTimeZone{countryID,2})) - datetime(1970,1,1,5,30,00));
        
        dayNumber = weekday(actualTime);
        currHour = hour(actualTime);
        if(currHour >= 12 && currHour <= 16)
            timeID = 2;
        elseif(currHour < 12)
            timeID = 1;
        elseif(currHour > 16)
            timeID = 3;
        end
        
        testFeatures(i,3) = (dayNumber-1)*3 + timeID;
    end
    disp('4 done');
    
    % (5) Column2,4,5 - BOW
    [ tfFeatures, tfIDFFeatures, bagHeaders ] = extractBOW( trainData );
    trainFeatures = [trainFeatures,tfFeatures];
    clear tfFeatures tfIDFFeatures;
    disp('5 train done');
    [ tfFeatures, tfIDFFeatures ] = extractBOW_Test( testData, bagHeaders );
    testFeatures = [testFeatures,tfFeatures];
    clear tfFeatures tfIDFFeatures;
    disp('5 test done');
    
save(strcat(opPath,ioFile,num2str(c),'.mat'),'trainFeatures','trainLabel','testFeatures','testLabel','-v7.3');    
    
    
%end









