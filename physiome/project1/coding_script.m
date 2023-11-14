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

subplot(2, 1, 1); hold on;
s00151.plot_trace(10, 20);

subplot(2, 1, 2); hold on;
s00151.plot_trace(11, 20);

%% Q3

% Get CO, onset times and features from CO estimator using Liljestrand,
% onset times, and ABP features.
[CO, ~, ~, FEA] = s00020.estimateCO(5, 0);
[CO1, ~, ~, FEA1] = s00020.estimateCO(1, 0);
[CO2, ~, ~, FEA2] = s00020.estimateCO(2, 0);

% read data as table and filter first 12 hours
T = s00020.table(s00020.table.ElapsedTime <= 12*36e2, :);
% get measured CO indexes
CO_idxs = find(T.CO ~= 0);

%generate time range in seconds and hrs for plotting
time_range = 1:(12*36e2);
timehr_range = time_range/3600;

% k_A = estimate of A / true A
% Cardiac Output (CO) ; Pulse Pressure (PP); Mean Arterial Pressure (MAP) ;
% Heart Rate (HR);

[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO, FEA, T);
% k_CO = CO(CO_idxs(1)) / T.CO(CO_idxs(1));
% k_PP = FEA(CO_idxs(1), 5) / (T.ABPSys(CO_idxs(1)) - T.ABPDias(CO_idxs(1)));
% k_MAP = FEA(CO_idxs(1), 6) / (T.ABPMean(CO_idxs(1)));
% k_HR = FEA(CO_idxs(1), 7) / T.HR(CO_idxs(1));

% plot estimated cardiac output and measured CO
subplot(4, 1, 1); hold on;
plot(timehr_range, CO(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
ylabel("CO"); xlabel("Time (Hrs)")
ylim padded; xlim tight;

% plot estimated PP and measured PP
subplot(4, 1, 2); hold on;
plot(timehr_range, FEA(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
ylabel("PP"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

% plot estimated MAP and measured MAP
subplot(4, 1, 3); hold on;
plot(timehr_range, FEA(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
ylabel("MAP"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

% plot estiamted HR and measured HR
subplot(4, 1, 4); hold on;
plot((1:43200)/3600, FEA(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
ylabel("HR"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

%% Q4
figure;
% plot estimated cardiac output and measured CO
[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO1, FEA1, T);
subplot(4, 1, 1); hold on;
plot(timehr_range, CO1(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
ylabel("CO"); xlabel("Time (Hrs)")
ylim padded; xlim tight;

% plot estimated PP and measured PP
subplot(4, 1, 2); hold on;
plot(timehr_range, FEA(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
ylabel("PP"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

% plot estimated MAP and measured MAP
subplot(4, 1, 3); hold on;
plot(timehr_range, FEA(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
ylabel("MAP"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

% plot estiamted HR and measured HR
subplot(4, 1, 4); hold on;
plot((1:43200)/3600, FEA(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
ylabel("HR"); xlabel("Time (Hrs)");
ylim padded; xlim tight;
%%
figure;
[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO2, FEA2, T);
subplot(4, 1, 1); hold on;
plot(timehr_range, CO1(time_range)/k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
ylabel("CO"); xlabel("Time (Hrs)")
ylim padded; xlim tight;

% plot estimated PP and measured PP
subplot(4, 1, 2); hold on;
plot(timehr_range, FEA(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
ylabel("PP"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

% plot estimated MAP and measured MAP
subplot(4, 1, 3); hold on;
plot(timehr_range, FEA(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
ylabel("MAP"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

% plot estiamted HR and measured HR
subplot(4, 1, 4); hold on;
plot((1:43200)/3600, FEA(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
ylabel("HR"); xlabel("Time (Hrs)");
ylim padded; xlim tight;

