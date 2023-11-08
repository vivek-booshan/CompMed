% THIS FILE WORKS AS LONG AS SUBJECT FOLDER AND PHYSIOTOOLKIT 
% ARE SUBDIRECTORIES OF THE FOLDER THIS FILE IS STORED

clf; clc; clear;
% Set present working directory as var
base_path = pwd;

% Recursively search to find subject 20 data files to set path and file
% names
s00020_struct = dir(fullfile(".", "**/s00020", "*.txt"));
s00020_folder = s00020_struct.folder;
s00020_folder = convertCharsToStrings(s00020_folder);
[ABP_125Hz_FILE, S00020_FILE] = s00020_struct.name;

% Recursively search to find the 2analyze folder and set path
analyze2_path = dir(fullfile(".", "**/2analyze", "*.m")).folder;

% load ABP data (125 Hz sampled) using ascii flag
ABP_125Hz_DATA = load(s00020_folder + "/" + ABP_125Hz_FILE, "-ascii");
abp = ABP_125Hz_DATA(:, 2);
time = ABP_125Hz_DATA(:, 1);

%%
% mv to 2analyze folder and get onset sample times w/ wabp()
cd(analyze2_path);
onset_times = wabp(abp);
ABP_features = abpfeature(abp, onset_times);
[beatQ, r] = jSQI(ABP_features, onset_times, abp);
cd(base_path);

%%

%filter first 20 pulses for the 10th hr
idx10 = find(time == 10*36e2);
time10hr_pulse20 = time(idx10 : idx10 + 20*125);
abp10hr_pulse20 = abp(idx10 : idx10 + 20*125);

% Use peak detection to get onset and min slope estimated EoS (end of systole)
% (I just didn't realize abp features included all this and 
% this was my first instinct)
[~, idxs] = findpeaks(-abp10hr_pulse20);
onset_idxs = idxs(2:2:end);
offset_minslope_idxs = idxs(1:2:end);
sample_num = 1:length(time10hr_pulse20);

% get beat period estimated EoS from ABPfeatures
% generate a new filter using indexes and create an offset index from the
% filter. 
filter = (ABP_features(:, 1) >= idx10) & (ABP_features(:, 1) <= idx10 + 20*125);
offset_beatperiod_idxs = ABP_features(filter, 9);
% convert offset_beatperiod_idxs to match the reorded sample_nums
offset_beatperiod_idxs = offset_beatperiod_idxs - 125*time10hr_pulse20(1);
offset_beatperiod_idxs = offset_beatperiod_idxs(offset_beatperiod_idxs > 0);

subplot(2, 1, 1); hold on;

% plot (in order) ABP, onset, min slope estimated EoS and beat period
% estimated EoS
plot(sample_num, abp10hr_pulse20);
plot(onset_idxs, abp10hr_pulse20(onset_idxs), 'k*');
plot(offset_minslope_idxs, abp10hr_pulse20(idxs(1:2:end)), 'ro');
plot( ...
    offset_beatperiod_idxs, ...
    abp10hr_pulse20(offset_beatperiod_idxs), ...
    'x', ...
    'Color', [0.4940, 0.1840, 0.5560] ... %purple color
    )

title("10 Hr")
axis padded;
xlim('tight');

% Get the first 20 pulses at the 11th hour
idx11 = find(time == 11*36e2);
time11hr_pulse20 = time(idx11 : idx11 + 20*125);
abp11hr_pulse20 = abp(idx11 : idx11 + 20*125);

% use peak detection to get the onset and min slope estimated EoS
[~, idxs] = findpeaks(-abp11hr_pulse20);
onset_idxs = idxs(2:2:end);
offset_minslope_idxs = idxs(1:2:end);
sample_num = 1:length(time11hr_pulse20);

% get beat period estimated EoS and transform indexes to match sample num
filter = (ABP_features(:, 1) >= idx11) & (ABP_features(:, 1) <= idx11 + 20*125);
offset_beatperiod_idxs = ABP_features(filter, 9);
offset_beatperiod_idxs = offset_beatperiod_idxs - 125*time11hr_pulse20(1);
offset_beatperiod_idxs = offset_beatperiod_idxs(offset_beatperiod_idxs > 0);

subplot(2, 1, 2); hold on;

% plot (in order) ABP, onset, min slope estimated EoS, beat period
% estimated EoS
plot(sample_num, abp11hr_pulse20);
plot(onset_idxs, abp11hr_pulse20(onset_idxs), 'ro');
plot(offset_minslope_idxs, abp11hr_pulse20(offset_minslope_idxs), 'k*');
plot( ...
    offset_beatperiod_idxs, ...
    abp11hr_pulse20(offset_beatperiod_idxs), ...
    'x', ...
    'Color', [0.4940, 0.1840, 0.5560] ... %purple color
    )
title("11 Hr")
axis padded;
xlim('tight');