%my exampels to panorama: it take a 1 minute to run them(each).
% i failed to make it faster...
tic;
numFrames = 2;
inpPathFormat = '/Users/Liat Ginosar/Desktop/cs/impr/exers/ex4/salon%d.jpg'; 
outPath = '/Users/Liat Ginosar/Desktop/cs/impr/exers/ex4/out.jpg';
renderAtFrame = 1;
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;

tic;
numFrames = 2;
inpPathFormat = '/Users/Liat Ginosar/Desktop/cs/impr/exers/ex4/garden%d.jpg'; 
outPath = '/Users/Liat Ginosar/Desktop/cs/impr/exers/ex4/out.jpg';
renderAtFrame = 1;
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;
tic;
