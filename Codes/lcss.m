function d = lcss(X, Y, epsilon)
% Longest Common Subsequence distance between two time series
%
% X : 1 x n
% Y : 1 x m
% epsilon : matching threshold
%
% Ref papers : Vlachos2002

X = X(:);
Y = Y(:);

n = length(X);
m = length(Y);

% Initialize the distance matrix
Dmat = zeros(n+1, m+1);

% Fill the distance matrix
for i = 1:n
    for j = 1:m
        if abs(X(i) - Y(j)) <= epsilon
            Dmat(i+1,j+1) = Dmat(i,j) + 1;
        else
            Dmat(i+1,j+1) = max(Dmat(i,j+1), Dmat(i+1,j));
        end
    end
end

% Normalized distance : value between 0 and 1
d = 1 - Dmat(n+1,m+1) / min(n,m);

end
