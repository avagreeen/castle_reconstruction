function Htot = accumulateHomographies(Hpair,m)
% ACCUMULATEHOMOGRAPHY Accumulate homography matrix sequence.
% Arguments:
% Hpair - Cell array of M-1 3x3 homography matrices where Hpair{i} is a
% homography that transforms between coordinate systems i and i+1.
% m - Index of coordinate system we would like to accumulate the
% given homographies towards (see details below).
% Returns:
% Htot - Cell array of M 3x3 homography matrices where Htot{i} transforms
% coordinate system i to the coordinate system having the index m.
% Note:
% In this exercise homography matrices should always maintain
% the property that H(3,3)==1. This should be done by normalizing them as
% follows before using them to perform transformations H = H/H(3,3).

    numOfH = length(Hpair) + 1; %M
    Htot = {}; %ends to be M
    acumulateH = eye(3);%3x3
    
    Htot{m} = eye(3);
    
    for i = [m - 1:-1:1]
        acumulateH = acumulateH * Hpair{i};
        Htot{i} = acumulateH ./ acumulateH(3, 3); 
    end
        
    for i=[m+1:numOfH]
      acumulateH = acumulateH * inv(Hpair{i - 1});
      Htot{i} = acumulateH ./ acumulateH(3, 3); 
    end
end