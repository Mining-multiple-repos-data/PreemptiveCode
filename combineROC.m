clear;
clc;

matSVM1 = 'D:\Anush\ccd\bpCCD\results\AUIData_1_2_mat.mat';
matSVM2 = 'D:\Anush\ccd\bpCCD\results\AUIData_2_2_mat.mat';
matSVM3 = 'D:\Anush\ccd\bpCCD\results\AUIData_3_2_mat.mat';
matSVM4 = 'D:\Anush\ccd\bpCCD\results\AUIData_4_2_mat.mat';
matSVM5 = 'D:\Anush\ccd\bpCCD\results\AUIData_5_2_mat.mat';
matRDF1 = 'D:\Anush\ccd\bpCCD\results\AUIData_1_4_mat.mat';
matRDF2 = 'D:\Anush\ccd\bpCCD\results\AUIData_2_4_mat.mat';
matRDF3 = 'D:\Anush\ccd\bpCCD\results\AUIData_3_4_mat.mat';
matRDF4 = 'D:\Anush\ccd\bpCCD\results\AUIData_4_4_mat.mat';
matRDF5 = 'D:\Anush\ccd\bpCCD\results\AUIData_5_4_mat.mat';
matReg1 = 'D:\Anush\ccd\bpCCD\results\AUIData_1_4_mat.mat';
matReg2 = 'D:\Anush\ccd\bpCCD\results\AUIData_2_4_mat.mat';
matReg3 = 'D:\Anush\ccd\bpCCD\results\AUIData_3_4_mat.mat';
matReg4 = 'D:\Anush\ccd\bpCCD\results\AUIData_4_4_mat.mat';
matReg5 = 'D:\Anush\ccd\bpCCD\results\AUIData_5_4_mat.mat';
matNB1 = 'D:\Anush\ccd\bpCCD\results\AUIData_1_4_mat.mat';
matNB2 = 'D:\Anush\ccd\bpCCD\results\AUIData_2_4_mat.mat';
matNB3 = 'D:\Anush\ccd\bpCCD\results\AUIData_3_4_mat.mat';
matNB4 = 'D:\Anush\ccd\bpCCD\results\AUIData_4_4_mat.mat';
matNB5 = 'D:\Anush\ccd\bpCCD\results\AUIData_5_4_mat.mat';


load(matSVM1);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls{:,1} = sTrainL;
pro{:,1} = 1-sprobs;
load(matSVM2);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls{:,2} = sTrainL;
pro{:,2} = sprobs;
load(matSVM3);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls{:,3} = sTrainL;
pro{:,3} = 1-sprobs;
load(matSVM4);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls{:,4} = sTrainL;
pro{:,4} = sprobs;
load(matSVM5);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls{:,5} = sTrainL;
pro{:,5} = 1-sprobs;

load(matRDF1);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls2{:,1} = sTrainL;
pro2{:,1} = sprobs;
load(matRDF2);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls2{:,2} = sTrainL;
pro2{:,2} = sprobs;
load(matRDF3);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls2{:,3} = sTrainL;
pro2{:,3} = sprobs;
load(matRDF4);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls2{:,4} = sTrainL;
pro2{:,4} = sprobs;
load(matRDF5);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls2{:,5} = sTrainL;
pro2{:,5} = sprobs;


load(matReg1);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls3{:,1} = sTrainL;
pro3{:,1} = sprobs;
load(matReg2);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls3{:,2} = sTrainL;
pro3{:,2} = sprobs;
load(matReg3);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls3{:,3} = sTrainL;
pro3{:,3} = sprobs;
load(matReg4);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls3{:,4} = sTrainL;
pro3{:,4} = sprobs;
load(matReg5);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls3{:,5} = sTrainL;
pro3{:,5} = sprobs;



load(matNB1);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls4{:,1} = sTrainL;
pro4{:,1} = sprobs;
load(matNB2);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls4{:,2} = sTrainL;
pro4{:,2} = sprobs;
load(matNB3);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls4{:,3} = sTrainL;
pro4{:,3} = sprobs;
load(matNB4);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls4{:,4} = sTrainL;
pro4{:,4} = sprobs;
load(matNB5);
[sTrainL,ids] = sort(trainL,'descend');
sprobs = probs(ids);
lbls4{:,5} = sTrainL;
pro4{:,5} = sprobs;



% for SVM
posClass = 1;
[far1 gar1 t1]=perfcurve(lbls,pro,posClass,'XVals',[0:0.0001:1]);

% for RDF
posClass = 0;
[far2 gar2 t2]=perfcurve(lbls2,pro2,posClass,'XVals',[0:0.0001:1]);

% for reg
posClass = 1;
[far3 gar3 t3]=perfcurve(lbls3,pro3,posClass,'XVals',[0:0.0001:1]);

% for NB
posClass = 1;
[far4 gar4 t4]=perfcurve(lbls4,pro4,posClass,'XVals',[0:0.0001:1]);

%[X Y t1]=perfcurve(lbls,pro,posClass);

figure1 = figure;
axes1 = axes('Parent',figure1,'YGrid','on','XScale','log','XMinorTick','on',...
    'XMinorGrid','on',...
    'XGrid','on',...
    'FontName','Arial');
ylim(axes1,[0.8 1]);
box(axes1,'on');
hold(axes1,'all');
semilogx(far1,gar1(:,1),'LineWidth',3),hold on,semilogx(far2,gar2(:,1),'LineWidth',3),hold on,semilogx(far3,gar3(:,1),'LineWidth',3),hold on,semilogx(far4,gar4(:,1),'LineWidth',3);
xlabel('False Accept Rate (in log scale)','FontSize',12,'FontName','Arial');
ylabel('True Accept Rate','FontSize',12,'FontName','Arial');
%saveas(gcf,strcat(opFile,num2str(classifierNum),'_roc.pdf'));
