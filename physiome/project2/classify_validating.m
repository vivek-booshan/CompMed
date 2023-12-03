%This code creates and tests a model of septic risk
clear
glm_part2
clearvars -except B % save coefficients

%bring in testing data
load('static_data_validating.mat');
load('dynamic_data_validating.mat');

%extract variables for data structures
Y_val = nan(length(dynamic_val(:,1)),1);
X_val = nan(length(dynamic_val(:,1)),11);
X_val(:,6:11) = dynamic_val(:,3:8);
IDs = dynamic_val(:,1);%septic patient ID for each waveform time point
ID_uni = static_val(:,1);%patient's ID numbers

%create covariate matrix including both demographic info and waveform data
for i = 1:length(ID_uni)%for septic data
    ind = find(IDs==ID_uni(i));
    X_val(ind,1:5) = repmat(static_train(i,3:7),length(ind),1);
    display(num2str(i));
    Y_val(ind) = repmat(static_train(i,2),length(ind),1);
end

%%%%%%%%COMPUTE TEST MODEL USING B FROM TRAINING MODEL
Phat_val = 1./(1+exp(-[ones(size(X_val,1),1) X_val]*B));

%Implement your decision rule for each patient here.

%YOU ADD YOUR CLASSIFIER HERE!!!! 
% Y_test_bestguess = ????????????????

% PercentCorrect = (1 - sum(abs(Y_test-Y_test_bestguess))/length(Y_test))*100


