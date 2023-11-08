load aggdb

% new alg: estCO = constant mean
for i=1:length(caseid)
    meanCO = single([mean(tco{i}(:,3)) 0]);
    estco{i,12} = repmat(meanCO,size(estco{i,1},1),1);
end

for i=1:length(caseid)
    estco{i,11} = single(estco{i,11});
end

save aggdb estco -append
