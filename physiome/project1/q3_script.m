base_path = pwd;

s00020_struct = dir(fullfile(".", "**/s00020", "*.txt"));
s00020_folder = s00020_struct.folder;
s00020_folder = convertCharsToStrings(s00020_folder);
[ABP_125Hz_FILE, S00020_FILE] = s00020_struct.name;

% Recursively search to find the 2analyze folder and set path
analyze3_path = dir(fullfile(".", "**/3estimate", "*.m")).folder;

% load ABP data (125 Hz sampled) using ascii flag
s00020_DATA = load(s00020_folder + "/" + s00020_FILE, "-ascii");
opts = detectImportOptions(base_path + "/s00020/" + s00020_FILE);
opts.SelectedVariableNames = ["ElapsedTime", "HR", "ABPSys", "ABPDias"];
T = readtable(s00020_DATA, opts);


% k = 7.6044


