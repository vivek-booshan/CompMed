% THIS FILE WORKS AS LONG AS SUBJECT FOLDER AND PHYSIOTOOLKIT 
% ARE SUBDIRECTORIES OF THE FOLDER THIS FILE IS STORED

% Set present working directory as var
base_path = pwd;

% Recursively search to find subject 20 data files to set path and file
% names
s00020_struct = dir(fullfile(".", "**/s00020", "*.txt"));
s00020_folder = s00020_struct.folder;
s00020_folder = convertCharsToStrings(s00020_folder);
[ABP_125Hz_FILE, S00020_FILE] =s00020_struct.name;

% Recursively search to find the 2analyze folder and set path
analyze2_path = dir(fullfile(".", "**/2analyze", "*.m")).folder;

% load ABP data (125 Hz sampled) using ascii flag
ABP_125Hz_DATA = load(s00020_folder + "/" + ABP_125Hz_FILE, "-ascii");

% mv to 2analyze folder and get onset sample times w/ wabp()
cd(analyze2_path);
onset_times = wabp(ABP_125Hz_DATA(:, 1));

%%

% wrapped with cd(base_path) for debugging
% mv to 2analyze and get ABP features
cd(base_path)
cd(analyze2_path)
ABP_features = abpfeature(ABP_125Hz_DATA(:, 1), onset_times);
cd(base_path)


