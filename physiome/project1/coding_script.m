% THIS FILE WORKS AS LONG AS SUBJECT FOLDER AND PHYSIOTOOLKIT 
% ARE SUBDIRECTORIES OF THE FOLDER THIS FILE IS STORED

clf; clc; clear;
% Set present working directory as var
base_path = pwd;

% Recursively search to find subject data files to set path and file
% names
s00020 = Subject("s00020");
s00151 = Subject("s00151");
s00214 = Subject("s00214");

%% Q1
clf;

% plot (in order) ABP, onset, min slope estimated EoS and beat period
% estimated EoS
subplot(2, 1, 1); hold on;
s00020.plot_trace(10, 20);
title(sprintf("ABP Trace at %d Hours for Subject %d", 10, 20));

% plot (in order) ABP, onset, min slope estimated EoS, beat period
% estimated EoS
subplot(2, 1, 2); hold on;
s00020.plot_trace(11, 20);
title(sprintf("ABP Trace at %d Hours for Subject %d", 11, 20));
%% Q2

% Plot subject 151 for 20 pulses for 10th hour and 11th hour
figure; 
subplot(2, 1, 1); 
s00151.plot_trace(10, 20);
title(sprintf("ABP Trace at %d Hours for Subject %d", 10, 151));

subplot(2, 1, 2);
s00151.plot_trace(11, 20);
title(sprintf("ABP Trace at %d Hours for Subject %d", 11, 151));

% Plot subject 151 for 20 pulses for 10th hour and 11th hour
figure;
subplot(2, 1, 1);
s00214.plot_trace(10, 20);
title(sprintf("ABP Trace at %d Hours for Subject %d", 10, 214));

subplot(2, 1, 2);
s00214.plot_trace(11, 20);
title(sprintf("ABP Trace at %d Hours for Subject %d", 11, 214));
%% Q3 & Q4

% basically the same 12 subplots repeated thrice
% decided to just keep it within a separate script for clarity
% - working on a varargin method to generalize comparisons for n
% estimators and auto plot formatting
% - working on dynamic rmse calculation
estimateComparisons

%% Q5
z4 = zeros(3, 1);

%%%% SUBJECT 20 %%%%
% extract calibration and parlikar tpr values using alpha = 2, window = 3
[calibratedCO_20, k_parli_20, Rn_20, true_Rn_20, k_Rn_20] = s00020.Parlikar(2, 3);
% slice first 12 hours
T = s00020.table(s00020.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);

% plot parlikar and tpr
subplot(3, 1, 1); hold on;
plot(timehr_range, calibratedCO_20(time_range), 'r');
stem(s00020.table.ElapsedTime(CO_idxs) / 3600, k_parli_20 * s00020.table.CO(CO_idxs), 'b');
title(sprintf("Parlikar Calibrated CO for Subject %d", s00020.get_num));
z4(1) = rmse(calibratedCO_20(CO_idxs), s00020.table.CO(CO_idxs)*k_parli_20);

%%%% SUBJECT 151 %%%%
% 151 NOISY ==> BAD PARLIKAR IN GENERAL
% had to use mean values of measurements to calibrate
[calibratedCO_151, ~, Rn_151, true_Rn_151, ~] = s00151.Parlikar(2, 3);
T = s00151.table(s00151.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);
k_parli_151 = mean(calibratedCO_151(CO_idxs)) / mean(T.CO(CO_idxs));
k_Rn_151 = mean(Rn_151(T.ElapsedTime(CO_idxs))) / mean(true_Rn_151);
z4(2) = rmse(calibratedCO_151(CO_idxs), s00151.table.CO(CO_idxs)*k_parli_151);

subplot(3, 1, 2); hold on;
plot(timehr_range, calibratedCO_151(time_range), 'r');
stem(s00151.table.ElapsedTime(CO_idxs) / 3600,  s00151.table.CO(CO_idxs) * k_parli_151, 'b');
title(sprintf("Parlikar Calibrated CO for Subject %d", s00151.get_num));

%%%% SUBJECT 214 %%%%
% slice first 12 hours
T = s00214.table(s00214.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);
% plot parlikar and tpr (alpha = 2 and window = 3)
subplot(3, 1, 3); hold on;
[calibratedCO_214, k_parli_214, Rn_214, true_Rn_214, k_Rn_214] = s00214.Parlikar(2, 3);
plot(timehr_range, calibratedCO_214(time_range), "r");
stem(s00214.table.ElapsedTime(CO_idxs) / 3600, k_parli_214 * s00214.table.CO(CO_idxs), 'b');
title(sprintf("Parlikar Calibrated CO for Subject %d", s00214.get_num));
z4(3) = rmse(calibratedCO_214(CO_idxs), s00214.table.CO(CO_idxs)*k_parli_214);

%%%% HEATMAP %%%%
figure;
zeta = cat(3, z, z1, z2);
zeta = sum(zeta, 2);
zeta = reshape(cat(3, zeta, z4), [3, 4]);
zeta = normalize(zeta);
xvalues = {"Lilj", "MP", "WK", "Parli"};
yvalues = {"20", "151", "214"};
h = heatmap(xvalues, yvalues, zeta, 'Colormap', turbo);
h.YLabel = "Subject";
h.XLabel = "Estimator";
h.Title = "Normalized RMSE For Each Estimator w.r.t. Patients";

%% Q6
%%%%% TO DO %%%%%
% - detect bad reference
% - Dynamic Rn allocation
% - detect and disregard noise function
% - automatic axis management

%%%% SUBJECT 20 %%%%%
T = s00020.table(s00020.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);

subplot(3, 1, 1); hold on; title("Subject 20");
plot((3*36e2 : 12*36e2) / 3600, Rn_20(3*36e2 : 12*36e2), 'r');
stem(T.ElapsedTime(CO_idxs)/3600, k_Rn_20 * true_Rn_20, 'b');
%axis([3 12 min(Rn_20(3*36e2 : 12*36e2)) max(Rn_20(3*36e2 : 12*36e2))]);
axis([3 12 0 100]); %consistency btw plots

%%%% SUBJECT 151 %%%%%
% bad data, so a few tweaks had to be made
T = s00151.table;
CO_idxs = find(T.CO ~= 0);

subplot(3, 1, 2); hold on; title("Subject 151");
plot(timehr_range, Rn_151(time_range), 'r');
stem(T.ElapsedTime(CO_idxs(1:end-1)) / 3600, k_Rn_151 * true_Rn_151, 'b');
%axis([3 12 min(Rn_151(3*36e2 : 12*36e2)) 150])
axis([3 12 0 100]); %consistency btw plots

%%%% SUBJECT 214 %%%%
subplot(3, 1, 3); hold on; title("Subject 214");
T = s00214.table(s00214.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);
plot(timehr_range, Rn_214(time_range), 'r');
stem(T.ElapsedTime(CO_idxs)/3600, k_Rn_214 * true_Rn_214, 'b');
axis([3 12 0 100]); %consistency btw plots
xlabel("Time (hours)");

sgtitle("Calibrated TPR for Subjects");

%%%% FIN %%%%%