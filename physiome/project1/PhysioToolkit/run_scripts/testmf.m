load 170 abp1 onset F

abp = abp1(1:7500);
F = F{1};
onset = onset{1};

clear abp1

age = 45;
gender = 2; % female

Ps = F(:,2);
Pd = F(:,4);
Pp = F(:,5);
MAP = F(:,6);
endSys = F(:,9);
HR = 60*125./F(:,7);

endSys(endSys>7500)=[];
MAP=MAP(1:length(MAP));
HR=HR(1:length(MAP));
onset(onset>7500)=[];

tic
[CO,flow] = est11_mf(abp,onset,MAP,HR,age,gender);
toc

colilj = est05_Lilj(Pp,HR,Ps,Pd);

figure; plot(flow,'-r'); hold on; plot(abp);

figure; plot(CO/CO(10), '.-r'); hold on; plot(colilj/colilj(1),'.-');
