function [] = surfaceRender(pointcloud, M, Mean, img)
% Point cloud
pointcloud = unique(pointcloud', 'rows')';
X = pointcloud(1,:)';
Y = pointcloud(2,:)';
Z = pointcloud(3,:)';

% Projection matrix and camera
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

% Grid to create surface on
ti = -700:2.5:700;
[qx,qy] = meshgrid(ti,ti);

% Surface generation
F = TriScatteredInterp(X,Y,Z);
qz = F(qx,qy);

% Color selection from view
qxrow = reshape(qx, 1, prod(size((qx))));
qyrow = reshape(qy, 1, prod(size((qy))));
qzrow = reshape(qz, 1, prod(size((qz))));

xy2 = M * [qxrow; qyrow; qzrow];
xi2 = xy2(1,:)+Mean(1);
yi2 = xy2(2,:)+Mean(2);

xi2(isnan(xi2))=1;
yi2(isnan(xi2))=1;
xi2(isnan(yi2))=1;
yi2(isnan(yi2))=1;

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
 
% Render parameters
axis( [-500 500 -500 500 -500 500] );
daspect([1 1 1]);
rotate3d;

shading flat;
campos(viewdir);





end