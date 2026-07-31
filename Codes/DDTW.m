function D = DDTW(X,Y)
% Derivative DTW distance between two time series
%
% X : 1 x n vector
% Y : 1 x m vector
%
% Ref papers : Keogh&Pazzani2001 & Bagnall2017

n = length(X);
m = length(Y);

% Compute derivatives of the two time series
Xd = derivative(X);
Yd = derivative(Y);

% Initialize the distance matrix
Dmat = zeros(n,m);
Dmat(1,1) = abs(Xd(1)-Yd(1));
for i = 2:n % first column
    Dmat(i,1) = Dmat(i-1,1) + abs(Xd(i)-Yd(1));
end
for j = 2:m % first row
    Dmat(1,j) = Dmat(1,j-1) + abs(Xd(1)-Yd(j));
end

% Fill the distance matrix
for i = 2:n
    for j = 2:m
        cost = abs(Xd(i)-Yd(j));
        Dmat(i,j) = cost + min([Dmat(i-1,j), Dmat(i,j-1), Dmat(i-1,j-1)]);
    end
end

D = Dmat(n,m);
end




% Derivative function
function Xd = derivative(X)

n = length(X);
Xd = zeros(1,n);

% boundary points
Xd(1) = X(2)-X(1);
Xd(n) = X(n)-X(n-1);

% interior points
for i = 2:n-1
    Xd(i) = ((X(i)-X(i-1)) + (X(i+1)-X(i-1))/2)/2;
end

end
