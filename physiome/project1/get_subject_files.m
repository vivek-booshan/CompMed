function [ABP_125Hz_FILE, SUBJECT_FILE] = get_subject_files(name)
    subject_struct = dir(fullfile(".", sprintf("**/%s", name), "*.txt"));
    [ABP_125Hz_FILE, SUBJECT_FILE] = subject_struct.name;
    ABP_125Hz_FILE = pwd + sprintf("/%s/", name) + ABP_125Hz_FILE;
    SUBJECT_FILE = pwd + sprintf("/%s/", name) + SUBJECT_FILE;
end
