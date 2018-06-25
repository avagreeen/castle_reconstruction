function H12 = leastSquaresHomography(pos1,pos2)
% LEASTSQUARESHOMOGRAPHY Compute least square fit to homography 
% transforming between two sets of points.
%
% Arguments:
% pos1,pos2 - Two nx2 matrices containing n rows of [x,y] coordinates of 
%   matched points.
%
% Returns:
% H12 - A normalized homography matrix that transforms the points pos1 as 
%   close as possible (in the least squares sense) to pos2. 
%
% Description:
% Denoting by [x1i,y1i] = pos1(i,:), by [x2,y2] = pos2(i,:), and by 
% [xtag1i,ytag1i] = H12(x1i,y1i), then H12 is the homography for which 
% sum_i[(xtag1i-x2i)^2+(ytag1i-y2i)^2] is minimal.

epsilon = 1e-10;
one = ones(size(pos1,1),1);
zer = 0*one;
A = [...
  pos1(:,1),zer,-pos1(:,1).*pos2(:,1),pos1(:,2),zer,-pos1(:,2).*pos2(:,1),one,zer;...
  zer,pos1(:,1),-pos1(:,1).*pos2(:,2),zer,pos1(:,2),-pos1(:,2).*pos2(:,2),zer,one];
if size(A,1) == 8
  if rcond(A) < epsilon
    H12 = [];
    return;
  end
end
H12 = A\[pos2(:,1);pos2(:,2)];
H12(end+1) = 1;
H12 = reshape(H12,[3,3]);

