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
            cd(path_2analyze);
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
            abp_pulses...
        ] = get_trace(obj, hour, pulses)
                    
            idx = find(obj.time == hour*36e2);
            time_pulses = obj.time(idx : idx + pulses * 125);
            abp_pulses = obj.abp(idx : idx + pulses * 125);
            
            sample_idxs = 1:length(time_pulses);
      
            filter = (obj.features(:, 1) >= idx) & (obj.features(:, 1) <= idx + pulses*125);
            onset_idxs = obj.features(filter, 3) - idx;
            onset_idxs = onset_idxs(onset_idxs > 0);
            onset_idxs = onset_idxs(onset_idxs < sample_idxs(end));

            offset_minslope_idxs = obj.features(filter, 11) - idx;
            offset_minslope_idxs = offset_minslope_idxs(...
                offset_minslope_idxs < sample_idxs(end) & ...
                offset_minslope_idxs > 0 ...
            );
            %offset_minslope_idxs = offset_minslope_idxs(offset_minslope_idxs > 0);
            
            offset_beatperiod_idxs = obj.features(filter, 9) - idx;
            offset_beatperiod_idxs = offset_beatperiod_idxs(...
                offset_beatperiod_idxs < sample_idxs(end) & ...
                offset_beatperiod_idxs > 0 ...
            );
            %offset_beatperiod_idxs = offset_beatperiod_idxs(offset_beatperiod_idxs > 0); 
        end
        function plot_trace(obj, varargin)%obj, sample_idxs, onset_idxs, offset_minslope_idxs, offset_beatperiod_idxs, abp_pulses)
            nargin
            if nargin == 3
                hour = varargin{1};
                pulses = varargin{2};
                [
                    sample_idxs,...
                    onset_idxs, ...
                    offset_minslope_idxs, ...
                    offset_beatperiod_idxs, ...
                    abp_pulses...
                    ] = obj.get_trace(hour, pulses);

                title( ...
                    sprintf(...
                        "ABP Trace at %d Hours for Subject %d",...
                        hour,...
                        obj.get_num ...
                    ) ...
                );
          
            elseif nargin == 6
                sample_idxs = varargin{1};
                onset_idxs = varargin{2};
                offset_minslope_idxs = varargin{3};
                offset_beatperiod_idxs = varargin{4};
                abp_pulses = varargin{5};
            else
                error("plot trace takes either 2 or 5 arguments (See DOC)");
            end

            hold on;
            plot(sample_idxs, abp_pulses);
            plot(onset_idxs, abp_pulses(onset_idxs), 'k*');
            plot(offset_minslope_idxs, abp_pulses(offset_minslope_idxs), 'ro')
            plot( ...
                offset_beatperiod_idxs, ...
                abp_pulses(offset_beatperiod_idxs), ...
                'x', ...
                'Color', [0.4940, 0.1840, 0.5560] ... %purple color
            );
            
            ylim padded; xlim tight;
            legend(["", "onset", "offset_{minslope}", "offset_{beatperiod}"]);
            
        end 
        function [co, to, told, fea] = estimateCO(obj, estID, filt_order)
            base_path = pwd;
            path_3estimate = dir(fullfile(".", "**/3estimate", "*.m")).folder;
            cd(path_3estimate);
            [co, to, told, fea] = estimateCO_v4(obj.abp, obj.onset_times, obj.features, obj.beatQ, estID, filt_order);
            cd(base_path);
        end
        function num = get_num(obj)
            num = str2double(extract(inputname(1), digitsPattern));
        end
        function [k_CO, k_PP, k_MAP, k_HR] = get_k(obj, CO_idxs, CO, FEA, T)
            k_CO = CO(CO_idxs(1)) / T.CO(CO_idxs(1));
            k_PP = FEA(CO_idxs(1), 5) / (T.ABPSys(CO_idxs(1)) - T.ABPDias(CO_idxs(1)));
            k_MAP = FEA(CO_idxs(1), 6) / (T.ABPMean(CO_idxs(1)));
            k_HR = FEA(CO_idxs(1), 7) / T.HR(CO_idxs(1));
        end
    end
end
