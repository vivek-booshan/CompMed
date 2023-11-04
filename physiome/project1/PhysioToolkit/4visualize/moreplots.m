load aggdb

alg = 1;

rr = cell2mat(tco);
rr = rr(:,3);

% C1 calibrated
for c=1:4
    n = length(F);
    qq = [];
    for i=1:n
        r = tco{i}(:,3);
        x = estco{i,alg}(:,1);
        e = estco{i,alg}(:,2);
        k = calib(r,x,c);
        q = k.*x;
        qq = [qq; q];
    end

    figure; plot(rr,qq,'.')
end