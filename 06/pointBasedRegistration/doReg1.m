clear all;
close all;
clc;
load X.mat;
load -ascii PhantomPointsLeft.mat;
PhantomPointsLeft = PhantomPointsLeft';
load -ascii PhantomPointsRight.mat;
PhantomPointsRight = PhantomPointsRight';
Y = [PhantomPointsLeft, PhantomPointsRight];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find initial transformation via mean and Principal Component Analysis:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (1) calculate the mean of X and save result in Xmean:
Xmean = mean(X,2);
Ymean = mean(Y,2);

% (2) demean X and save result in Xtilde:
Xtilde= X-Xmean*ones(size(X(1,:)));
% (3) demean Y and save result in Ytilde:
Ytilde= Y-Ymean*ones(size(Y(1,:)));

% (4) compute covariance matrix of X,Y and get principal components:
% call princ. comp. of X Rx 
% and princ. comp. of Y Ry
[Rx Sx Vx]= svd(Xtilde*Xtilde')
princomp(Xtilde*Xtilde')