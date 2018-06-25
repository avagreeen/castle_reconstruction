imgs=dir;
image={};
for i =3:length(imgs)
    image = [image,imread(imgs(i).name)];
    
end
%%
I=single(rgb2gray(image{1}));

%%
img1 = rgb2gray(image{1});
img2 = rgb2gray(image{2});
img1 = imresize(img1,0.3);
img2 = imresize(img2,0.3);
%% get descriptors and locations
des={};
loc={};
for i=1:length(image)
    img=imresize(rgb2gray(image{i}),0.3);
    [des1,loc1] = getFeatures(img);
    des = [des, des1];
    loc = [loc, loc1];
end
%%
matched = match(des{1},des{2});
drawFeatures(img1,loc{1});
drawFeatures(img2,loc{2});
drawMatched(matched,img1,img2,loc{1},loc{2});
%%
matched =match(des{1},des{2}); 
idx1=find(matched); % the index of matched point in fig1
idx2=matched(idx1); % the corresponding matched index in fig2
loc1=loc{1}(idx1,:);
loc2=loc{2}(idx2,:);
[H12,inliers]=ransacHomography(loc1,loc2,10,10); % return H and index of inlier pairs
m_loc1 = loc1(inliers,:);
m_loc2 = loc2(inliers,:);
%% display SIFT
drawFeatures(img1,m_loc1);
drawFeatures(img2,m_loc2);
%% display matching result
m_idx1=idx1(inliers);
m_idx2=idx2(inliers);
m_matched=zeros(1,length(loc{1}));
m_matched(m_idx1)=m_idx2
drawMatched(m_matched,img1,img2,loc{1},loc{2})