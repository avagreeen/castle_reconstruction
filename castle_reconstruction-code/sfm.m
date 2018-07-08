function [M, S]= sfm(Points)
% find the motion matrix and shape matrix of points
% Input: 
% Points - measurement matrix
% Output:
% M - motion matrix 
% S - shape matrix
[frames_num, points_num] = size(Points);
% Shift the mean of the points to zero
Points_center = Points - repmat(sum(Points, 2) / points_num, 1, points_num);
% singular value decomposition
[U,W,V] = svd(Points_center);

U = U(:,1:3);
W = W(1:3, 1:3);
V = V(:, 1:3);

M = U * sqrt(W);
S = sqrt(W)* V';

% solve for affine ambiguity using non-linear least squares
save('M','M')

A = M;
L0= inv(A' * A);

% Solve for L
L = lsqnonlin(@myfun,L0);
% determine whether L is positive definite
% if not, change it to the nearest positive definite matrix
eig_A = eig(L);
flag = 0;
for i = 1:rank(A)
	if eig_A(i) <= 0 
	flag = 1;
	end
end
if ~flag
    % Recover C
    C = chol(L,'lower');
    % Update M and S
    M = M*C;
    S = pinv(C)*S;
else
    % Recover C
    L_trans = nearestSPD(L);
    C = chol(L_trans,'lower');
    % Update M and S
    M = M*C;
    S = pinv(C)*S;
end
end