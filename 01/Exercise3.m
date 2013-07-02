%% Computer Aided Medical Procedures II - Summer 2012
%% Exercise Sheet 1
%% Exercise 3: Finite Differences

clear all;
close all;

im = imread('mrihead.jpg');

[dxim, dyim] = grad(double(im));
D = div(dxim, dyim);

manualFilter = figure('Name', 'Manual Laplacian Filter','NumberTitle','off');
imagesc(D);
colormap('Gray');

matlabFilter = figure('Name', 'Matlab Laplacian filter','NumberTitle','off');
imagesc(imfilter(im, [0 1 0; 1 -4 1; 0 1 0], 'replicate'));
colormap('Gray');

diffFilters = figure('Name', 'Difference between filters','NumberTitle','off');
imagesc(D  - imfilter(double(im), [0 1 0; 1 -4 1; 0 1 0], 'replicate'));
colormap('Gray');
