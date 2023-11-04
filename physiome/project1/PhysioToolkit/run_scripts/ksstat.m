%kstest2
err = cell(12,1);
for i=1:12
    [x,r] = runBAplot(i,60,1,0);
    err{i} = x-r;
end
reorder = [1 2 10 6 5 3 4 7 9 8 11 12];
err = err(reorder);

ksmat = zeros(12);
for i=1:12
    for j=i:12
        [h,p] = kstest2(err{i},err{j});
        ksmat(i,j) = p;
    end
end

ksmat = single(ksmat);