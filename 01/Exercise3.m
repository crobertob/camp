%% Computer Aided Medical Procedures II - Summer 2013
%% Exercise Sheet 1
%% Exercise 3: Finite Differences

clear all;
close all;

im = imread('mrihead.jpg');

[dxim, dyim] = grad(double(im));
D = div(dxim, dyim);

manualFilter = figure('Name', 'Manual Laplacian Filter','NumberTitle','off');
imagesc(1:175, 1:225,D);
axis([0 225 0 225]);
axis off;
colormap('Gray');

matlabFilter = figure('Name', 'Matlab Laplacian filter','NumberTitle','off');
imagesc(1:175, 1:225, imfilter(im, [0 1 0; 1 -4 1; 0 1 0], 'replicate'));
axis([0 225 0 225]);
axis off;
colormap('Gray');

diffFilters = figure('Name', 'Difference between filters','NumberTitle','off');
imagesc(1:175, 1:225, double(D)  - double(imfilter(double(im), [0 1 0; 1 -4 1; 0 1 0], 'replicate')));
axis([0 225 0 225]);
axis off;
colormap('Gray');