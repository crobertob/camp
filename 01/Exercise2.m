%% Computer Aided Medical Procedures II - Summer 2012
%% Exercise Sheet 1
%% Exercise 2: Basic image processing

clear all;
close all;

% a) Use the function imread to load the image mrihead.jpg and 
% store it in the variable im.
im = imread('mrihead.jpg');

% b) Use the function imshow to visualize this image. 
% Next open a new figure-window (using figure) and try to obtain the 
% same visualization with the function imagesc - you will also need the
% functions colormap and axis.

imshow(im);

mriFig = figure('Name', 'MRI','NumberTitle','off');
imagesc(1:175, 1:225,im);
axis([0 225 0 225]);
axis off;
colormap('Gray');

% c) Now visualize only the upper left quarter of the image in the range [100,150].
mriUL = figure('Name', 'MRI UL','NumberTitle','off');
imagesc(1:350,1:450,im);
axis([0 225 0 225]);
axis off;
colormap('Gray');


% d) The MATLAB image processing toolbox provides you with some functions
% for histogram equalization which can improve the contrast of the image.
%     Use the function adapthisteq in order improve the contrast of your image.
mriHist = figure('Name', 'MRI with adapthisteq','NumberTitle','off');
imagesc(1:175, 1:225,adapthisteq(im));
axis([0 225 0 225]);
axis off;
colormap('Gray');

% e) Unfortunately the histogram equalization enhances also the noise. 
% Find out how to smooth your images with a Gaussian filter by typing help 
% imfilter. Don’t forget to use to option ’replicate’.
mriFilt = figure('Name', 'Filtered MRI','NumberTitle','off');
filter = fspecial('gaussian', [4 4], 1);
imagesc(1:175, 1:225, imfilter(adapthisteq(im), filter ,'replicate'));
axis([0 225 0 225]);
axis off;
colormap('Gray');

% f) Open a new figure and visualize the difference between the original image
% and the enhanced image. Do not forget to convert both images to double (double( )).
origImage = double(im);
newImage = double(imfilter(adapthisteq(im), filter));
mriDiff = figure('Name', 'MRI Differences','NumberTitle','off');
imagesc(1:175, 1:225, origImage - newImage);
axis([0 225 0 225]);
axis off;
colormap('Gray');
