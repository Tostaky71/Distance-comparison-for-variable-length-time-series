function D = wDTW(X,Y,g)
% Weighted DTW distance between two time series
%
% X : 1 x n
% Y : 1 x m
% g : slope parameter for weight function
%
% Ref papers : Jeong2011 & Bagnall2017

n = length(X);
m = length(Y);
L = max(n,m);

% Weight value (modified logistic weight function)
w = zeros(1,L);
wmax = 1;
for k = 0:L-1
    w(k+1) = wmax / (1 + exp(-g*(k - L/2)));
end

% Initialize the distance matrix
Dmat = zeros(n,m);
Dmat(1,1) = w(abs(1-1)+1) * abs(X(1)-Y(1));
for i = 2:n % first column
    Dmat(i,1) = Dmat(i-1,1) + w(abs(i-1)+1) * abs(X(i)-Y(1));
end
for j = 2:m % first row
    Dmat(1,j) = Dmat(1,j-1) + w(abs(j-1)+1) * abs(X(1)-Y(j));
end

% Fill the distance matrix
for i = 2:n
    for j = 2:m
        cost = w(abs(i-j)+1) * abs(X(i)-Y(j));
        Dmat(i,j) = cost + min([Dmat(i-1,j), Dmat(i,j-1), Dmat(i-1,j-1)]);
    end
end

D = Dmat(n,m);

end
