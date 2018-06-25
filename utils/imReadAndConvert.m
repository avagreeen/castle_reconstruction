function [image] = imReadAndConvert( filename, representation )
%reads a given image file and converts it into a given representation
% when representation 1 means grayscale image and representation 2 
% means RGB image

image = double(imread(filename)) / 255;
info = imfinfo(filename);
colorType = info.ColorType;
isGray = strcmp(colorType, 'grayscale');
if representation == 1 && isGray == 0;
    image = rgb2gray(image);
end
end