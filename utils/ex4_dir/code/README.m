liat_gin
README 
  
matlab version: R2012a
plattform: Windows 7 64 bit
list of files:

HarrisCornerDetector.m - Extract key points from the image.

sampleDescriptor.m - Sample a MOPS-like descriptor at given positions in the image.

findFeatures.m - Detect feature points in pyramid and sample their descriptors.

matchFeatures.m - Match feature descriptors in desc1 and desc2.

applyHomography.m - Transform coordinates pos1 to pos2 using homography H12.

ransacHomography.m - Fit homography to maximal inliers given point matches
                     using the RANSAC algorithm.
                     
find2MaxEveryCol.m -  finds 2 maximum numbers in every col in the given matrix 
                      and saves their indices.return binaryMatrix: if there 
                      is a maximum in the (i,j) cell matrix(i, j) = 1 otherwise
                      matrix(i, j) = 0
                      
displayMatches.m - Display matched pt. pairs overlayed on given image pair.

accumulateHomographies.m - Accumulate homography matrix sequence. 

renderPanorama.m - Renders a set of images into a combined panorama image.

myPanorama.m - this file shows my exampels of  panoramas.



function from last exercises:
-----------------------------
imReadAndConvert.m - function from ex1
blurInImageSpace.m - function from ex2
GaussianPyramid.m - function from ex3
LaplacianPyramid.m - function from ex3 
LaplacianToImage.m - function from ex3
pyramidBlending.m - function from ex3
Expand.m - function from ex3
README - this file 



