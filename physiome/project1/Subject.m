classdef Subject
    properties
        time
        abp
        features
        onset_times
        beatQ
        table
        % abp_pulses
        % sample_idxs
        % onset_idxs
        % offset_minslope_idxs
        % offset_beatperiod_idxs
    end

    methods
        function obj = Subject(name)
            subject_struct = dir(fullfile(".", sprintf("**/%s", name), "*.txt"));
            [subject_abp_file, subject_file] = subject_struct.name;
            subject_abp_file = pwd + sprintf("/%s/", name) + subject_abp_file;
            subject_file = pwd + sprintf("/%s/", name) + subject_file;
            subject_abp_data = load(subject_abp_file, "-ascii");
            obj.time = subject_abp_data(:, 1);
            obj.abp = subject_abp_data(:, 2);
            obj.table = readtable(subject_file);
            
            base_path = pwd;
            path_2analyze = dir(fullfile(".", "**/2analyze", "*.m")).folder;
            cd(path_2analyze)
            obj.onset_times = wabp(obj.abp);
            obj.features = abpfeature(obj.abp, obj.onset_times);
            [obj.beatQ, ~] = jSQI(obj.features, obj.onset_times, obj.abp);
            cd(base_path);
        end
        function [...
                sample_idxs,...
                onset_idxs,...
                offset_minslope_idxs,...
                offset_beatperiod_idxs,...
                abp_pulses] = get_trace(obj, hour, pulses)
                    
            idx = find(obj.time == hour*36e2);
            time_pulses = obj.time(idx : idx + pulses * 125);
            abp_pulses = obj.abp(idx : idx + pulses * 125);
            
            sample_idxs = 1:length(time_pulses);
            % [~, idxs] = findpeaks(-abp_pulses);
            % if abp_pulses(idxs(1)) > abp_pulses(idxs(2))
            %     onset_idxs = idxs(2:2:end);
            %     offset_minslope_idxs = idxs(1:2:end);
            % else
            %     onset_idxs = idxs(1:2:end);
            %     offset_minslope_idxs = idxs(2:2:end);
            % end
            filter = (obj.features(:, 1) >= idx) & (obj.features(:, 1) <= idx + pulses*125);
            onset_idxs = obj.features(filter, 3);
            onset_idxs = onset_idxs - idx;
            onset_idxs = onset_idxs(onset_idxs > 0);

            offset_minslope_idxs = obj.features(filter, 11);
            offset_minslope_idxs = offset_minslope_idxs - 125*time_pulses(1);
            offset_minslope_idxs = offset_minslope_idxs(offset_minslope_idxs > 0);
            
            offset_beatperiod_idxs = obj.features(filter, 9);
            offset_beatperiod_idxs = offset_beatperiod_idxs - 125*time_pulses(1);
            offset_beatperiod_idxs = offset_beatperiod_idxs(offset_beatperiod_idxs > 0); 
        end
        function [co, to, told, fea] = estimateCO(obj, estID, filt_order)
            base_path = pwd;
            path_3estimate = dir(fullfile(".", "**/3estimate", "*.m")).folder;
            cd(path_3estimate);
            [co, to, told, fea] = estimateCO_v3(obj.onset_times, obj.features, obj.beatQ, estID, filt_order);
            cd(base_path);
        end
        function [k_CO, k_PP, k_MAP, k_HR] = get_k(obj, CO_idxs, CO, FEA, T)
            k_CO = CO(CO_idxs(1)) / T.CO(CO_idxs(1));
            k_PP = FEA(CO_idxs(1), 5) / (T.ABPSys(CO_idxs(1)) - T.ABPDias(CO_idxs(1)));
            k_MAP = FEA(CO_idxs(1), 6) / (T.ABPMean(CO_idxs(1)));
            k_HR = FEA(CO_idxs(1), 7) / T.HR(CO_idxs(1));
        end
    end
end
