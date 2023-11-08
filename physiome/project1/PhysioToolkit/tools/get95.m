function y = get95(x)
% returns 95% confidence interval

y=std(x);

m=mean(x);

xs = sort(x);

n=length(x);
ind1=round(0.025*n);
ind2=round(0.975*n);

y= mean(abs(xs([ind1 ind2])));

%% alternative: just use std
%y=std(x);
