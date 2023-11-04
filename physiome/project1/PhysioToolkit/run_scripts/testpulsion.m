load 170 abp1 onset F

abp = abp1;
F = F{1};
onset = onset{1};

clear abp1

Ps = F(:,2);
Pd = F(:,4);
Pp = F(:,5);
MAP = F(:,6);
endSys = F(:,9);
HR = 60*125./F(:,7);

%endSys(endSys>7500)=[];
MAP=MAP(1:length(MAP));
HR=HR(1:length(MAP));
%onset(onset>7500)=[];

tic
%[CO,flow] = est11_mf(abp,onset,MAP,endSys,HR,age,gender);
[CO,q] = est08_Pulsion(abp, onset, MAP, HR, endSys);
toc

figure; plot(q/10,'-r'); hold on; plot(abp);

colilj = est05_Lilj(Pp,HR,Ps,Pd);

figure; plot(CO/CO(10), '.-r'); hold on; plot(colilj/colilj(1),'.-');
