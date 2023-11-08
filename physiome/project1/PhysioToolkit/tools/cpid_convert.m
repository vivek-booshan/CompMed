function y = cpid_convert(x)
% converts caseID to PID, returning "0" if no conversion exists
% input: caseid
% output: pid

% load a mat file that contains the mappings
load cpid_table

y = [];

% sherman's new findings --- cp map
ind = find(cp(:,1)==x);
if ~isempty(ind)
    for j=1:length(ind)
        w = cp(ind(j),:);
        w(w==0 | w==x)=[];
        y = [y w];
    end
end

% saeed's old matches --- cp_old map
ind = find(cp_old(:,1)==x);
if ~isempty(ind)
    for j=1:length(ind)
        w = cp_old(ind(j),:);
        w(w==0 | w==x)=[];
        y = [y w];
    end
end

if isempty(y)
    y=0;
end