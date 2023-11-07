% THIS FILE WORKS AS LONG AS SUBJECT FOLDER AND PHYSIOTOOLKIT 
% ARE SUBDIRECTORIES OF THE FOLDER THIS FILE IS STORED

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

%%
idx10 = find(time == 36e3);
idx11 = find(time == 11*36e2);

% wrapped with cd(base_path) for debugging
% mv to 2analyze and get ABP features
cd(base_path)
cd(analyze2_path)
ABP_features = abpfeature(abp, onset_times);
cd(base_path)

%%
cd(analyze2_path)
[beta, r] = jSQI(ABP_features, onset_times, abp);
cd(base_path)

%%

time10hr_pulse20 = time(idx10 : idx10 + 20*125);
abp10hr_pulse20 = abp(idx10 : idx10 + 20*125);
[~, idxs] = findpeaks(-abp10hr_pulse20);
sample_num = 1:length(time10hr_pulse20);


subplot(2, 1, 1);
hold on;
plot(sample_num, abp10hr_pulse20);
plot(sample_num(idxs(2:2:end)), abp10hr_pulse20(idxs(2:2:end)), 'k*');
plot(sample_num(idxs(1:2:end)), abp10hr_pulse20(idxs(1:2:end)), 'ro');
title("10 Hr")
axis padded;
xlim('tight');

time11hr_pulse20 = time(idx11 : idx11 + 20*125);
abp11hr_pulse20 = abp(idx11 : idx11 + 20*125);
[locs, idxs] = findpeaks(-abp11hr_pulse20);
sample_num = 1:length(time11hr_pulse20);


subplot(2, 1, 2);
hold on;
plot(sample_num, abp11hr_pulse20);
plot(sample_num(idxs(2:2:end)), abp11hr_pulse20(idxs(2:2:end)), 'ro');
plot(sample_num(idxs(1:2:end)), abp11hr_pulse20(idxs(1:2:end)), 'k*')
title("11 Hr")
axis padded;
xlim('tight');