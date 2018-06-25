function [H12,inliers] = ransacHomography(pos1,pos2,numIters,inlierTol)
% RANSACHOMOGRAPHY Fit homography to maximal inliers given point matches
% using the RANSAC algorithm.
% Arguments:
% pos1,pos2 - Two nx2 matrices containing n rows of [x,y] coordinates of
% matched points.
% numIters - Number of RANSAC iterations to perform.
% inlierTol - inlier tolerance threshold.
% Returns:
% H12 - A 3x3 normalized homography matrix.
% inliers - A kx1 vector where k is the number of inliers, containing the 
% indices in pos1/pos2 of the maximal set of
% inlier matches found

bestHomograpy = [];
maxAgreement = 0;
n = size(pos1, 1);

    for i = 1:numIters
        % pick a random set of 4 point matches from the supplied N point matches 
        randomRows = randsample(n, 4, false);
        %randomMatches1
        randomMatches1 = pos1(randomRows, :);
        randomMatches2 = pos2(randomRows, :);
        % compute the homography H12 that transforms the 4 points P1,j to the
        % 4 points P2,j
        H12 = leastSquaresHomography(randomMatches1,randomMatches2);
        if isempty(H12)
            continue;
        end
        % use H12 to transform the full set of points P1 in image 1 to the
        % transformed set P1`
        pos1AfterHomography = applyHomography(pos1, H12);
        % calculate normal
        e1  = (pos1AfterHomography - pos2) .^ 2;
        e2 = sum(e1');
        E = sqrt(e2);
        E(E > inlierTol) = 0;
        sizeOfNonZero = size(find(maxAgreement)', 1);
        sizeOfTempNonZero = size(find(E)', 1);
        if( sizeOfNonZero < sizeOfTempNonZero)
            maxAgreement = E;
            %bestHomograpy
            bestHomograpy = H12;
            %bestHomograpy
        end 
    end
    
   H12 = bestHomograpy;
   inliers = find(maxAgreement); 
end