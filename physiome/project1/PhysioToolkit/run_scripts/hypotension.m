% ATR hypotension study

load aggdb

thresh = -30; % drop by 30mmHg in MAP
csai   = 0.9; % segment SAI must be above this thresh

y={};
for i=1:length(F)
    MAP = F{i}(:,4);
   
    % min max checks
    [min_MAP min_ind] = min(MAP);
    [max_MAP max_ind] = max(MAP);
    
    if (min_MAP-max_MAP <= -30) && (max_ind < min_ind)
        
        % obtain hypotensive events
        x = bet_naive(MAP,thresh);
        
        % merge data -- [time1 TCO1 ind1 MAP1 sqi1    time2 TCO2 ind2 MAP2 sqi2]
        q = [tco{i}(x(:,1),2:3) x(:,1:2) sqi{i}(x(:,1)) tco{i}(x(:,3),2:3) x(:,3:4) sqi{i}(x(:,3))];
        
        % obtain PVR using MAP/TCO
        pvr1 = q(:,4) ./ q(:,2);  % *1000/60 to get into PRU
        pvr2 = q(:,9) ./ q(:,7);
        dR_tco = (pvr2 ./ pvr1 -1)*100;
        
        % obtain PVR using MAP/estcoX
        dR_algX = [];
        for j=[2 3 5]
            pvr1 = q(:,4) ./ estco{i,j}(x(:,1),1);
            pvr2 = q(:,9) ./ estco{i,j}(x(:,3),1);
            dR_algX = [dR_algX (pvr2 ./ pvr1 -1)*100];
        end
        
        
        y = [y; {round(10*[q dR_tco dR_algX])/10 caseid(i,1)}];
    end    
end

%  14 columns, with algorithms PP*HR, systolic area, Liljestrand
%  1     2    3    4    5    6     7    8    9    10   11     12,13,14
% [time1 TCO1 ind1 MAP1 sqi1 time2 TCO2 ind2 MAP2 sqi2 dR_TCO dR_algX]

x = y;
for i=1:length(x)
    x{i,1} = [x{i,1} x{i,2}*ones(size(x{i,1},1),1)];
end
x = cell2mat(x(:,1));

figure; hist(x(:,11)); xlabel('percent change in PVR'); ylabel('number of occurrences');
title('histogram')

ind = find(x(:,5)>=90 & x(:,10)>=90);
figure; plot(x(ind,11),x(ind,14),'.'); xlim([-60 0]); ylim([-60 0]); axis square
line([-60 0],[-60 0],'Color','r')
xlabel('\DeltaPVR (percent change) TCO method');
ylabel('\DeltaPVR (percent change) Lilj method');
title('Results for CSAI>90%');
