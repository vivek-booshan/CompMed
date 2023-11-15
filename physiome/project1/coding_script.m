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

% plot (in order) ABP, onset, min slope estimated EoS, beat period
% estimated EoS
subplot(2, 1, 2); hold on;
s00020.plot_trace(11, 20);

%% Q2

% Plot subject 151 for 20 pulses for 10th hour and 11th hour
figure; 
subplot(2, 1, 1); 
s00151.plot_trace(10, 20);

subplot(2, 1, 2);
s00151.plot_trace(11, 20);

% Plot subject 151 for 20 pulses for 10th hour and 11th hour
figure;
subplot(2, 1, 1);
s00214.plot_trace(10, 20);

subplot(2, 1, 2);
s00214.plot_trace(11, 20);

%% Q3 & Q4

estimateComparisons

%% Q5 & Q6

% extract calibration and parlikar tpr values
[calibratedCO_20, k_parli] = s00020.Parlikar(2, 3);

% slice first 12 hours
T = s00020.table(s00020.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);

hold on;
% plot parlikar and tpr
plot(timehr_range, calibratedCO_20(time_range), 'r');
stem(s00020.table.ElapsedTime(CO_idxs)/3600, k_parli * s00020.table.CO(CO_idxs), 'b');
title(sprintf("Parlikar Calibrated CO for Subject %d", s00020.get_num));

% 151 NOISY ==> BAD PARLIKAR IN GENERAL
% figure; hold on;
% [calibratedCO_151, k_parli] = s00151.Parlikar(2, 3);
% plot(timehr_range, calibratedCO_151(time_range), 'r');
% stem(s00151.table.ElapsedTime(CO_idxs) / 3600, k_parli * s00151.table.CO(CO_idxs), 'b');
% title(sprintf("Parlikar Calibrated CO for Subject %d", s00151.get_num));

figure; hold on;
% slice first 12 hours
T = s00214.table(s00214.table.ElapsedTime <= 12*36e2, :);
CO_idxs = find(T.CO ~= 0);
% plot parlikar and tpr
[calibratedCO_214, k_parli] = s00214.Parlikar(2, 3);
plot(timehr_range, calibratedCO_214(time_range), "r");
stem(s00214.table.ElapsedTime(CO_idxs) / 3600, k_parli * s00214.table.CO(CO_idxs), 'b');
title(sprintf("Parlikar Calibrated CO for Subject %d", s00214.get_num));