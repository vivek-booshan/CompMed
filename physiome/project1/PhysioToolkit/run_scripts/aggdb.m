function []=aggdb(alg)
% creates a aggdb database with using algorithm x. Database structure as
% follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% caseid matrix <nx4>
%   col 1: caseid
%       2: pid
%       3: age
%       4: gender
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tco cell <nx1>
% One cell for each caseid. Within each cell is a <kx3> matrix:
%   col 1:  tco num
%       2:  time [minute], relative to beginning of each record
%       3:  tco  [L/min]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% F <nx1>
%   col 1:  Systolic BP       [mmHg]
%       2:  Diastolic BP      [mmHg]
%       3:  Pulse pressure    [mmHg]
%       4:  Mean pressure     [mmHg]
%       5:  heart rate        [bpm]
%       6:  noisiness (sqi thresh at -3)
%       7:  Area under systole   0.3*sqrt(RR)  method
%       8:  Area under systole   1st min-slope method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% estco cell <nx11>
%   col 1:  est01_MAP.m      --- Mean pressure
%       2:  est02_WK.m       --- Windkessel 1st order LTI RC circuit model
%       3:  est03_SA.m       --- Systolic area distributed model
%       4:  est04_SAwarner.m --- Warner's SA with time correction
%       5:  est05_Lilj.m     --- Liljestrand's PP/(Psys+Pdias) estimator
%       6:  est06_Herd.m     --- Herd's estimator
%       7:  est07_SAwessCI.m --- Wesseling's SA with impedance correction
%       8:  est08_Pulsion.m  --- Pulsion's non-linear compliance model
%       9:  est09_LidCO.m    --- LidCO's root-mean-square model
%      10:  est10_RCdecay.m  --- RC exponential decay fit
%      11:  est11_mf.m       --- Wesseling's NLTV 3-element model
% within each cell is a <kx2> matrix
%   col 1:  uncalibrated CO
%       2:  std dev of the 1 minute segment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sqi cell <nx1>
% One cell for each caseid. Within each cell is a <kx1> vector:
%   - quality of each segment --- 100=best, 0=worst
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off MATLAB:divideByZero

[cid fn] = fnames;
n = length(fn);

if alg==1
    caseid  = zeros(n,4);
    tco     = cell(n,1);
    sqi     = cell(n,1);
    F       = cell(n,1);
    estco   = cell(n,1);

    load agegender
    caseid(:,1) = cid;
    for i=1:n
        i
        x = evco(fn{i},alg,60,0);

        ind = find(agegender(:,1)==cid(i));
        if ind
            age    = agegender(ind,3);
            gender = agegender(ind,4);
        else
            age    = 0;
            gender = 0;
        end

        caseid(i,2) = cpid_convert(cid(i));
        caseid(i,3) = age;
        caseid(i,4) = gender;

        tco{i}          = x(:,1:3);
        estco{i,alg}    = x(:,4:5);
        sqi{i}          = x(:,6);
        F{i}            = x(:,7:end);
    end

    % save results!
    save aggdb caseid tco estco sqi F

else
    load aggdb
    for i=1:n
        i
        for j=1:length(alg)
            x               = evco(fn{i},alg(j),60,0);
            estco{i,alg(j)} = x(:,4:5);
        end
    end
    save aggdb estco -append
end
