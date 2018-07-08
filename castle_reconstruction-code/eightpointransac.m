function H = eightpointransac(pos1,pos2)
% Use least square to get H
% Input:
% pos1,pos2: nx2 matrices containing n rows of matched points.
% Output:
% H - A normalized homography matrix
epsilon = 1e-10;
one = ones(size(pos1,1),1);
zer = 0*one;
A = [...
  pos1(:,1),zer,-pos1(:,1).*pos2(:,1),pos1(:,2),zer,-pos1(:,2).*pos2(:,1),one,zer;...
  zer,pos1(:,1),-pos1(:,1).*pos2(:,2),zer,pos1(:,2),-pos1(:,2).*pos2(:,2),zer,one];
if size(A,1) == 8
  if rcond(A) < epsilon
    H = [];
    return;
  end
end

H = mldivide(A,[pos2(:,1);pos2(:,2)]);
H(end+1) = 1;
H = reshape(H,[3,3]);

