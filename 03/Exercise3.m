%% Exercise 3
%% Edge-Based segmentation methods
%% Gradient based / Basic, Canny

%% Clear and close everything
clear all; close all; clc;

%% ----------------------------------------------------------------------%%
%% ---------------------------------------------------------------------%%
%% Load the image
load('Image.mat')
Image = mat2gray(double(Image));
[s1 s2] = size(Image);

%% Filter the image with a Gaussian filter
Image = ??
fig = figure; imagesc(Image,[0 1]); axis image; colormap gray;axis off; ...
    axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% A. Basic Edge detection

%% 1. Compute the Magnitude of the gradient
M = ??

figure(fig+1); imagesc(M); axis image; colormap jet;axis off; ...
    title('Gradient Magnitude'); axis xy

%% Threshold the gradient
EdgeBasic = (M>0.1);
figure(fig+2); imagesc(EdgeBasic); axis image; colormap gray; axis off; ...
    title('Edge - Basic thresholding'); axis xy

disp('1 - pause')
pause
close(fig+2)


%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% B. CANNY

%% STEP1: Non Maxima suppression step
Mn = Mn; %% Initialize the image with supressed non maxima edges
%% a. Compute the gradient direction
alpha = ??
figure(fig+2); imagesc(alpha); axis image; colormap jet; axis off; ...
    title('Gradient Direction'); axis xy; colorbar
a = [0 45 90 135 180]; %% The 4 basic gradient directions (0=180)
for i = 2:s1-1
    for j = 2:s2-1
        %% Compute the nearest basic direction to the local gradient
        %% direction
        nearest = ??
        
        %% Just say that 0 and 180 should have the same index
        if b==5
            alpha_b(i,j) = 1;
        else
            alpha_b(i,j) = nearest;
        end
        
        %% Get the two neigbors in opposite directions
        % (4 possibilities)
        if ??
            nd = ?
            ng = ?
        elseif ??
            ??
        elseif ??
            ??
        elseif ??
            ??
        end
        %% And check if the gradient magnitude is is smaller than the
        %% gradient magnitude of one of its neighbours in the chosen
        %% direction. In this case, set it to zero in Mn.
        if ??
            ??
        end
        
    end
end

%% Display
figure(fig+3); imagesc(Mn); axis image; colormap jet; axis off; ...
    title('Magnitude after Non maxima suppresion'); axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% STEP2: Hysteresis

% Create the strong pixel map
Th = 0.3;               %% high treshold
StrongPixel = ??        %% Strong pixel map
% Create the weak pixel map
Tl = 0.3;               %% low treshold
WeakPixel = ??
% Display
figure(fig+4); imagesc(StrongPixel); axis image; colormap gray; axis off; ...
    title('Strong Pixel'); axis xy
figure(fig+5); imagesc(WeakPixel); axis image; colormap gray; axis off; ...
    title('Weak Pixel'); axis xy

% Find the connected component (8-connectivity, use the function bwlabel)
C = 

% Compute the final edge map "EdgeCanny"
EdgeCanny = zeros(size(M)); %% Initialize

% For every connected component, check if oone of the pixels is a "strong
% pixel". In this case, set the whole component to be an edge
for k = 1:max(C)
    ??
    ??
    ??
end

% Display
figure(fig+6); imagesc(EdgeCanny); axis image; colormap gray; axis off; axis xy;...
    title('Final Canny output');


