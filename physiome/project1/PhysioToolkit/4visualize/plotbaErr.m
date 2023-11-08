function y = plotbaErr(f,e)
% bland-altman plot

Ybland = e;
Xbland = f;

Ysort  = sort(Ybland);
Ysort(isnan(Ysort))=[];

n = length(Ysort);
k = round(0.95*n);
a = round((n-k)/2);

CIupper = Ysort(a);
CIlower = Ysort(a+k);

[ay,ax] = hist(Ysort,-10:0.2:10);

figure; plot(Xbland,Ybland,'.'); hold on;
line([0 1000],CIupper*[1 1],'color','r','LineStyle','-.');
line([0 1000],CIlower*[1 1],'color','r','LineStyle','-.');
line([0 1000],std(Ysort)*[1 1],'color','r');
line([0 1000],-std(Ysort)*[1 1],'color','r');

axis([0 max(f) -8 8]);

xlabel('feature');
ylabel('CO-TCO  [L/min]');
title(['\sigma' sprintf('= %1.2f',std(Ysort))]);

w=min(f)/(2*max(ay));

barh(ax,ay*w,1);
