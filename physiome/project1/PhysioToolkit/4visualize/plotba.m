function y = plotba(r,x,a,b)
% bland-altman plot
% a,b are optional

if nargin==2
    a=[];
    b=[];
end

Ybland = x-r;
Xbland = (x+r)/2;

Ysort  = sort(Ybland);
Ysort(isnan(Ysort))=[];

% n = length(Ysort);
% k = round(0.95*n);
% a = round((n-k)/2);
% 
% CIupper = Ysort(a);
% CIlower = Ysort(a+k);

CI = get95(Ysort);

[ay,ax] = hist(Ysort,-10:0.2:10);
figure; hold on;

plot(Xbland,Ybland,'.');
plot(a,b,'o','MarkerFaceColor','r');

axis([-3 15 -8 8]);
ax1 = gca;

xx = get(ax1,'xtick');
xx(xx<0)=[];
set(ax1,'xtick',xx);

xlabel('(CO+TCO)/2  [L/min]');
% for LaTeX %xlabel('$(CO+TCO)/2$  [L/min]');
ylabel('CO estimation error  [L/min]');
% for LaTeX   %title(['Bland-Altman plot $(n=' num2str(length(Ysort)) ', \hspace{0.2cm} \mu(error)=' sprintf('%1.2f',mean(Ysort)) ', \hspace{0.2cm} \sigma(error)=' sprintf('%1.2f',std(Ysort)) ')$']);
title(['n=' num2str(length(Ysort)) ',   \mu=' sprintf('%1.2f',mean(Ysort)) ',   \sigma=' sprintf('%1.2f',std(Ysort)) ',   CI=' sprintf('%1.2f',CI) ]);

ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor','k','YColor','k');
hold on;
hl2 = barh(ax,ay/max(ay),1,'w','Parent',ax2);
axis([0 6 -8 8]);
set(ax2,'visible','off');
axx=axis;

line(axx([1 2]), CI*[1 1],'color','r','LineStyle','-.');
line(axx([1 2]),-CI*[1 1],'color','r','LineStyle','-.');
line(axx([1 2]), std(Ysort)*[1 1],'color','r');
line(axx([1 2]),-std(Ysort)*[1 1],'color','r');
