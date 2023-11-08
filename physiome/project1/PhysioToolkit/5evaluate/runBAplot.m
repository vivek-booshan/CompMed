function [qq,rr] = runBAplot(alg,p,c,verb,cst)
% alg = algorithm
% p = sqi threshold 0-100
% c = calibration
% verb = plot or no plot
% cst = special caseid

if nargin<4
    verb=1;
end

if nargin<=4
    cst=[];
end

p=p-1;
% load data
load aggdb3

% population aggregation
warning off MATLAB:divideByZero
qq = [];
rr = [];
cid = [];
for i=1:length(sqi)
    ind = find(sqi{i}>p);

    try
        x = estco{i,alg}(ind,1);
    catch
        continue
    end
    
    r = tco{i}(ind,3);
    if length(x)<2
        continue
    end
    
    k = calib(r,x,c);
    e = k.*estco{i,alg}(ind,2);
    q = k.*x;

    qq = [qq; q(1:end)];
    rr = [rr; r(1:end)];
    cid = [cid; caseid(i,1)*ones(length(q)-1,1)];
    
    t = tco{i}(ind,2);
end

err = qq-rr;
err = err(~isnan(err));
get95(err);

if verb~=0 && isempty(cst)
    plotba(rr,qq);
end

if verb~=0 && ~isempty(cst)
    xred = [];
    yred = [];
    for i =1:length(cst)
        cst1 = cst(i);
        ind = find(cid==cst1);
        xred = [xred; (qq(ind)+rr(ind))/2];
        yred = [yred; qq(ind)-rr(ind)];
    end
    plotba(rr,qq,xred,yred);

    yred=yred(~isnan(yred));
    get95(yred)
    std(yred)
    length(yred)
end
