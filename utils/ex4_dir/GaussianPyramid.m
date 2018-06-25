function [pyr, filter] = GaussianPyramid(im, maxLevels, filterSize)
% change im to grayscclae image with double values in [0,1]

imSize = size(im);
rows = imSize(1);
cols = imSize(2);
minDim = min(rows, cols);

%decide the final levels of the pyramid
levels = 1 + log2(minDim);
if (log2(minDim) < 16)         
    levels = 16;
end;
if (levels > maxLevels)
    levels = maxLevels;
end; 

%calculate the proper gaussian filter according to the filterSize 
   gussianFilter = [1 1];
    for i = 1 : filterSize - 2
        gussianFilter = conv2(gussianFilter, [1 1]);
    end
    % normalization
    filter = gussianFilter ./ sum(gussianFilter(:));

 pyr = cell(levels, 1);
 pyr{1} = im;
 currIm = im;
 
 for i = 2 : levels
    blcurrIm = conv2(currIm, filter, 'same');
    blcurrIm = conv2(currIm, filter', 'same');
    pyr{i, 1} = downsample(downsample(blcurrIm, 2)',2)';
    pyr{i, 1};
    currIm = pyr{i, 1};
 end 
end