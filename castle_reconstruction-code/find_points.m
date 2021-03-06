function Points = find_points(point_view_matrix, loc, fr_num1, fr_num2)
% take the block that is consist of three adjacent images from the point-view-matrix
% Input
% point_view_matrix
% loc - the location of features
% fr_num1, fr_num2 - frame number
% Output
% Points - measurement matrix of the block
[fr, length] = size(point_view_matrix);
len = -fr_num1 + fr_num2 + 1;
pointsx = zeros(len, length);
pointsy = zeros(len, length);
Points = zeros(len*2, length);
fr_num = [1:fr 1 2];
for i = fr_num1: fr_num2
     matrix = point_view_matrix(fr_num(i),:);
     idx = matrix(matrix ~= 0);
     pointsx(i + 1 - fr_num1,find(matrix)) = loc{fr_num(i)}(1, idx)';
     pointsy(i + 1 - fr_num1,find(matrix)) = loc{fr_num(i)}(2, idx)';
end
% store x and y locations together
Points(1:2:end,:)=pointsx;
Points(2:2:end,:)=pointsy;

% Find features not visible in all frames
not_all_frames = ~all(Points, 1);

% Delete those features
Points(:, not_all_frames) = [];
end