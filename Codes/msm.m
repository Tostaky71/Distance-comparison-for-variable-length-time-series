function D = msm(X, Y, costt)
% Move-Split-Merge distance between two time series
%
% X : 1 x n
% Y : 1 x m
% costt : cost of split/merge
%
% Ref paper : Stefan2013

m = numel(X);
n = numel(Y);

% Initialize the distance matrix
Dmat(1,1) = abs(X(1) - Y(1));
for i = 2 : m  % first column
    Dmat(i,1) = Dmat(i-1,1) + C(X(i), X(i-1), Y(1), costt);
end
for j = 2 : n  % first row
    Dmat(1,j) = Dmat(1,j-1) + C(Y(j), X(1), Y(j-1), costt);
end

% Fill the distance matrix
for i = 2:m
    for j = 2:n
        d1 = Dmat(i-1,j-1) + abs(X(i) - Y(j)); % Move
        d2 = Dmat(i-1,j) + C(X(i), X(i-1), Y(j), costt); % Split
        d3 = Dmat(i,j-1) + C(Y(j), X(i), Y(j-1), costt); % Merge
        dd = [d1,d2,d3];
        Dmat(i,j) = min(dd);
    end
end
D = Dmat(m,n);

end


function dist = C(new_point, x, y, costt)
% cost of Split/Merge
    if (((x <= new_point) && (new_point <= y)) || ...
         ((y <= new_point) && (new_point <= x)))
        dist = costt;
    else
        dist = costt + min (abs(new_point-x), abs(new_point-y));
    end
end
