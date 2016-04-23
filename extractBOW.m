function [ tfFeatures, tfIDFFeatures, bagHeaders ] = extractBOW( trainData )


%% Loading files

stopWords = importdata('D:\Anush\ccd\bpCCD\stopWords.txt');
stopWords = lower(stopWords);
addpath(genpath('D:\Anush\ccd\bpCCD\newCode\MatlabNLP-master\'));
minNumberOfOccurences = 150;

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

%% Creating the bag

lastword = '';
g = containers.Map();
bigs = containers.Map();
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
                tfflag = 1;
            else
                tfflag = 0;
            end            
            
            if isKey(g, stemmedWord) && tfflag
                g(stemmedWord) = g(stemmedWord)+1;
            elseif tfflag & (~strcmp(stemmedWord,' ')) & (~strcmp(stemmedWord,''))
                g(stemmedWord) = 1;
            end
            if  (~strcmp(lastword,'')) & (~strcmp(stemmedWord,' ')) & (~strcmp(lastword,' ')) & (~strcmp(stemmedWord,''))
                bigram = char(strcat(lastword, {' '}, stemmedWord));
                % for debugging :) fprintf('DDD%sDDDDDD%sDDD%sDDD\n',bigram,lastword,word);
                if isKey(g, bigram)
                    g(bigram) = g(bigram)+1;
                else
                    bigs(bigram) =1;
                    g(bigram) = 1;
                end
            end
            lastword = stemmedWord;
        end
    end   
    
    finalEntireText{i,:} = stemmedStr;
    clear stemmedStr str1 split1 out_str1;
end

%% Chose the bag of words

selectedheaders =containers.Map();
gkeys = keys(g);

for i=1:size(gkeys,2)
    if g(gkeys{i})>=minNumberOfOccurences        
        selectedheaders(gkeys{i})=1;        
    end    
end
bagHeaders = keys(selectedheaders);


%% Extract bag of words features

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