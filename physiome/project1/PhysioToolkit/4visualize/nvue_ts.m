function [y_tco, y_est] = nvue_ts(fname,estID,filt_order)
% NVUE  ABP/CO viewer
%   NVUE(FNAME, ESTID, FILT_ORDER) views ABP waveform, estimated CO, and
%   features.
%
%   In:   FNAME      (string)   file name -- e.g. fname='~/170.mat';
%         ESTID      (integer)  choose which CO estimation algorithm to use
%         FILT_ORDER (integer)  order of running avg LPF on estimated CO
%
%   Out:  4 plots
%         fig1 - Dashed green line is the thermodilution CO trend.  
%                Red and blue bars are the ABP waveform segments available.
%         fig2 - Relative estimate of CO using algorithm ESTID.
%         fig3 - 6 subplots of various ABP features
%         fig4 - Zoomed out view of an ABP waveform segment.  
%                ABP in blue, features of ABP marked in green and red. 
%                Red on bottom is the beat-to-beat SQI, where 0=good, 10=bad.
% 
%   Usage:
%   - When prompted with "[start_time duration] (vector in minutes):",
%     EITHER enter something like [200 100] to view ABP starting at 200
%     minutes and lasting 100 minutes
%     OR enter an integer to view an entire ABP segment.
%     Note:  viewing ABP for longer than 300 minutes is strongly
%     discouraged! Zooming in and out will take forever.
%
%   Written by James Sun (xinsun@mit.edu) on Nov 19, 2005.
%   - v2.0 - 12/19/05 - added ABP feature plotting
%   - v2.1 -  1/10/06 - compliant with new MAT data format
%   - v3.0 -  1/18/06 - commented out ABP feature plotting
%                     - repeatedly asks for plotting ABP at end

load(fname,'t0','m2t','F','onset');

t00 = t0(1,1);
t_abp(:,1) = 60*24*(t0(:,1)-t00);   % ABP segment time in minutes
t_abp(:,2) = t0(:,2)/(60*125);      % length of each segment in minutes

% sync TCO time with ABP time
tco  = m2t.CO;
ttco = m2t.t0;
t0_co  = 24*60*(ttco - t00);
t_co   = [t0_co+tco(:,1)  tco(:,2)];

if estID~=0
    [est_val,t_est] = estimateCO(fname,estID,filt_order);
end

y_tco = t_co(:,1:2);
y_est = [t_est est_val];
