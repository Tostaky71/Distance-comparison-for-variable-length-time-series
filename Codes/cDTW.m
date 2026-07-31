function Dist=cDTW(t,r,alpha)
% Constrained DTW between two time series
%
% t : 1 x N vector
% r : 1 x M vector
%
% Ref : code by J. Paparrizos (Github: TheDatumOrg/grail-matlab)
% slightly modified by L. Poirier--Herbeck

    if iscolumn(t)
        t=t';
    end
    if iscolumn(r)
        r=r';
    end
    [rows,N]=size(t);
	[rows,M]=size(r);

	D=ones(N+1,M+1)*inf;

    W = round(alpha * max(N,M)); % added

	D(1,1) = 0;
	for i=2:N+1
		for j=max(2, i-W):min(M+1, i+W)
			cost = (t(i-1)-r(j-1))^2;
			D(i,j)=cost+min([D(i-1,j),D(i-1,j-1),D(i,j-1)]);
		end
	end
	Dist=sqrt(D(N+1, M+1));
end