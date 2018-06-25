%my exampels to panorama

tic;
numFrames = 2;
inpPathFormat = '../data/inp/mine/salon%d.jpg';
	outPath = '../data/out/salon.jpg';
renderAtFrame = 1;
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;

tic;
numFrames = 2;
inpPathFormat = '../data/inp/mine/garden%d.jpg';
	outPath = '../data/out/garden.jpg';
renderAtFrame = 1;
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;
tic;
