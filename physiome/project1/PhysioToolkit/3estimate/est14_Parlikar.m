function [x, tau] = est14_Parlikar(abp_on, onset_times, Period, MAP, PDias)
    delta_ABP = abp_on(onset_times(2:end)) - abp_on(onset_times(1:end-1));
    PP = 2 * (MAP - PDias);

    tau0 = (Period .* MAP) ./ (PP - delta_ABP);
    tau = tau0;

    window = 10;
    for i = window+1 : (length(tau0)-window)
        tau(i) = mean(tau0(i - window : i + window));
    end

    x = delta_ABP ./ Period + MAP ./ tau0;
end