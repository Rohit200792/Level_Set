function [phi,tr] = Level_Set(im,max_iter,del_t,r0,c0)
% Level_Set - level set of image
% On input:
%   im (MxN array): gray level or binary image
%   max_iter (int): maximum number of iterations
%   del_t (float): time step
%   r0 (int): row center of circular level set function
%   c0 (int): column center of circular level set function
% On output:
%   phi (MxN array): final phi array
%   tr (qx1 vector): sum(sum(abs(phi_(n+1) - phi_n)))
% Call:
%   [phi,tr] = Level_Set(im,300,0.1,25,25);
% Author:
%   Rohit Singh
%   UU
%   Fall 2018
%
[H, W] = size(im);
phi = zeros(H,W);
tr = zeros(max_iter,1);
for row = 1:H
    for col = 1:W
        phi(row,col) = sqrt((row-r0)^2 + (col-c0)^2 ) - 2;
    end
end
[gradx, grady] = gradient(double(im));
F = exp(-sqrt(gradx.^2 + grady.^2));
maxF=max(max(F));
for row = 1:H
    for col= 1:W
        if F(row,col) < maxF/20
            F(row,col)=0;
        end
    end
end
phi_n1= phi;
for iter = 1:max_iter
    for row = 2:H-1
        for col = 2:W-1
            Dx_p = phi(row+1,col) - phi(row,col); 
            Dx_n = phi(row,col) - phi(row-1,col);
            Dy_p = phi(row,col+1) - phi(row,col); 
            Dy_n = phi(row,col) - phi(row,col-1);
            grad_phi_p = sqrt(max(Dx_n,0)^2 + min(Dx_p,0)^2 + ...
                max(Dy_n,0)^2 + min(Dy_p,0)^2);
            grad_phi_n = sqrt(min(Dx_n,0)^2 + max(Dx_p,0)^2 + ...
                min(Dy_n,0)^2 + max(Dy_p,0)^2);
            phi_n1(row,col) = phi(row,col) - (del_t*((...
                (max(F(row,col),0))*grad_phi_p) + ...
                min(F(row,col),0)*grad_phi_n));
        end
    end
    tr(iter) = sum(sum(abs(phi_n1-phi)));
    phi = phi_n1;
    %combo(mat2gray(double(im)),phi<0);    
end

%combo(mat2gray(double(im)),phi<0); %use combo to view segmented region

%im=rgb2gray(imread('C:\Users\Rohit Singh\OneDrive\MSCS\CS6640 Image
 %Processing\Practise\IMG6.jpg'));
