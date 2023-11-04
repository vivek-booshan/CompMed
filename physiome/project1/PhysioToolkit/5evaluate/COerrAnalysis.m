function y = COerrAnalysis(alg,p,c,fea,n,verb)
% alg = algorithm
% p   = sqi threshold 0-100
% c   = calibration
% fea = feature to compare error against
% n   = number of bins to segment fea

p=p-1;
% load data
load aggdb

% population aggregation
warning off MATLAB:divideByZero
qq = [];
rr = [];
ff = [];
for i=1:length(caseid)
    ind = find(sqi{i}>p);
    if isempty(estco{i,alg})
        continue
    end

    x = estco{i,alg}(ind,1);
    r = tco{i}(ind,3);

    k = calib(r,x,c);
    e = k.*estco{i,alg}(ind,2);
    q = k.*x;
    
    if fea==9 % TCO itseld
        f = q;
    elseif fea==10
        f = r;
    elseif fea==11 % PVR MAP/TCO in PRU units
        f = F{i}(ind,4)./(r*1000/60);
    else
        f = F{i}(ind,fea);
    end
    if length(x)<2
        continue
    end
    
    qq = [qq; q(2:end)];
    rr = [rr; r(2:end)];
    ff = [ff; f(2:end)];
    
    t = tco{i}(ind,2);
end

%%%% find Low, Med, High - n-way bin
error = qq-rr;
indE = find(isnan(error));
qq(indE)=[];
rr(indE)=[];
ff(indE)=[];
error(indE)=[];

bin_size = round(length(rr)/n);
[ff_sorted ind] = sort(ff);

ff_bin = zeros(n,1);
err = zeros(n,1);
rbound = zeros(n-1,1);
for i=1:n-1
    ff_bin(i) = mean(ff_sorted((i-1)*bin_size+1:i*bin_size));
    rbound(i) = max(ff_sorted((i-1)*bin_size+1:i*bin_size));
    err(i)    = get95(error(ind((i-1)*bin_size+1:i*bin_size)));
end
ff_bin(n) = mean(ff_sorted(i*bin_size+1:end));
err(n)    = get95(error(ind(i*bin_size+1:end)));

y = [ff_bin err];

if verb ==1
    figure; plot(ff,error,'.'); hold on
    ylim([-5 5]);
    ylabel('error [L/min]');
    ax = axis;
    rbound = [ax(1); rbound; ax(2)];
    for i=1:n
        if mod(i,2)
            fill(rbound([i i+1 i+1 i]),ax([4 4 3 3]),0.9*[1,1,1]);
        end
    end

    bar(ff_bin,err,0.3,'m');
    bar(ff_bin,-err,0.3,'m');

    plot(ff,error,'.');

    switch fea
        case  1;   xtext = 'systolic BP [mmHg]';
        case  2;   xtext = 'diastolic BP [mmHg]';
        case  3;   xtext = 'pulse pressure [mmHg]';
        case  4;   xtext = 'mean arterial pressure [mmHg]';
        case  5;   xtext = 'heart rate [bpm]';
        case  6;   xtext = 'noisiness';
        case  7;   xtext = 'sysAreaRR';
        case  8;   xtext = 'sysAreaMinslope';
        case  9;   xtext = 'estimated CO [L/min]';
        case 10;   xtext = 'TCO [L/min]';
        case 11;   xtext = 'systemic resistance [mmHg$\cdot$s/ml]';
        otherwise; xtext = '';
    end
    %disp(xtext);
    xlabel(xtext);

    text(y(1,1),4.5,'Low','HorizontalAlignment','center');
    text(y(2,1),4.5,'Med','HorizontalAlignment','center');
    text(y(3,1),4.5,'High','HorizontalAlignment','center');
end
