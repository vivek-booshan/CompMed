%This code creates and tests a model of septic risk
clear;clc;
%import both clinical data and waveform data
load('static_data_training.mat');
load('dynamic_data_training.mat');

%%%%
%generate covariates for complex model

%preparing a septic/non-septic vector for glmfit
%note all septic data will be first, followed by all non-septic data
Y = nan(length(dynamic_train(:,1)),1);
X = nan(length(dynamic_train(:,1)),11);
X(:,6:11) = dynamic_train(:,3:8);
IDs = dynamic_train(:,1);%septic patient ID for each waveform time point
ID_uni = static_train(:,1);%patient's ID numbers

%create covariate matrix including both demographic info and waveform data
for i = 1:length(ID_uni)%for septic data
    ind = find(IDs==ID_uni(i));
    X(ind,1:5) = repmat(static_train(i,3:7),length(ind),1);
    display(num2str(i));
    Y(ind) = repmat(static_train(i,2),length(ind),1);
end

%%%%
[B,dev,stats] = glmfit(X,Y,'binomial');%find model parameters 
Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat
[thresh] = test_performance(Phat, Y);
