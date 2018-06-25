function [img] = LaplacianToImage(lpyr ,filter, coeffMultVec)
img = [];    
coeffSize = size(coeffMultVec);
pyrSize = size(lpyr);    
pyrSize = pyrSize(1);
img = lpyr{pyrSize} * coeffMultVec(pyrSize);
for i = (pyrSize - 1):-1:1
   expanded = Expand(img, filter);
   rows = size(lpyr{i}, 1);
   cols = size(lpyr{i}, 2);
   img = expanded(1:rows, 1:cols) + lpyr{i} * coeffMultVec(i);
end
end






