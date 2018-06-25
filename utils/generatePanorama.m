function panorama = generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,verbose)
% GENERATEPANORAMA Load set of RGB frames and combine them into a single RGB panorama.
%
% Syntax:
% panorama = generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,verbose)
%
% Arguments:
% inpPathFormat - String having the form '/dir1/dir2/name%d.jpg' s.t. the 
%   path to RGB frame i is sprintf('/dir1/dir2/name%d.jpg',i).
% outPath - Path to output panorama RGB image file.
% numFrames - Sets the frame indices ([1:numFrames]) to load.
% renderFrame - Sets the index of the frame towards which the rest of the
%   frames should be warped when rendering the panorama.
%
% Returns:
% panorama - Combined RGB panorama image.

if verbose; 
  disp(' ');
  disp('Generate-Panorama started.'); 
end


ransacNumIters = 1500;
ransacInlierTol = 9;
minMatchScore = 0.33;

% load frames, detect feature point positions and compute their descriptors
if verbose; 
  disp('Loading frames, detecting feature points and computing their descriptors...'); 
end
im = cell(numFrames,1);
pos = cell(numFrames,1);
desc = cell(numFrames,1);
for i=1:numFrames
  im{i} = imReadAndConvert(sprintf(inpPathFormat,i),1);
  pyr = GaussianPyramid(im{i},3,3);
  [pos{i},desc{i}] = findFeatures(pyr);
end

% register homographies between all consecutive frame pairs
if verbose; 
  disp('Registering homographies between all consecutive frame pairs...'); 
end
Hpair = cell(numFrames-1,1);
for i=1:numFrames-1  
  [inda,indb] = matchFeatures(desc{i},desc{i+1},minMatchScore);
  posa = pos{i}(inda,:);
  posb = pos{i+1}(indb,:);
  [Hpair{i},inlind] = ransacHomography(posa,posb,ransacNumIters,ransacInlierTol);
  if verbose
    displayMatches(im{i},im{i+1},posa,posb,inlind);
		drawnow;
  end
end
clear im;
Htot = accumulateHomographies(Hpair, renderAtFrame);

% load RGB images
if verbose; 
  disp('Loading RGB images...'); end
imR = cell(numFrames,1);
imG = cell(numFrames,1);
imB = cell(numFrames,1);
for i=1:numFrames 
  imRGB = imReadAndConvert(sprintf(inpPathFormat,i),2);
  imR{i} = imRGB(:,:,1);
  imG{i} = imRGB(:,:,2);
  imB{i} = imRGB(:,:,3);
end

% render each image channel seperately using Htot
if verbose; 
  disp('Rendering panorama...'); end
panorama(:,:,1) = renderPanorama(imR,Htot); 
panorama(:,:,2) = renderPanorama(imG,Htot);
panorama(:,:,3) = renderPanorama(imB,Htot);

% possibly save panorama
if ~isempty(outPath)
  if verbose; 
    fprintf(1,'Saving panorama to %s...\n',outPath); end
  imwrite(panorama,outPath,'Quality',93);
end

if verbose
  figure,imshow(panorama);
  disp('Done.');
end
