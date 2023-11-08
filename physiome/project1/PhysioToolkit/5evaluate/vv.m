[cid fn] = fnames;

% run CO alg2
co_wk = cell(length(fn),2);
for i=1:length(fn)
    co_wk{i,1} = evco(fn{i},2,60,0);
    co_wk{i,2} = cid(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% run CO alg2
co_lili = cell(length(fn),2);
for i=1:length(fn)
    co_lili{i,1} = evco(fn{i},5,60,0);
    co_lili{i,2} = cid(i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find k for co_wk
k_wk = zeros(length(co_wk),1);
for i=1:length(co_wk)
    r = co_wk{i,1}(:,3);
    x = co_wk{i,1}(:,4);
    k_wk(i) = calib(r,x,1);
end

% find k for co_lili
k_lili = zeros(length(co_lili),1);
for i=1:length(co_wk)
    r = co_lili{i,1}(:,3);
    x = co_lili{i,1}(:,4);
    k_lili(i) = calib(r,x,1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find compliances
C_wk = k_wk;

C_lili = zeros(length(k_lili),1);
for i=1:length(k_lili)
    k = k_lili(i);
    ps = mean(co_lili{i,1}(:,7));
    pd = mean(co_lili{i,1}(:,8));
    C_lili(i) = k/(ps+pd);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% age vs C
load agegender
z = [];
for i=1:length(co_wk)
    cid = co_wk{i,2};
    ind = find(agegender(:,1)==cid);
    if ind
        z = [z; [cid agegender(ind,3) k_wk(i)]];
    end 
end
z(z(:,2)>89,:) = [];  % get rid of PHI


save tushar k_wk k_lili C_wk C_lili z 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plotting

figure; plot(z(:,2),z(:,3),'.');
xlabel('age'); ylabel('arterial compliance (windkessel)');

figure; hold on;
plot(C_wk,'.-');
plot(C_lili,'.-r');
xlabel('patients')
ylabel('arterial compliance');
title('wk in blue, lili in red');

figure; hist(k_lili);
