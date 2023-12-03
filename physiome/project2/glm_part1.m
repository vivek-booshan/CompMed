%import static training data (700 patients) - this is the basis of the simple model
load('static_data_training.mat');
varNames = {'Subject ID', 'Sepsis Status', 'Gender', 'Age', ...
   'Respiratory Comorbidities', 'Heart Comorbidities', 'Infection'};
static_train = array2table(static_train, 'VariableNames', varNames);

%The header variable contains the meaning of each column of static_train
%generate simple glm
%define Y = observations which should be loaded from clinical table
Y = static_train.("Sepsis Status");
%Y = static_train(:,2);

%define X = covariate matrix
X = table2array(static_train(:,3:7));

%compute glm

[B,dev,stats] = glmfit(X,Y,'binomial');
%construct phat from parameters and X 
Phat = 1 ./ (1 + exp( -[ones(size(X, 1), 1), X] * B)); 
%Phat is the estimated probability of sepsis occurence for patients

% Get 95% confidence interval of betas
UB_betas = B + 1.96*stats.se ;
LB_betas = B - 1.96*stats.se ;
%plot phat versus patient along with its confidence bounds (1.96*stats.se)
% to do this, we use the upper and lower bounds for betas

Phat_UB = 1 ./ (1 + exp( -[ones(length(X), 1), X] * (UB_betas)));
Phat_LB = 1 ./ (1 + exp( -[ones(length(X), 1), X] * (LB_betas)));

% plot first 30 patients prediction, uncertainty and labels.
clf;
figure(1)
plot(Phat(1:30))
hold on
plot(Phat_LB(1:30),'b-')
hold on
plot(Phat_UB(1:30),'b-')
hold on
plot(y(1:30),'r*')
title('Models for Each Patient')

%test performance of models
[threshold] = test_performance(Phat, Y);
l=Y;
[X,Y,T,AUC] = perfcurve(l,Phat, 1);
figure;
plot(X,Y)
