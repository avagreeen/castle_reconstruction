function  E  = get_error( D, MS, m, n )
% GET_ERROR Summary of this function goes here
% Error to minimize
% Input
% D - the reference point
% MS - The combination of motion matrix and shape matrix
% Output
% E - Error
E = 0;

% Reshape back to M & S
M = reshape(MS(1:m*6), [2*m 3]);
S = reshape(MS(end-3*n+1:end), [3 n]);

% To make more readable
PX = M * S;


for i = 1:m
    for j = 1:n
        
        E = E + sqrt((D(i*2-1, j) - PX(i*2-1, j))^2 + (D(i*2, j) - PX(i*2, j))^2);
        
    end
end

end

