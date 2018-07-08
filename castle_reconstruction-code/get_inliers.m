function [ matches ] = get_inliers( des1,des2,loc1,loc2 ,inlierTol)
%GET_INLIERS Summary of this function goes here
%  Input:   
%  des: descriptor
%  loc: location
%  Output: 
%  the matches index
numIter=1000;

matched = vl_ubcmatch(des1,des2);
m_loc1=loc1(1:2,matched(1,:));   % get the coordinates
m_loc2=loc2(1:2,matched(2,:));
[H,inliers]=ransac_inlier(m_loc1',m_loc2',numIter,inlierTol); % return H and index of inlier pairs
    
matches = matched(:,inliers);
end

