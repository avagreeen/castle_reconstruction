clear all
addpath('/usr/local/MATLAB/R2018a/toolbox/vision/vision/');
run('/home/xin/Course/Q3Q4/Compter Vision/A2/VLFEATROOT/VLFEATROOT/toolbox/vl_setup')
%% load images
cd('modelCastlePNG')
imgs=dir;
image={};
NF = length(imgs);
% store the grayscal images
for i =3: NF
    img = imread(imgs(i).name);
    img = rgb2gray(img);
    image = [image,img];
end
fr = size(image,2);
% store the color images
image_color={};
for i =3:NF
    img = imread(imgs(i).name);
    image_color = [image_color,img];
end
cd ..
disp('load images is finished.');
%% keypoint detection (get SIFT descriptors)
des={};
loc={};
for i=1:length(image)
    [loc1,des1] = vl_sift(single(image{i}),'Levels',5,'PeakThresh',1.2);
    des = [des, des1];
    loc = [loc, loc1(1:2,:)];
end
disp('find feature is finished.');
%% chaining & matching (compute point view matrix)
% add first three row to the end
% so the last row can make comparison with them
for i =1:3
    des=[des,des{i}];
    loc=[loc,loc{i}];
end

point_view_matrix=zeros(1,1);
for i = 1:length(des)
    
    if i == length(des)
        break;
    else
        des1 = des{i};
        des2 = des{i+1};
        loc1 = loc{i};
        loc2 = loc{i+1};   
    end
    matches = get_inliers(des1,des2,loc1,loc2,150);  % Normalized 8-point RANSAC
    if i ==1
        point_view_matrix(1,1:size(matches,2))=matches(1,:)';
        point_view_matrix(2,1:size(matches,2))=matches(2,:)';
        tmp = size(point_view_matrix,2);
        
    else
        % find intersect and add it to a new row
        matches_in_last_row=point_view_matrix(i,:);
        [none,IA,IB] = intersect(matches(1,:)',matches_in_last_row);
        point_view_matrix(i+1,IB)=matches(2,IA);
        
        %find new match and add it to new columns;
        [none,IM]=setdiff(matches(1,:)',matches_in_last_row);
        num_new_row=length(IM)+size(point_view_matrix,2);
        new_matches=matches(:,IM);
        point_view_matrix(i:i+1,num_new_row-length(IM)+1:num_new_row)=new_matches;
        
    end
    
end
disp('point_view_matrix is finished.');



%% stiching
% divide the point view matrix
all_M = [];
all_S_cell = {};
M_f={};
S_f={};
all_points = cell(fr,1);
for i = 1:fr
    Points = find_points(point_view_matrix, loc, i, i + 2);
    [M, S]= sfm(Points);  
    all_points{i} = Points(1:2,:);
    all_M = [all_M; M];
    all_S_cell = [all_S_cell; S];
    % apply local bundle adjustment
    [BA_M,BA_S] = BA(M,S,Points);
    M_f{i}=BA_M;
    S_f{i}=BA_S;
%     if isempty(S)
%     else
%         plot3(S(1,:),S(2,:),S(3,:),'.g');
%         hold on;
%     end
end


% find common points
common_Points = find_common_points(point_view_matrix);

% use the first frame as the reference
% and transform others
threeD_points_f = S_f{1};
Z = S_f{1};
fr_points_f = {};

for i = 2: fr
    m1 = Z(:,common_Points{i-1}(1,:));
    m2 = S_f{i}(:,common_Points{i-1}(2,:));
    [D, Z, Trans] = procrustes(m1',m2');
    Z =  (Trans.b * S_f{i}' * Trans.T) + Trans.c(1,:);
    Z = Z';
    threeD_points_f = [threeD_points_f Z];
    fr_points_f = [fr_points_f Z];
end

disp('stiching is finished.');
%% Plot 3D points after local BA

% find the RGB value
all_color_f = [];
for i = 1: fr
    cls = reshape(image_color{i}, [size(image_color{i}, 1) * size(image_color{i}, 2), 3]);
    colorIdx = sub2ind([size(image_color{i}, 1), size(image_color{i}, 2)], floor(all_points{i}(2,:)),round(all_points{i}(1,:)));
    all_color_f = [all_color_f; cls(colorIdx, :)];
end

% plot the pointcloud
figure;
ptCloud_f = pointCloud(threeD_points_f','Color',all_color_f);
pcshow(ptCloud_f, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', 'MarkerSize', 45);
%%
surfaceRender(fr_points_f{1}', all_M(1:6,:), [], image{1});
%%
% Point cloud
pointcloud = fr_points_f{1};
pointcloud = unique(pointcloud', 'rows')';
X = pointcloud(1,:)';
Y = pointcloud(2,:)';
Z = pointcloud(3,:)';

% Projection matrix and camera
M = all_M(1:6,:);
M = M(1:2,:);

viewdir = cross(M(1,:), M(2,:));
viewdir = viewdir/sum(viewdir);
viewdir = viewdir'.*300;

% Remove points further than mean
mx = mean(X);
my = mean(Y);
mz = mean(Z);
m = [mx;my;mz];

x0 = [X';Y';Z'];
x1 = repmat(viewdir, 1, size(x0,2));
x2 = repmat(m, 1, size(x0,2));

% Centre point cloud around zero and use dot product to remove everything
% behind the mean
indices = find(dot(x0-x2,x1)<0);
X(indices) = [];
Y(indices) = [];
Z(indices) = [];
%%
% Grid to create surface on
ti = 0:5:400;
[qx,qy] = meshgrid(ti,ti);

% Surface generation
F = TriScatteredInterp(X,Y,Z);
qz = F(qx,qy);

% Color selection from view
qxrow = reshape(qx, 1, prod(size((qx))));
qyrow = reshape(qy, 1, prod(size((qy))));
qzrow = reshape(qz, 1, prod(size((qz))));

xy2 = M * [qxrow; qyrow; qzrow];
xi2 = xy2(1,:)%+Mean(1);
yi2 = xy2(2,:)%+Mean(2);

xi2(isnan(xi2))=1;
yi2(isnan(xi2))=1;
xi2(isnan(yi2))=1;
yi2(isnan(yi2))=1;

img = image_color{1};
figure;
if(size(img,3)==3)
    imgr = img(:,:,1);
    imgg = img(:,:,2);
    imgb = img(:,:,3);
    Cr = imgr(sub2ind(size(imgr), round(yi2), round(xi2)));
    Cg = imgg(sub2ind(size(imgg), round(yi2), round(xi2)));
    Cb = imgb(sub2ind(size(imgb), round(yi2), round(xi2)));
    qc(:,:,1) = reshape(Cr,size(qx));
    qc(:,:,2) = reshape(Cg,size(qy));
    qc(:,:,3) = reshape(Cb,size(qz));
else
    C = img(sub2ind(size(img), round(yi2), round(xi2)));
    qc = reshape(C,size(qx));
    colormap gray
end

% Display surface
surf(qx, qy, qz, qc);
%% 
% Render parameters
axis( [-500 500 -500 500 -500 500] );
daspect([1 1 1]);
rotate3d;

shading flat;
campos(viewdir);