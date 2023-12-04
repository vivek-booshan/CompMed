%This code creates and tests a model of septic risk
clear;clc;
%import both clinical data and waveform data
load('static_data_training.mat');
sepsis_status = find(strcmp(header, 'sepsis_status'));
keys = {...
    'respiratory_comorbidities',...
    'cardiovascular_comorbidities',...
    'infection'...
    };
static_idxs = zeros(1, length(keys));
for i  = 1:length(keys)
    static_idxs(i) = find(strcmp(header, keys(i)));
end

load('dynamic_data_training.mat');
keys = {'lactate', 'cardio_sofa', 'gcs', 'hr', 'pao2', 'fio2'};
val_idxs = zeros(1, length(keys));
for i = 1:length(keys)
    val_idxs(i) = find(strcmp(header, keys(i)));
end

%%%%
%generate covariates for complex model

%preparing a septic/non-septic vector for glmfit
%note all septic data will be first, followed by all non-septic data

Y = nan(length(dynamic_train(:,1)), 1);
X = nan(length(dynamic_train(:,1)), length(val_idxs) + length(static_idxs));
X(:,[1:length(val_idxs)] + length(static_idxs)) = dynamic_train(:, val_idxs); 
IDs = dynamic_train(:,1); % septic patient ID for each waveform time point
ID_uni = static_train(:,1); % patient's ID numbers

%create covariate matrix including both demographic info and waveform data
for i = 1:length(ID_uni)%for septic data
    ind = find(IDs==ID_uni(i));
    X(ind,1:length(static_idxs)) = repmat(static_train(i,static_idxs),length(ind),1);
    display(num2str(i));
    Y(ind) = repmat(static_train(i,sepsis_status),length(ind),1);
end

%%%%
[B,dev,stats] = glmfit(X, Y,'binomial');%find model parameters 
Phat = 1./(1+exp(-[ones(size(X,1),1) X]*B)); %equivalent way to compute Phat
[thresh] = test_performance(Phat, Y);

UB = B + 1.96 * stats.se;
LB = B - 1.96 * stats.se;
Phat_UB = 1 ./ (1 + exp( -[ones(length(X), 1), X] * (UB)));
Phat_LB = 1 ./ (1 + exp( -[ones(length(X), 1), X] * (LB)));


% plot first 30 patients prediction, uncertainty and labels.
figure(1)
plot(Phat(1:30), 'r-')
hold on
plot(Phat_LB(1:30),'b-')
hold on
plot(Phat_UB(1:30),'b-')
hold on
plot(Y(1:30),'r*')
title('Models for Each Patient')
xlabel("Patient ID"); ylabel("P_hat");
