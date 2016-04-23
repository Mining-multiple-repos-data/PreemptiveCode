function [ finalAns ] = evaluateAlgo( gTruth,pResults )
%EVALUATEALGO Summary of this function goes here
%   Detailed explanation goes here
%
%               Fore  Back
%              ____________  
%   G.T   Fore | x1  | x2
%         Back | x3  | x4 
%              ----------- 
%
%  SA =  (x1 + x4)/(x1 + x2 + x3 + x4)
%  TPR = (x1)/(x1 + x2)   
%  TNR = (x4)/(x3 + x4)
%
%  MDR = (x2)/(x1 + x2)
%  FDR = (x3)/(x1 + x3)

res = (2*gTruth - pResults);

if(min(pResults) == -1)    
    x1 = length(find(res == 1));
    x2 = length(find(res == 3));
    x3 = length(find(res == -3));
    x4 = length(find(res == -1));    
elseif(min(pResults) == 0)
    x1 = length(find(res == 1));
    x2 = length(find(res == 2));
    x3 = length(find(res == -1));
    x4 = length(find(res == 0));    
else
    disp('Incorrect predicted labels');
end

finalAns.SA =  (x1 + x4)/(x1 + x2 + x3 + x4);
finalAns.TPR = (x1)/(x1 + x2);
finalAns.TNR = (x4)/(x3 + x4);

finalAns.FNR = (x2)/(x1 + x2);
finalAns.Prec = (x1)/(x1 + x3);

end

