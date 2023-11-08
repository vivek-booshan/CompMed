function y=bet_naive(x,w)
% x is column vector
% w is scalar

n = length(x);
A = repmat(x,1,n);
B = repmat(x',n,1);

M = triu(B-A);

[i,j]=find(M<w);

if isempty(i)
    y=[];
    return
end

y = [i x(i) j x(j)];