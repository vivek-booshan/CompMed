%This code creates and tests a model of septic risk

glm_part2;
clearvars -except B
% clearvars -except B % save coefficients

%bring in testing data
% use keys to get feature indices
load('static_data_training.mat');
load('static_data_test.mat');
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

load('dynamic_data_test.mat');
keys = {'lactate', 'cardio_sofa', 'gcs', 'hr', 'pao2', 'fio2'};
test_idxs = zeros(1, length(keys));
for i = 1:length(keys)
    test_idxs(i) = find(strcmp(header, keys(i)));
end


%extract variables for data structures
% adapt preallocation to feature amount
Y_test = nan(length(dynamic_val(:,1)), 1);
X_test = nan(length(dynamic_val(:,1)), length(static_idxs) + length(test_idxs));
X_test(:,[1:length(test_idxs)] + length(static_idxs)) = dynamic_val(:,test_idxs);
IDs = dynamic_val(:,1); %septic patient ID for each waveform time point
ID_uni = static_val(:,1); %patient's ID numbers

%create covariate matrix including both demographic info and waveform data
for i = 1:length(ID_uni) %for septic data
    ind = find(IDs==ID_uni(i));
    X_test(ind, 1:length(static_idxs)) = repmat(static_train(i,static_idxs),length(ind),1);
    display(num2str(i));
    Y_test(ind) = repmat(static_train(i,sepsis_status),length(ind),1);
end

%%%%%%%%COMPUTE TEST MODEL USING B FROM TRAINING MODEL
Phat_val = 1 ./ (1 + exp(-[ones(length(X_test), 1), X_test] * B));
 

% get the optimal operating point and generate threshold
[X2, Y2, T2, ~, OPTROCPT] = perfcurve(Y_test, Phat_val, 1);
threshold = T2((X2 == OPTROCPT(1)) & (Y2 == OPTROCPT(2)));
Y_test_bestguess = (Phat_val >= threshold);

PercentCorrect = (1 - sum(abs(Y_test-Y_test_bestguess))/length(Y_test))*100;

[thresh] = test_performance(Phat_val, Y_test);

[B,dev,stats] = glmfit(X_test,Y_test,'binomial');
%construct phat from parameters and X 
Phat = 1 ./ (1 + exp( -[ones(size(X_test, 1), 1), X_test] * B)); 
UB = B + 1.96 * stats.se;
LB = B - 1.96 * stats.se;
Phat_UB = 1 ./ (1 + exp( -[ones(length(X_test), 1), X_test] * (UB)));
Phat_LB = 1 ./ (1 + exp( -[ones(length(X_test), 1), X_test] * (LB)));


% plot first 30 patients prediction, uncertainty and labels.
plot(Phat(1:30), 'r-')
hold on
plot(Phat_LB(1:30),'b-')
hold on
plot(Phat_UB(1:30),'b-')
hold on
plot(Y_test(1:30),'r*')
title('Models for Each Patient')
xlabel("Patient IDs"); ylabel("P_hat");
