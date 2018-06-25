function [ind1,ind2] = matchFeatures(desc1,desc2,minScore)
% MATCHFEATURES Match feature descriptors in desc1 and desc2.
% Arguments:
% desc1 - A kxkxn1 feature descriptor matrix.
% desc2 - A kxkxn2 feature descriptor matrix.
% minScore - Minimal match score between two descriptors required to be
% regarded as matching.
% Returns:
% ind1,ind2 - These are m-entry arrays of match indices in desc1 and desc2.
%
% Note:
% 1. The descriptors of the ith match are desc1(ind1(i)) and desc2(ind2(i)).
% 2. The number of feature descriptors n1 generally differs from n2
% 3. ind1 and ind2 have the same length.

shiftDesc1 = shiftdim(desc1, 2);
shiftDesc2 = shiftdim(desc2, 2);

% the score matrix s , S[j, k] = D[i,j] * D[i+1,k]
s = shiftDesc1(:,:) * shiftDesc2(:,:).';

% we have to check that 3 conditions hold in order to declare a match:
m = s;
% S[j,k] >= 2 max cells among {S[j,1],S[j,2],...,S[j,f1]}
maximumInRows = find2MaxEveryCol(m')';
% S[j,k] >= 2 max cells among {S[l,k],S[2,k],...,S[f0,k]}
maximumInColumns = find2MaxEveryCol(m);

% S[j,k] > minScore
s(s >= minScore) = 1;
s(s < minScore) = 0;

matches =  s .* maximumInRows .* maximumInColumns; 

[ind1, ind2] = find(matches);

end