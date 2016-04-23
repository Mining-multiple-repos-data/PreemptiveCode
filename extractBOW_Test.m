function [ tfFeatures, tfIDFFeatures ] = extractBOW_Test( trainData, bagHeaders )
%EXTRACTBOW_TEST Summary of this function goes here
%   Detailed explanation goes here


%% Loading files

stopWords = importdata('D:\Anush\ccd\bpCCD\stopWords.txt');
stopWords = lower(stopWords);
addpath(genpath('D:\Anush\ccd\bpCCD\newCode\MatlabNLP-master\'));

%% Sanitizing Keywords

for i = 1:size(trainData,1)
    if(strcmpi(trainData{i,2},'Any'))
        trainData{i,2} = 'versionAny';
    elseif(strcmpi(trainData{i,2},'Direct'))
        trainData{i,2} = 'versionDirect';
    elseif(strcmpi(trainData{i,2},'Latest'))
        trainData{i,2} = 'versionLatest';
    elseif(strcmpi(trainData{i,2},'None'))
        trainData{i,2} = 'versionNone';
    end
    
    if(strcmpi(trainData{i,4},'None'))
        trainData{i,4} = 'swNone';
    elseif(strcmpi(trainData{i,4},'Direct'))
        trainData{i,4} = 'swDirect';
    end
end

%% Creating the text

for i = 1:size(trainData,1)
    disp(i);
    str1 = strcat(num2str(trainData{i,2}),', ',trainData{i,4},', ',trainData{i,5});
    split1 = regexp(str1,'[^a-zA-Z0-9.]','Split');
    split1 = split1(~cellfun('isempty',split1));
    sanityStr1 = lower(split1);
    
    cnt = 1;
    for j = 1:length(sanityStr1)
        %disp(j);
        currWord = sanityStr1{j};
        if(currWord(end) == '.');
            currWord = currWord(1:end-1);
        end
        if(~isempty(currWord))
            if(~ismember(currWord,stopWords))
                stemmedWord = porterStemmer(currWord);
                stemmedStr{cnt} = stemmedWord;
                cnt = cnt + 1;
            end            
        end
    end   
    
    finalEntireText{i,:} = stemmedStr;
    clear stemmedStr str1 split1 out_str1;
end


%% Creating the features

outputMatrix = zeros(size(trainData,1),length(bagHeaders));
for i = 1:size(trainData,1)
    %disp(i);
    %fprintf('%d/%d ', i, size(inputcellarray,1));
    comment = cellstr(finalEntireText{i,:});    
    outputMatrix(i,:) = term_count(comment, bagHeaders);       
end

tfFeatures = outputMatrix;
tfIDFFeatures = tfidf(outputMatrix);

end

