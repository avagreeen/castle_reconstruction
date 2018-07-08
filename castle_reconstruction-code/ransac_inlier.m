function [H,inliers] = ransac_inlier(pos1,pos2,numIters,inlierTol)
% Fit homography to maximal inliers using the RANSAC algorithm.
% Input:
% pos1,pos2: nx2 matrices containing n rows of matched points.
% numIters: Number of RANSAC iterations.
% inlierTol: inlier tolerance threshold.
% Output:
% H: A 3x3 normalized homography matrix.
% inliers: A kx1 vector where k is the number of inliers, containing the 
% indices in pos1/pos2 of the maximal set of inlier matches found

bestH = [];
maxAgreement = 0;
n = size(pos1, 1);

    for i = 1:numIters
        % pick a random set of 8 point matches from matches 
        randomRows = randsample(n, 8, false); 

        matches1 = pos1(randomRows, :);
        matches2 = pos2(randomRows, :);

        H = eightpointransac(matches1,matches2);  % compute the homography H 
        if isempty(H)
            continue;
        end
        % use H to transform pos1
        homo = H * ([pos1, ones(size(pos1, 1), 1)].');
        H_pos1 = (homo(1 : 2, :) ./ repmat(homo(3, :), [2, 1])).';

        e1  = (H_pos1 - pos2) .^ 2;  % calculate err of transformed pos1 and pos2
        e2 = sum(e1');
        E = sqrt(e2);
        E(E > inlierTol) = 0;       % selecte based on threshold
        num_of_nonezero = size(find(maxAgreement)', 1);
        
        temp_zero = size(find(E)', 1);
        
        if( num_of_nonezero < temp_zero)
            maxAgreement = E;
            bestH = H;
        end 
    end
    
   H = bestH;
   inliers = find(maxAgreement); 
end
