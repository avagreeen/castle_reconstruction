% HARRISCORNERDETECTOR Extract key points from the image.
% Arguments:
% im - nxm grayscale image to find key points inside.
% pos - A nx2 matrix of [x,y] key points positions in im
function pos = HarrisCornerDetector( im )
k = 0.04;
%Get the Ix and Iy derivatives of the image using the
%filters [1 0 -1], [1; 0 ;-1] respectively

Ix = conv2(im, [1 0 -1], 'same');
Iy = conv2(im, [1 0 -1]', 'same');

%Blur the images: Ix^2, Iy^2, IxIy. You should use your blurInImageSpace.m
%function from ex3
%with kernelSize=3 (please cancel the imshow in this function)

IxPower2 = Ix .^ 2;
IyPower2 = Iy .^ 2;
IxIy = Ix .* Iy;

blurIx2 = blurInImageSpace(IxPower2, 3);
blurIy2 = blurInImageSpace(IyPower2, 3);
blurIxIy = blurInImageSpace(IxIy, 3);
%calculate R
R = (blurIx2 .* blurIy2) - (blurIxIy .^ 2) - k * ((blurIx2 + blurIy2) .^ 2);
pos = nonMaximumSuppression(R);
[r,c] = find(pos ~= 0);

imshow(im), hold on;
plot(c,r,'r.');
pos = [c, r];
hold off;

end