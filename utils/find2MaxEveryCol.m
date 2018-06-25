% finds 2 maximum numbers in every col in the given matrix 
% and saves their indices.
% return binaryMatrix: if there is a maximum in the (i,j) cell 
% matrix(i, j) = 1 otherwise matrix(i, j) = 0
function binaryMatrix = find2MaxEveryCol(matrix)
[r,c] = size(matrix);
 
[~, indices] = max(matrix);
indices = indices + (0 : r : (c - 1) * r);
matrix(indices) = -Inf;
[~, indices] = max(matrix); 
indices = indices + (0 : r : (c - 1) * r);
matrix(indices) = -Inf;
   
% matrix will contain 1 if the (i,j) element is maximum and 0 otherwise
matrix(matrix~= -Inf) = 0;
matrix(matrix == -Inf) = 1;
binaryMatrix = matrix;
   
end