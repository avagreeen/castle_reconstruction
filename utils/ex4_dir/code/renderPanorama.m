function panorama = renderPanorama(im,H)
% RENDERPANORAMA Renders a set of images into a combined panorama image.
% Arguments:
% im - Cell array of n grayscale images.
% H - Cell array of n 3x3 homography matrices transforming the ith image
% coordinates to the panorama image coordinates.
% Returns:
% panorama - A grayscale panorama image composed of n vertical strips that
% were backwarped each from the relevant frame im{i} using homography H{i}.

imSize = length(im);

%initializing the corners coordinates
yMin = Inf;
yMax = -Inf;
xMin = Inf;
xMax = -Inf;

%calculates the panorama borders
for i = 1:length(H) 
    currIm = im{i};
    [rows, cols] = size(currIm);
    %corners is a vector of the top-left, top-right and
    %bottom-right bottom left coordinates 
    corners = [1, 1; cols, 1; cols, rows; 1, rows]; % 4X2
    positions = applyHomography(corners, H{i}); %4X2
    
    if(yMin > min(positions(:, 2)))
        yMin = min(positions(:, 2));   
        
    end
    
    if(yMax < max(positions(:, 2)))
        yMax = max(positions(:, 2));  
        
    end

    if(xMin > min(positions(:, 1)))
        xMin = min(positions(:, 1)); 
        
    end

    if(xMax < max(positions(:, 1)))
        xMax = max(positions(:, 1));      
    end
end

% create the panorama canvas
xMax = ceil(xMax);
yMax = ceil(yMax);
xMin = floor(xMin);
yMin = floor(yMin);
r = yMax - yMin + 1;
c = xMax - xMin + 1;
panorama = zeros(r, c);

Hpano = [1 0 xMin; 0 1 yMin; 0 0 1];

% fill in the panorama
% holds the coordinates of the panorama pixels.
backWarpedH = {};
Ipano = zeros(r, c); %matrix of the intensities

%calculate the images centers. warped space
for i = 1:length(H)
    [rIm, cIm] = size(im{i});        
    center = round([cIm, rIm] / 2);   
    newCenter = applyHomography(center, H{i});
    newCenter = newCenter - xMin + 1;
    centersX(i) = round(newCenter(1));    
end
%define the vector of the strips borders coordinates. warped space
for i = 1:length(centersX) - 1;
    strips(i) = (centersX(i) + centersX(i + 1)) / 2; 
    strips(i) = round(strips(i));
end

for i = 1:length(H) 
    %warped space
    [x,y] = meshgrid(xMin:xMax, yMin:yMax); % (yMax-yMin+1) X (xMax - xMin +1)
    x = x(:); % (yMax-yMin+1) * (xMax - xMin +1) X 1
    y = y(:);  % (yMax-yMin+1) * (xMax - xMin +1) X 1
    pos = cat(2, x, y);  % (yMax-yMin+1) * (xMax - xMin +1) X 2
    backWarpedPositions = applyHomography(pos, inv(H{i})); 
    
    backWarpedPositions1 = reshape(backWarpedPositions(:, 1), yMax - yMin + 1, xMax - xMin + 1);
    backWarpedPositions2 = reshape(backWarpedPositions(:, 2), yMax - yMin + 1, xMax - xMin + 1);
    Ipano = interp2(im{i}, backWarpedPositions1, backWarpedPositions2); 
    Ipano(isnan(Ipano)) = 0;
    
    if( i == 1 )
        panorama = Ipano;
    end
    
    if( i ~= 1 )
        mask = zeros(r,c);
        
        if( i == length(H) )
            mask(:,strips(i-1):end) = 1;
            
        else
            mask(:,strips(i-1):strips(i)-1)= 1;
        end
        
        newIm = Ipano;
        %pyramid blending
        panorama = pyramidBlending(newIm, panorama, mask, 7, 7, 7);              
    end          
end

end