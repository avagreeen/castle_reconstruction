function [] = callGen()
inpPathFormat = '/Users/Liat Ginosar/Desktop/cs/impr/exers/ex4/garden%d.jpg'; 
outPath = '/Users/Liat Ginosar/Desktop/cs/impr/exers/ex4/out.jpg';
numFrames = 2;
renderAtFrame = 1;
verbose = 1;

panorama = generatePanorama(inpPathFormat,outPath,numFrames,renderAtFrame,verbose);
end