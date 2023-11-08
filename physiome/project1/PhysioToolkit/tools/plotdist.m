function []=plotdist(x,bin,xlimit,ylimit,str,texx)

if ischar(texx)
    set(0,'defaulttextinterpreter','none')
else
    set(0,'defaulttextinterpreter','tex')
end

[q bins]= hist(x,bin);
h=figure('position',[366   533   691   273]); hold on;
bar(bins,q/sum(q),1,'w');
xlim(xlimit);
ylim(ylimit);
xlabel(str);
ylabel('frequency');

if round(std(x))<=1
title(['distribution   (n=' num2str(length(x)) ',   \mu=' num2str(round(mean(x)*10)/10) ',   \sigma=' num2str(round(std(x)*10)/10) ')']);
else
title(['distribution   (n=' num2str(length(x)) ',   \mu=' num2str(round(mean(x))) ',   \sigma=' num2str(round(std(x))) ')']);
end    

if ischar(texx)
    if round(std(x))<=1
    title(['distribution $(n=' num2str(length(x)) ', \hspace{0.2cm} \mu=' num2str(round(mean(x)*10)/10) ', \hspace{0.2cm} \sigma=' num2str(round(std(x)*10)/10) ')$']);
    else
    title(['distribution $(n=' num2str(length(x)) ', \hspace{0.2cm} \mu=' num2str(round(mean(x))) ', \hspace{0.2cm} \sigma=' num2str(round(std(x))) ')$']);
    end        
    laprint(h,texx)
end
