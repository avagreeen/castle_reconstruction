% SAMPLEDESCRIPTOR Sample a MOPS-like descriptor at given positions in the image.
% Arguments:
% im - nxm grayscale image to sample within.
% pos - A Nx2 matrix of [x,y] descriptor positions in im.
% descRad - ”Radius” of descriptors to compute (see below).
% Returns:
% desc - A kxkxN 3-d matrix containing the ith descriptor
% at desc(:,:,i). The per?descriptor dimensions kxk are related to the
% descRad argument as follows k = 1+2*descRad.
function desc = sampleDescriptor(im,pos,descRad)

k = 1 + 2 * descRad; 
N = size(pos, 1);
desc = zeros(k,k,N); 

[x, y] = meshgrid(-descRad:descRad, -descRad:descRad);

for i = 1 : N
    
  x = x + pos(i, 1); % maybe not integers
  y = y + pos(i, 2); % maybe not integers
  
  %interpolation on the indices
  imIntegerPositins = interp2(im, x, y, 'linear');
  desc(:,:,i) = imIntegerPositins;
  %normalize the descriptor to d = (d-miu)/ ||(d-miu)||
  d = desc(:,:,i);
  miu = mean(mean(d(:)));
  d = ((d(:)) - miu) / (norm(d(:) - miu));
  desc(:,:,i) = reshape(d,7,7);
  % initializing x and y to the values -descRad:descRad, -descRad:descRad
  [x, y] = meshgrid(-descRad:descRad, -descRad:descRad);  
end
end