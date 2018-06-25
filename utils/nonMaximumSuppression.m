function [ result ] = nonMaximumSuppression( response )
% Find local maxima of corner metric matrix.

%deal with the frame border
response(1:2,:)=-inf;
response(:,1:2)=-inf;

response(end-1:end,:)=-inf;
response(:,end-1:end)=-inf;

BW = imregionalmax(response,8);
maxResponse=max(response(:));

BW(response<(maxResponse*0.1))=0;
result = bwmorph(BW,'shrink',Inf);

end

