clear; clc;

featureFile = '..\featuresReduced\ApprovalData_5.mat';
opFile = '..results\ApprovalData_5_';
% 1 = Naive Bayes, 2 = libSVM, 3 = Neural Network, 4 = RDF
classifierNum = 3;


load(featureFile);
% shuffleIdx = randperm(size(trainFeatures,1));
% trainF = trainFeatures(shuffleIdx,:);
% trainL = trainLabel(shuffleIdx);
trainF = trainFeatures;
trainL = trainLabel;
switch(classifierNum)
    case 1
        % Do ensemble 1
        disp('Naive Bayes');        
        disp('Performing training ...');
        train_model = NaiveBayes.fit(trainF,trainL,'dist','normal'); % or  'mvmn'
        predictedLabels = train_model.predict(trainF);
        probs = predictedLabels;     
        posClass = 1;
        %trainL = testLabel;
        %finalAns2 = confusionmat(predictedLabels,testLabels);
    case 2
        % Do libSVM
        disp('SVM Classifier');
        addpath(genpath('..\libsvm-3.17\'));%Path to libsvm
        cmd = ['-c 8 -g 2 -t 2'];
        
        disp('Performing training ...');
        train_model = svmtrain(trainL,trainF,cmd);
        disp('Performing testing ...');
        [predictedLabels,acc, prob_estimates] = svmpredict(trainL,trainF,train_model);
        probs = prob_estimates;
        posClass = 0;
    case 3
        % Do Regression
        disp('Logistic regression');        
        disp('Performing training ...');
        train_model = glmfit(trainF,trainL,'normal'); % or  'mvmn'
        probs = glmval(train_model,trainF,'identity');
        predictedLabels = probs>0.5; 
        posClass = 1;
    case 4
        % Do RDF
        disp('RDF Classifier');
        addpath(genpath('..\RF_MexStandalone-v0.02-precompiled\randomforest-matlab\'));%Path to RDF classifier
        ntree = 200;
        mtry = sqrt(size(trainF,2));
        extra_options.replace = 0;
        extra_options.localImp = 1;
        thresh = ntree/2; % 500/2
        extra_options2.predict_all = 'TRUE';
        
        disp('Performing training ...');
        train_model = classRF_train(trainF,trainL,ntree,mtry,extra_options);
        disp('Performing testing ...');
        [predictedLabels,prob_estimates,predPerTree] = classRF_predict(trainF,train_model, extra_options2);
        probs = prob_estimates(:,1)./(prob_estimates(:,2)+eps);
        posClass = 0;
    otherwise
        % Do ensemble 1
        disp('Subspace Ensemble Classifier');
        ensemble1 = fitensemble(trainData,trainLabel,'Subspace','AllPredictorCombinations','Discriminant');
        disp('Performing testing ...');
        predictedLabels = predict(ensemble1,testData);
        prob_estimates = 0;
end

[ finalAns ] = evaluateAlgo(trainL,predictedLabels );

currAcc = finalAns.SA;
currPrec = finalAns.Prec;
currRecal = finalAns.TPR;
disp(strcat('Current Accuracy : ',num2str(currAcc)));
disp(strcat('Current Precision : ',num2str(currPrec)));
disp(strcat('Current Recall : ',num2str(currRecal)));


save(strcat(opFile,num2str(classifierNum),'_mat.mat'),'trainL','posClass','train_model','probs','predictedLabels','finalAns','currAcc','currPrec','currRecal','-v7.3');

[far gar t]=perfcurve(trainL,probs,posClass);
far=100*far;
frr=100-100*gar;

d=abs(far-frr);
d=find(d==min(d),1);
eer= mean([far(d) frr(d)]);
disp(strcat('Equal Error Rate : ',num2str(eer)));

figure1 = figure;
axes1 = axes('Parent',figure1,'YGrid','on','XScale','log','XMinorTick','on',...
    'XMinorGrid','on',...
    'XGrid','on',...
    'FontName','Arial');
ylim(axes1,[0.8 1]);
box(axes1,'on');
hold(axes1,'all');
semilogx(far,gar,'LineWidth',3);
xlabel('False Accept Rate (in log scale)','FontSize',12,'FontName','Arial');
ylabel('True Accept Rate','FontSize',12,'FontName','Arial');
saveas(gcf,strcat(opFile,num2str(classifierNum),'_roc.pdf'));
