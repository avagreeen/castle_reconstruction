function pos2 = applyHomography(pos1,H12)
% APPLYHOMOGRAPHY Transform coordinates pos1 to pos2 using homography H12.
% Arguments:
% pos1 - An nx2 matrix of [x,y] point coordinates per row.
% H12 - A 3x3 homography matrix.
% Returns:
% pos2 - An nx2 matrix of [x,y] point coordinates per row obtained from
% transforming pos1 using H12.
homo = H12 * ([pos1, ones(size(pos1, 1), 1)].');
pos2 = (homo(1 : 2, :) ./ repmat(homo(3, :), [2, 1])).';

end