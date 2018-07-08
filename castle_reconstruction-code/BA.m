function [ BA_M, BA_S ] = BA( M,S,Points )
% BA Summary of this function goes here
% Input
% M - motion matrix
% S - shape matrix
% Points - measurement matrix
% Output
% BA_M - motion matrix after bundle adjustment
% BA_S - shape matrix after bundle adjustment
N_cam=length(M)/2;
N_pt = length(S);

center = Points-repmat(mean(Points,2),1,size(Points,2));

m=reshape(M,[1,N_cam*6]);
n=reshape(S,[1,N_pt*3]);

MS_0 = [m,n];  %set starting point

options = optimoptions('lsqnonlin','Display','iter','UseParallel',true,...
                          'Algorithm','levenberg-marquardt');
                      
f = @(x)get_error(center, x, N_cam, N_pt);  
MS= lsqnonlin(f,MS_0, [], [], options);  % minimize the error

BA_M = reshape(MS(1:N_cam*6),[N_cam*2,3]);  % restore M,S
BA_S = reshape(MS(end-N_pt*3+1:end), [3, N_pt]);
end

