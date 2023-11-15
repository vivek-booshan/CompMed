function plot_trace(sample_idxs, onset_idxs, offset_minslope_idxs, offset_beatperiod_idxs, abp_pulses)
    hold on;
    plot(sample_idxs, abp_pulses);
    plot(onset_idxs, abp_pulses(onset_idxs), 'k*');
    plot(offset_minslope_idxs, abp_pulses(offset_minslope_idxs), 'ro')
    plot( ...
        offset_beatperiod_idxs, ...
        abp_pulses(offset_beatperiod_idxs), ...
        'x', ...
        'Color', [0.4940, 0.1840, 0.5560] ... %purple color
    )

    title("")
end