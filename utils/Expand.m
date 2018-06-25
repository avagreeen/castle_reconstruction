% Exapnding the image with zero padding in the even places
% and blurring it with 2*filter convolution
function [expandedIm] = Expand(im, filter)

imageSize = size(im);
rows = imageSize(1);
cols = imageSize(2);

expandedIm  = zeros(rows * 2, cols * 2);
expandedIm(1:2:end, 1:2:end) = im;
expandedIm = conv2(expandedIm, 2 * filter, 'same');
expandedIm = conv2(expandedIm, 2 * (filter.'), 'same');

end









