% performs blurring in the image space
function[blurImage] = blurInImageSpace(inImage, kernelSize)
   %calculate the proper kernel according to the kernelSize  
   kernelVec = ones(2);
   for i = 1 : kernelSize
       kernelVec = conv2(kernelVec, kernelVec, 'same');
   end
   kernel = conv2(kernelVec, kernelVec', 'same');
   kernel = kernel ./ sum(kernel(:));
   %zero padding
   blurImage = conv2(inImage, kernel, 'same');
end