% KNN co estimator

load aggdb

sqi = cell2mat(sqi);

ind = find(sqi>99);

aimat = [cell2mat(F) cell2mat(tco)];
aimat = aimat(ind,:);

tco = aimat(:,end);


aimat(:,end-2:end-1) = [];

searchspace = aimat(:,3:5);
searchspace = searchspace(:,1).*searchspace(:,3)./searchspace(:,2);


n = length(aimat);
q = zeros(n,1);
for i=1:n
    x = searchspace(i,:);
    
    y = [zeros(n,1) aimat(:,end)];
    for j=1:length(aimat)
        y(j,1) = norm(x-searchspace(j,:));
    end
    
    y = sortrows(y,1);
    q(i) = mean(y(2:6,2));
end

