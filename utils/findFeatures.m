function [pos,desc] = findFeatures(pyr)
% FINDFEATURES Detect feature points in pyramid and sample their descriptors.
% This function should call the functions spreadOutCorners for getting the keypoints, and
% sampleDescriptor for sampling a descriptor for each keypoint
% Arguments:
% pyr - Gaussian pyramid of a grayscale image having 3 levels.
% Returns:
% pos - An Nx2 matrix of [x,y] feature positions per row found in pyr. These
% coordinates are provided at the pyramid level pyr{1}.
% desc - A kxkxN feature descriptor matrix.

    pyrSize = length(pyr);
    pos = [];
    desc = [];
    for i = 1:pyrSize
        tempPos = spreadOutCorners(pyr{i}, 4, 4, 3);
        % converts between the position we got from the pyr to points 
        % that fit to level 3 in the pyramid
        changedPos = ((2 ^ (i - pyrSize)) .* (tempPos - 1)) + 1;
        tempDesc = sampleDescriptor(pyr{3}, changedPos, 3);
        desc = cat(3, desc, tempDesc);
        changedPos2 = ((2 ^ (i - 1)) .* (tempPos - 1)) + 1;
        pos = cat(1, pos, changedPos2);
    end
end
