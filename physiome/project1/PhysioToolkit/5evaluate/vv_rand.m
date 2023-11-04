function [roc N]=vv_rand(alg)

roc = zeros(100,1);
N = zeros(100,1);
tcostd = zeros(100,1);

load aggdb

warning off MATLAB:divideByZero
for j=1:100
    p=j-1;


    qq = [];
    rr = [];
    for i=1:length(estco)
        ind = find(sqi{i}>p);

        x = estco{i,alg}(ind,1);
        %x = rand(size(d{i,1}(ind,4)));   % random number generator
        %x = ones(size(d{i,1}(ind,4)));  % constant number
        %xx = randperm(size(d{i,1}(ind,4))); x=d{i,1}(ind,4); x = x(xx); % random permutator

        r = tco{i}(ind,3);
        if length(x)<2
            continue
        end
        k = calib(r,x,1);
        q = k.*x;
        %q = x; % no recalibration
        
%         plot(d{i,1}(ind,2),r,'.-r');
%         hold on
%         plot(d{i,1}(ind,2),q,'.-');
%         hold off
%         title(num2str(d{i,2}));
%         pause
        
        qq = [qq; q];
        rr = [rr; r];
    end

    ind2 = find(isnan(qq));
    qq(ind2)=[];
    rr(ind2)=[];
    
    N(j) = length(qq);
    roc(j) = std(qq-rr);
    tcostd(j) = std(rr);
%     if j==1 | j==100
%         figure; hist(rr,100);
%     end
        
end


% plotting
% figure('position',[75 217 839 713])
% subplot(2,1,1)
% plot(roc,'.-'); grid
% xlim([0 100]);
% title('error at 1 \sigma')
% ylabel('x-r [L/min]')
% xlabel('minimum accepted sqi')
% subplot(2,1,2)
% plot(N/N(1),'.-r'); grid
% xlim([0 100]);
% ylabel('normalized data quantity')
% xlabel('minimum accepted sqi')
