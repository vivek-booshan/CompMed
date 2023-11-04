% load appropriate data
garbage = [];

load aggdb3rr
ind = find(caseid(:,3)~=0 & caseid(:,4)~=0);
cids = caseid(ind,:);

for j=1:length(ind)

cid = cids(j,:);

cid
tic

str = sprintf('load %d t0 m2t',cid(1)); eval(str);

% obtain TCO, sync TCO time with ABP time
t0_co = 24*60*(m2t.t0 - t0(1,1)); % minutes offset
%r     = [(t0_co+m2t.CO(:,1))  m2t.CO(:,2)];
r = tco{ind(j)}(:,2:3);

t0(:,1) = 24*60*(t0(:,1)-t0(1,1));


% run Wesseling CO on each segment
error = 0;
estco{ind(j),11} = zeros(size(r,1),2)*nan;
for i=1:size(r,1)

    % find correct ABP segment
    b=1;
    while b
        if t0(b,1)<r(i,1) && t0(b,1)+t0(b,2)/7500>r(i,1)+1
            str = sprintf('load %d abp%d',cid(1),b); eval(str);
            str = sprintf('abp=abp%d; clear abp%d',b,b); eval(str);
            s0  = round(7500*(r(i,1)-t0(b,1)));
            abp = abp(s0:s0+7499);
            error = 0;
            break
        end
        b=b+1;
        if b>size(t0,1)
            error = 1;
            break
        end
    end
    
    if error==1
        garbage = [garbage; [cids(j,1) 1 i]]
        continue
    end    
    
    age    = cid(3);
    gender = cid(4);
    
    try
    onset  = wabp(abp);
    fea    = abpfeature(abp,onset);
    MAP    = fea(:,6);
    HR     = 60*125./fea(:,7);
%    endSys = fea(:,11); % 1st min slope method
    endSys = fea(:,9); % RR method
    
    % run modelflow
    CO     = est11_mf2(abp,onset,MAP,HR,age,gender,endSys);
    sqi    = jSQI(fea, onset, abp);
    i2     = find(sqi(:,1));
    CO(i2) = [];
    
    if isempty(CO)
        estco{ind(j),11}(i,1:2) = single([0 0]);
    else
        estco{ind(j),11}(i,1:2) = single([mean(CO) std(CO)]);
    end

    catch
        garbage = [garbage; [cids(j,1) 2 i]]
        continue
    end
end

save aggdb3rr estco -append
toc
end

save aggdb3rr garbage -append
