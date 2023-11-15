function [sample_idxs, ...
    onset_idxs, ...
    offset_minslope_idxs, ...
    offset_beatperiod_idxs, ...
    abp_pulses] = get_trace(time, ABP, ABP_features, hour, pulses)
    %hour = str2num(hour);
    idx = find(time == hour*36e2);
    time_pulses = time(idx : idx + pulses * 125);
    abp_pulses = ABP(idx : idx + pulses * 125);
    
    sample_idxs = 1:length(time_pulses);
    % [~, idxs] = findpeaks(-abp_pulses);
    % if abp_pulses(idxs(1)) > abp_pulses(idxs(2))
    %     onset_idxs = idxs(2:2:end);
    %     offset_minslope_idxs = idxs(1:2:end);
    % else
    %     onset_idxs = idxs(1:2:end);
    %     offset_minslope_idxs = idxs(2:2:end);
    % end
    filter = (ABP_features(:, 1) >= idx) & (ABP_features(:, 1) <= idx + pulses*125);
    onset_idxs = ABP_features(filter, 3);
    onset_idxs = onset_idxs - 125*time_pulses(1);
    onset_idxs = onset_idxs(onset_idxs > 0);

    offset_minslope_idxs = ABP_features(filter, 11);
    offset_minslope_idxs = offset_minslope_idxs - 125*time_pulses(1);
    offset_minslope_idxs = offset_minslope_idxs(offset_minslope_idxs > 0);
            
    offset_beatperiod_idxs = ABP_features(filter, 9);
    offset_beatperiod_idxs = offset_beatperiod_idxs - 125*time_pulses(1);
    offset_beatperiod_idxs = offset_beatperiod_idxs(offset_beatperiod_idxs > 0);
end
