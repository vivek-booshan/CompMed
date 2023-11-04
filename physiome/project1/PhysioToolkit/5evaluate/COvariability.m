function [snr_big, k_big] = COvariability()
% CO variability study
%   1. snr_big --- noise level of CO estimates
%   2. k_big --- stability of calibration constant k 

load aggdb

snr_big = zeros(12,1);
k_big   = zeros(12,2);
for j=1:12
    snr = zeros(length(estco),1);
    k   = zeros(length(estco),2);
    for i=1:length(estco)
        if isempty(estco{i,j})
            continue
        end
        mu     = estco{i,j}(:,1);
        sigma  = estco{i,j}(:,2);
        s = sigma./mu;
        s(isnan(s))=[];
        snr(i) = mean(s);

        r    = tco{i}(:,3);
        x    = estco{i,j}(:,1);
        ind  = ~isnan(x);
        k(i,1) = calib(r(ind),x(ind),1);
        k(i,2) = calib(r(ind),x(ind),3);
    end
    
    snr(snr==0)=[];
    badz = [];
    for i=1:length(estco)
        if sum(k(i,:))==0 | sum(k(i,:))==inf
            badz=[badz i];
        end
    end
    k(badz,:)=[];
    
    snr_big(j) = mean(snr);
    k_big(j,:) = std(k)./mean(k);
end

snr_big = round(snr_big*100)/100;
k_big   = round(k_big*100)/100;

reorder = [1 2 10 6 5 3 4 7 9 8 11 12];
snr_big = snr_big(reorder,:);
k_big   = k_big(reorder,:);
