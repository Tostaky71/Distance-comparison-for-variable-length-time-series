function D = swale(X, Y, epsilon, p, r)
% Sequence Weighted ALignmEnt distance
%
% X : 1 x n vector
% Y : 1 x m vector
% epsilon  : matching threshold
% p        : penalty for a mismatch
% r        : reward for a match
%
% Ref papers : Morse&Patel2007

n = length(X);
m = length(Y);

% Initialize the distance matrix
Dmat = zeros(n, m);
for j = 1:m % first column
    Dmat(1, j) = p * (j - 1);
end
for i = 1:n % first row
    Dmat(i, 1) = p * (i - 1);
end

% Fill the distance matrix
for i = 2:n
    for j = 2:m
        if abs(X(i) - Y(j)) <= epsilon
            Dmat(i, j) = r + Dmat(i-1, j-1); % it's a match : reward
        else
            Dmat(i, j) = p + max(Dmat(i-1, j), Dmat(i, j-1)); % it's a mismatch : penalty
        end
    end
end
D = Dmat(n, m);

end