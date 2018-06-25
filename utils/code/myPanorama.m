%my exampels to panorama: it take a 1 minute to run them(each).
% i failed to make it faster...
tic;
numFrames = 2;
inpPathFormat = '../data/inp/examples/salon%d.jpg';
	outPath = '../data/out/examples/salon.jpg';
renderAtFrame = 1;
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;

tic;
numFrames = 2;
inpPathFormat = '../data/inp/examples/garden%d.jpg';
	outPath = '../data/out/examples/garden.jpg';
renderAtFrame = 1;
generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,true);
toc;
pause(2);
close all;
tic;
