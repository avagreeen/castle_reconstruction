function common_Points = find_common_points(point_view_matrix)
% find the 3D points shared by two different adjacent views
% Input
% point_view_matrix
% Output
% common_Points - the points shared by two different adjacent views
%                 (stored in cell)
[fr, length] = size(point_view_matrix);
common_Points = cell(1,fr);

% find the point in different views
points3 = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 3);
% find the points in four different frame
common_set = point_view_matrix(:,sum((point_view_matrix > 0),1) >= 4);
% add first three row to the end
% so the last row can make comparison with them
fr_num = [1:fr 1 2 3];
for i = 1: fr
    points1 = points3([fr_num(i) fr_num(i+1) fr_num(i+2)], ((points3(fr_num(i),:) ~= 0) & (points3(fr_num(i+1),:) ~= 0) & (points3(fr_num(i+2),:) ~= 0)) );
    points2 = points3([fr_num(i+1) fr_num(i+2) fr_num(i+3)], ((points3(fr_num(i+1),:) ~= 0) & (points3(fr_num(i+2),:) ~= 0) & (points3(fr_num(i+3),:) ~= 0)) );
    commonpoints = common_set([fr_num(i) fr_num(i+1) fr_num(i+2) fr_num(i+3)], ((common_set(fr_num(i),:) ~= 0) & (common_set(fr_num(i+1),:) ~= 0) & (common_set(fr_num(i+2),:) ~= 0) & (common_set(fr_num(i+3),:) ~= 0)) );
    % find unique points 
    [C,IA,IC] = unique(commonpoints(1,:));
    commonpoints = commonpoints(:,IA);
    
    [~, idx1, idx2] = intersect(points1(1,:), commonpoints(1,:));  
    [~, idx3, idx4] = intersect(points2(1,:), commonpoints(2,:)); 
    new_common = zeros(2,size(idx1, 1));
    % find shared points
    for id = 1:size(idx1, 1)
        new_common(1,id) = idx1(idx2 == id);
        new_common(2,id) = idx3(idx4 == id);
    end
    common_Points{i} = new_common;
end
end