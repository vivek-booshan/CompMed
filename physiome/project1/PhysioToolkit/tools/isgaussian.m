function musig = genorm(varargin)

figure;
j=0;
musig=[];
for i=1:nargin
    x = varargin{i};
    j=j+1; subplot(nargin,2,j);
    
    [mu,sigma] = normfit(x);
    wx = linspace(mu-4*sigma,mu+4*sigma,4000);
    w  = normpdf(wx,mu,sigma);
    n = sort(hist(x,100),'descend');
    scale = mean(n(1:5))/max(w);
    hist(x,100); hold on; plot(wx,w*scale,'-r','LineWidth',3);
    title(['\mu= ',num2str(mu,'%2.3g'),'   \sigma= ',num2str(sigma,'%2.3g')]);
    
    j=j+1; subplot(nargin,2,j);
    normplot(x);
    
    musig = [musig; [mu sigma]];
end