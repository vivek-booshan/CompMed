classdef Subject
    % SUBJECT CLASS : Converts all subject abp files and measurements into
    % a series of subject properties for ease of use. 
    % Currently handles *ABP.txt and *n.txt files
    properties
        time % abp times from any *ABP.txt file
        abp % abp values from any *ABP.txt file
        features % abp features extracted from *ABP.txt file
        onset_times % onset times extracted from *ABP.txt file
        beatQ % beatQ extracted from features, abp values, and onset times
        table % converts *n.txt file to table format
    end

    methods
        function obj = Subject(name)
            % Constructs subject class by extracting all data from 
            % *ABP and *n.txt files
            %
            %
            % REQUIRES SUBJECT FOLDER AS N-CHILD IN PROJECT DIRECTORY
            % REQUIRES PHYSIOTOOLKIT AS N-CHILD IN PROJECT DIRECTORY
            %
            % ARGIN: 
            %   name (str) : name of subject (ex. "s00020")

            % find the subject folder and extract *ABP and *n.txt files
            subject_struct = dir(fullfile(".", sprintf("**/%s", name), "*.txt"));
            [subject_abp_file, subject_file] = subject_struct.name;
            subject_abp_file = pwd + sprintf("/%s/", name) + subject_abp_file;
            subject_file = pwd + sprintf("/%s/", name) + subject_file;
            subject_abp_data = load(subject_abp_file, "-ascii");
            
            % get time, abp, and table properties from ABP and n files
            obj.time = subject_abp_data(:, 1);
            obj.abp = subject_abp_data(:, 2);
            obj.table = readtable(subject_file);
            
            % move to 2analyze and extract onset times, features, and beatQ
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
            % GET_TRACE
            % Finds the ABP trace of the subject data given the starting
            % hour and the # of pulses to be measured
            %
            %
            % ARGIN
            %   - hour (int | double) : the starting time for getting a trace
            %   - pulses (int) : #  of pulses to trace out
            %
            %
            % ARGOUT 5 (nx1 double)
            %   - sample_idxs (nx1 double) : returns a column of sample nums
            %   - onset_idxs (nx1 double) : returns idxs of all onsets
            %   - offset_minslope_idxs (nx1 double) : returns idxs of all
            %       offset idxs calculated by minslope method (Sun et al. 2009)
            %   - offset_beatperiod_idxs (nx1 double) : returns idxs of all
            %       offset idxs calculated by using beatperiods (Sun et al.
            %       2009)

                    
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
        function plot_trace(obj, varargin)
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
                        hour, obj.get_num ...
                    ) ...
                );
                xlabel("Sample #");
                ylabel("ABP");
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
            hold off;
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
