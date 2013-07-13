function [Dxx,Dxy,Dyy] = Hessian2D(I,Sigma)

% Make kernel coordinates
[X,Y]   = ndgrid(-round(3*Sigma):round(3*Sigma));

% Build the gaussian 2nd derivatives filters
DGaussxx = 1/(2*pi*Sigma^4)*(X.^2/Sigma^2 - 1).*exp(-(X.^2 +Y.^2)/(2*Sigma^2));
DGaussxy = 1/(2*pi*Sigma^6)*(X.*Y).*exp(-(X.^2 +Y.^2)/(2*Sigma^2));
DGaussyy = 1/(2*pi*Sigma^4)*(Y.^2/Sigma^2 - 1).*exp(-(X.^2 +Y.^2)/(2*Sigma^2));

Dxx = imfilter(I,DGaussxx,'conv');
Dxy = imfilter(I,DGaussxy,'conv');
Dyy = imfilter(I,DGaussyy,'conv');

end