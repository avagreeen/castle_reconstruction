function displayMatches(im1,im2,pos1,pos2,inliers)
% DISPLAYMATCHES Display matched pt. pairs overlayed on given image pair.
% Arguments:
% im1,im2 - two grayscale images
% pos1,pos2 - nx2 matrices containing n rows of [x,y] coordinates of matched
% points in im1 and im2 (i.e. the i’th match’s coordinate is
% pos1(i,:) in im1 and and pos2(i,:) in im2).
% inliers - A kx1 vector of inlier matches (e.g. see output of
% ransacHomography.m)
    [rows, cols] = size(im1);
    numOfMatches = size(pos1, 1);
    images = cat(2, im1, im2);
    imshow(images);
    hold on;
    plot(pos1(:,1), pos1(:,2), 'r.');
    plot( cols + pos2(:,1),  pos2(:,2), 'r.');
    pos2(:,1) = pos2(:,1) + cols;

    for i = 1:numOfMatches
        if (ismember(i, inliers) == 0)
            p1 = [pos1(i, 1), pos2(i, 1)];
            p2 = [ pos1(i, 2), pos2(i, 2)];
            plot(p1, p2, 'b-');
        end
    end

    for i = 1:numOfMatches
        if (ismember(i, inliers) == 1)
          p1 = [pos1(i, 1), pos2(i, 1)];
          p2 = [ pos1(i, 2), pos2(i, 2)];
          plot(p1, p2, 'y-');
        end
    end
    hold off;

end
