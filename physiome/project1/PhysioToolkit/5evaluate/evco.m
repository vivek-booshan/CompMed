function y = evco(fname,estID,winsize,clbnum)
% EVCO  Evaluate CO estimation
%   Y = EVCO(FNAME, ESTID, WINSIZE, CLBNUM) calibrates and evaluates CO
%   estimation performance, using thermodilution CO as gold-standard.
%
%   In:   FNAME     (string)   file name -- e.g. fname='~/170.mat';
%         ESTID     (integer)  choose CO estimation algorithm
%         WINSIZE   (integer)  ABP window size (in seconds) to use
%         CLBNUM    (integer)  choose calibration method:
%                              = 1  single k MMSE
%                              = 2  multi  k causal MMSE
%                              = 3  single k 1st point
%                              = 4  multi  k previous point
%                              = 5  not calib, but normalize near 1
%                              = other --- no calib
%
%   Out:  Y
%         Col 1:  enumerate CO number
%             2:  time                      [min]
%             3:  TCO                       [L/min]
%             4:  estimated CO              [L/min] - possibly uncalibrated
%             5:  sigma of estimated CO     [L/min] - possibly uncalibrated
%             6:  sqi percent of good beats [mmHg]
%             7:  Systolic BP       [mmHg]
%             8:  Diastolic BP      [mmHg]
%             9:  Pulse pressure    [mmHg]
%            10:  Mean pressure     [mmHg]
%            11:  heart rate        [bpm]
%            12:  noisiness (sqi thresh at -3)
%            13:  Area under systole   0.3*sqrt(RR)  method
%            14:  Area under systole   1st min-slope method
% 
%   Example:
%   y = evco('170',5,60,1);
%
%   Written by James Sun (xinsun@mit.edu) on Jan 18, 2006.
%   - v2.0 - 1/30/06 - add features (cols 7 thru 14) to output

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get TCO, estimated CO data
load(fname,'t0','m2t');

% obtain TCO, sync TCO time with ABP time
t0_co = 24*60*(m2t.t0 - t0(1,1)); % minutes offset
r     = [(t0_co+m2t.CO(:,1))  m2t.CO(:,2)];

% run bb CO estimate
[est_val,t_est,t_raw,F] = estimateCO(fname,estID,0);
x     = [t_est*60 double(est_val)];
t_raw = t_raw*60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% windowing --- obtain one-to-one estimates with tco
mu    = zeros(size(r,1),1);
sigma = zeros(size(r,1),1);
sqi   = zeros(size(r,1),1);
fea   = zeros(size(r,1),8);
for i=1:size(r,1)
    T  = r(i,1)*60;

    ind = find(x(:,1)<T & x(:,1)>T-winsize);
    ind_raw = find(t_raw<T & t_raw>T-winsize);
    if isempty(ind)
        mu(i)    = NaN;
        sigma(i) = NaN;
        sqi(i)   = 0;
        fea(i,:) = NaN;
    else
        mu(i)    = mean(x(ind,2));
        sigma(i) = std(x(ind,2));
        sqi(i)   = round(length(ind)/length(ind_raw) * 100);
        fea(i,:) = mean(F(ind,[2 4 5 6 7 8 10 12]));
    end
end

% heart rate
fea(:,5) = 60*125./fea(:,5); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calibration
ind_nan = ~isnan(mu);

k = calib(r(ind_nan,2),mu(ind_nan),clbnum);
y = [(1:size(r,1))' r k.*mu k.*sigma sqi fea];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% format output
%y(isnan(mu),:)=[];
