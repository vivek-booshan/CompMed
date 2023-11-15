z = zeros(3, 4);
clf;
sgtitle("Subject 20")
% Get CO, onset times and features from CO estimator using Liljestrand,
% onset times, and ABP features.
[CO, ~, ~, FEA] = s00020.estimateCO(5, 0);
[CO1, ~, ~, FEA1] = s00020.estimateCO(1, 0);
[CO2, ~, ~, FEA2] = s00020.estimateCO(2, 0);
N = length(CO_idxs);
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

subplot(3, 4, 1); hold on;
plot(timehr_range, CO(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
title("CO"); ylabel("Liljestrand")
ylim padded; xlim tight;
z(3, 4, 1) = rmse(CO(CO_idxs)/k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 2); hold on;
plot(timehr_range, FEA(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
title("PP"); 
ylim padded; xlim tight;
z(3, 4, 2) = rmse(FEA(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));

% plot estimated MAP and measured MAP
subplot(3, 4, 3); hold on;
plot(timehr_range, FEA(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
title("MAP"); 
ylim padded; xlim tight;
z(3, 4, 3) = rmse(FEA(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));

% plot estiamted HR and measured HR
subplot(3, 4, 4); hold on;
plot((1:43200)/3600, FEA(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b')
title("HR"); 
ylim padded; xlim tight;
z(3, 4, 4) = rmse(FEA(CO_idxs, 7), k_HR * T.HR(CO_idxs));

%figure;
% plot estimated cardiac output and measured CO
[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO1, FEA1, T);
subplot(3, 4, 5); hold on;
plot(timehr_range, CO1(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
ylabel("Mean Pressure")
ylim padded; xlim tight;
z(3, 4, 5) = rmse(CO1(CO_idxs) / k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 6); hold on;
plot(timehr_range, FEA1(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
ylim padded; xlim tight;
z(3, 4, 6) = rmse(FEA1(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));
% plot estimated MAP and measured MAP
subplot(3, 4, 7); hold on;
plot(timehr_range, FEA1(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
ylim padded; xlim tight;
z(3, 4, 7) = rmse(FEA1(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));
% plot estiamted HR and measured HR
subplot(3, 4, 8); hold on;
plot(timehr_range, FEA1(time_range, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
ylim padded; xlim tight;
z(3, 4, 8) = rmse(FEA1(CO_idxs, 7), k_HR * T.HR(CO_idxs));

[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO2, FEA2, T);
subplot(3, 4, 9); hold on;
plot(timehr_range, CO2(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
xlabel("Time (Hrs)"); ylabel("Windkessel");
ylim padded; xlim tight;
z(3, 4, 9) = rmse(CO2(CO_idxs) / k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 10); hold on;
plot(timehr_range, FEA2(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z(3, 4, 10) = rmse(FEA2(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));
% plot estimated MAP and measured MAP
subplot(3, 4, 11); hold on;
plot(timehr_range, FEA2(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z(3, 4, 11) = rmse(FEA2(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));
% plot estiamted HR and measured HR
subplot(3, 4, 12); hold on;
plot(timehr_range, FEA2(time_range, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z(3, 4, 12) = rmse(FEA2(CO_idxs, 7), k_HR * T.HR(CO_idxs));
z = reshape(z(3, 4, :), [4, 3])';
%% s00151 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z1 = zeros(3, 4);
clf;
sgtitle("Subject 151")
% Get CO, onset times and features from CO estimator using Liljestrand,
% onset times, and ABP features.
[CO, ~, ~, FEA] = s00151.estimateCO(5, 0);
[CO1, ~, ~, FEA1] = s00151.estimateCO(1, 0);
[CO2, ~, ~, FEA2] = s00151.estimateCO(2, 0);

% read data as table and filter first 12 hours
T = s00151.table(s00151.table.ElapsedTime <= 12*36e2, :);
% get measured CO indexes
CO_idxs = find(T.CO ~= 0);

%generate time range in seconds and hrs for plotting
time_range = 1:(12*36e2);
timehr_range = time_range/3600;

% k_A = estimate of A / true A
% Cardiac Output (CO) ; Pulse Pressure (PP); Mean Arterial Pressure (MAP) ;
% Heart Rate (HR);

[k_CO, k_PP, k_MAP, k_HR] = s00151.get_k(CO_idxs, CO, FEA, T);
N = length(CO_idxs);
subplot(3, 4, 1); hold on;
plot(timehr_range, CO(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
title("CO"); ylabel("Liljestrand")
ylim padded; xlim tight;
z1(3, 4, 1) = rmse(CO(CO_idxs)/k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 2); hold on;
plot(timehr_range, FEA(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
title("PP"); 
ylim padded; xlim tight;
z1(3, 4, 2) = rmse(FEA(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));

% plot estimated MAP and measured MAP
subplot(3, 4, 3); hold on;
plot(timehr_range, FEA(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
title("MAP"); 
ylim padded; xlim tight;
z1(3, 4, 3) = rmse(FEA(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));

% plot estiamted HR and measured HR
subplot(3, 4, 4); hold on;
plot((1:43200)/3600, FEA(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b')
title("HR"); 
ylim padded; xlim tight;
z1(3, 4, 4) = rmse(FEA(CO_idxs, 7), k_HR * T.HR(CO_idxs));

%figure;
% plot estimated cardiac output and measured CO
[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO1, FEA1, T);
subplot(3, 4, 5); hold on;
plot(timehr_range, CO1(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
ylabel("Mean Pressure")
ylim padded; xlim tight;
z1(3, 4, 5) = rmse(CO1(CO_idxs) / k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 6); hold on;
plot(timehr_range, FEA1(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
ylim padded; xlim tight;
z1(3, 4, 6) = rmse(FEA1(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));

% plot estimated MAP and measured MAP
subplot(3, 4, 7); hold on;
plot(timehr_range, FEA1(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
ylim padded; xlim tight;
z1(3, 4, 7) = rmse(FEA1(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));

% plot estiamted HR and measured HR
subplot(3, 4, 8); hold on;
plot(timehr_range, FEA1(time_range, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
ylim padded; xlim tight;
z1(3, 4, 8) = rmse(FEA1(CO_idxs, 7), k_HR * T.HR(CO_idxs));

[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO2, FEA2, T);
subplot(3, 4, 9); hold on;
plot(timehr_range, CO2(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
xlabel("Time (Hrs)"); ylabel("Windkessel");
ylim padded; xlim tight;
z1(3, 4, 9) = rmse(CO2(CO_idxs) / k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 10); hold on;
plot(timehr_range, FEA2(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z1(3, 4, 10) = rmse(FEA2(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));

% plot estimated MAP and measured MAP
subplot(3, 4, 11); hold on;
plot(timehr_range, FEA2(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z1(3, 4, 11) = rmse(FEA2(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));

% plot estiamted HR and measured HR
subplot(3, 4, 12); hold on;
plot((1:43200)/3600, FEA2(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z1(3, 4, 12) = rmse(FEA2(CO_idxs, 7), k_HR * T.HR(CO_idxs));
z1 = reshape(z1(3, 4, :), [4, 3])';
%% s00214 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z2 = zeros(3, 4);
clf;
sgtitle("Subject 214")
% Get CO, onset times and features from CO estimator using Liljestrand,
% onset times, and ABP features.
[CO, ~, ~, FEA] = s00214.estimateCO(5, 0);
[CO1, ~, ~, FEA1] = s00214.estimateCO(1, 0);
[CO2, ~, ~, FEA2] = s00214.estimateCO(2, 0);

% read data as table and filter first 12 hours
T = s00214.table(s00214.table.ElapsedTime <= 12*36e2, :);
% get measured CO indexes
CO_idxs = find(T.CO ~= 0);

%generate time range in seconds and hrs for plotting
time_range = 1:(12*36e2);
timehr_range = time_range/3600;

% k_A = estimate of A / true A
% Cardiac Output (CO) ; Pulse Pressure (PP); Mean Arterial Pressure (MAP) ;
% Heart Rate (HR);

[k_CO, k_PP, k_MAP, k_HR] = s00214.get_k(CO_idxs, CO, FEA, T);

subplot(3, 4, 1); hold on;
plot(timehr_range, CO(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
title("CO"); ylabel("Liljestrand")
ylim padded; xlim tight;
z2(3, 4, 1) = rmse(CO(CO_idxs)/k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 2); hold on;
plot(timehr_range, FEA(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
title("PP"); 
ylim padded; xlim tight;
z2(3, 4, 2) = rmse(FEA(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));

% plot estimated MAP and measured MAP
subplot(3, 4, 3); hold on;
plot(timehr_range, FEA(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
title("MAP"); 
ylim padded; xlim tight;
z2(3, 4, 3) = rmse(FEA(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));

% plot estiamted HR and measured HR
subplot(3, 4, 4); hold on;
plot((1:43200)/3600, FEA(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b')
title("HR"); 
ylim padded; xlim tight;
z2(3, 4, 4) = rmse(FEA(CO_idxs, 7), k_HR * T.HR(CO_idxs));

%figure;
% plot estimated cardiac output and measured CO
[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO1, FEA1, T);
subplot(3, 4, 5); hold on;
plot(timehr_range, CO1(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
ylabel("Mean Pressure")
ylim padded; xlim tight;
z2(3, 4, 5) = rmse(CO1(CO_idxs) / k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 6); hold on;
plot(timehr_range, FEA1(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
ylim padded; xlim tight;
z2(3, 4, 6) = rmse(FEA1(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));
% plot estimated MAP and measured MAP
subplot(3, 4, 7); hold on;
plot(timehr_range, FEA1(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
ylim padded; xlim tight;
z2(3, 4, 7) = rmse(FEA1(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));
% plot estiamted HR and measured HR
subplot(3, 4, 8); hold on;
plot(timehr_range, FEA1(time_range, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
ylim padded; xlim tight;
z2(3, 4, 8) = rmse(FEA1(CO_idxs, 7), k_HR * T.HR(CO_idxs));

[k_CO, k_PP, k_MAP, k_HR] = s00020.get_k(CO_idxs, CO2, FEA2, T);
subplot(3, 4, 9); hold on;
plot(timehr_range, CO2(time_range) / k_CO, 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, T.CO(CO_idxs), 'b');
xlabel("Time (Hrs)"); ylabel("Windkessel");
ylim padded; xlim tight;
z2(3, 4, 9) = rmse(CO2(CO_idxs) / k_CO, T.CO(CO_idxs));

% plot estimated PP and measured PP
subplot(3, 4, 10); hold on;
plot(timehr_range, FEA2(time_range, 5), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_PP*(T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z2(3, 4, 10) = rmse(FEA2(CO_idxs, 5), k_PP * (T.ABPSys(CO_idxs) - T.ABPDias(CO_idxs)));
% plot estimated MAP and measured MAP
subplot(3, 4, 11); hold on;
plot(timehr_range, FEA2(time_range, 6), 'r');
stem(T.ElapsedTime(CO_idxs)/36e2, k_MAP*T.ABPMean(CO_idxs), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z2(3, 4, 11) = rmse(FEA2(CO_idxs, 6), k_MAP * T.ABPMean(CO_idxs));
% plot estiamted HR and measured HR
subplot(3, 4, 12); hold on;
plot((1:43200)/3600, FEA2(1:43200, 7), 'r');
stem(T.ElapsedTime(CO_idxs) / 36e2, k_HR * T.HR(CO_idxs), 'b');
xlabel("Time (Hrs)");
ylim padded; xlim tight;
z2(3, 4, 12) = rmse(FEA2(CO_idxs, 7), k_HR * T.HR(CO_idxs));
z2 = reshape(z2(3, 4, :), [4, 3])';