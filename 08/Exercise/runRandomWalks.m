%   Random Walks for Image Segmentation - Example
%   
%   Author: Athanasios Karamalis
%   Date: 08.05.2013
%   CAMP II - Advanced Image Segmentation
%
%   Based on the paper:
%   Leo Grady, "Random Walks for Image Segmentation", IEEE Trans. on Pattern 
%   Analysis and Machine Intelligence, Vol. 28, No. 11, pp. 1768-1783, 
%   Nov., 2006.
%   
%   Available at: http://www.cns.bu.edu/~lgrady/grady2006random.pdf
%   Original code available at http://cns.bu.edu/~lgrady/software.html


% clear all
clc; clear all; close all;

% Load image
A = im2double(imread('CTAbdomen.png'));

% Manual are static (from file) seed placement
isManualSeeding = false;

if(isManualSeeding)
    h = figure; imagesc(A); colormap gray;
    % Place foreground seeds manually
    title('Place foreground seeds manually')
    [ seedF labelF ] = drawSeeds(h,size(A),1);
    % Place background seeds manually
    title('Place background seeds manually')
    [ seedB labelB ] = drawSeeds(h,size(A),2);
    % Close image for now
    close(h);

    % Create vectors of seeds and labels for Random Walks
    seeds = [seedF; seedB];
    labels = [labelF; labelB];
else
    % Alternatively, load seeds from files
    [ seeds labels ] = loadStaticSeeds();
end

% Show seeds

showSeeds(A,seeds,labels)

% Solve random walks problem
[probabilities mask] = solveRw( A,seeds,labels,90);

% Show segmentation result
showSegOutlineMorph( A, mask, 1 );