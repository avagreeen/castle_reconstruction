function [imBlend] = pyramidBlending(im1, im2, mask, maxLevels, filterSizeIm, filterSizeMask)

[Gm, ~] = GaussianPyramid(double(mask), maxLevels, filterSizeMask);
[L_1, filter] = LaplacianPyramid(double(im1), maxLevels, filterSizeIm);
[L_2, ~] = LaplacianPyramid(double(im2), maxLevels, filterSizeIm);

pyrSize = length(Gm);
pyr = cell(pyrSize, 1);
    
for i = 1 : pyrSize
    L_i = Gm{i} .* L_1{i} + (1 - Gm{i}) .* L_2{i};
    pyr{i} = L_i;
end
imBlend = LaplacianToImage(pyr, filter, ones(1, pyrSize));

end