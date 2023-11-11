function subject = unpack_subject(name)
    [subject_abp_file, subject_file] = get_subject_files(name);
    subject_abp_data = load(subject_abp_file, "-ascii");
    subject.time = subject_abp_data(:, 1);
    subject.abp = subject_abp_data(:, 2);
    subject.table = readtable(subject_file);
end
