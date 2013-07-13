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
[s1, s2] = size(Image);

%% Filter the image with a Gaussian filter
Image = convn(Image,fspecial('gaussian'));
fig = figure; imagesc(Image,[0 1]); axis image; colormap gray;axis off; ...
    axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% A. Basic Edge detection

%% 1. Compute the Magnitude of the gradient
[grad_x, grad_y] = gradient(Image);
M = sqrt(grad_x.^2+grad_y.^2);

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
Mn = M; %% Initialize the image with supressed non maxima edges
%% a. Compute the gradient direction
alpha = atan(grad_y./grad_x);
figure(fig+2); imagesc(alpha); axis image; colormap jet; axis off; ...
    title('Gradient Direction'); axis xy; colorbar
a = [0 45 90 135 180]; %% The 4 basic gradient directions (0=180)

alpha_b=zeros(s1,s2);
for i = 2:s1-1
    for j = 2:s2-1
        %% Compute the nearest basic direction to the local gradient
        %% direction
        angle = rad2deg(alpha(i,j));
        if(angle<0)
            angle = angle+180;
        end
        [difference, nearest] = min(abs(angle-a));  %nearest is the index to closes angle
        
        %% Just say that 0 and 180 should have the same index
        if nearest==5
            alpha_b(i,j) = 1;
        else
            alpha_b(i,j) = nearest;
        end
        
        %% Get the two neigbors in opposite directions
        % (4 possibilities)
        %0 deg
        if alpha_b(i,j) == 1
            nd = [i j-1];
            ng = [i j+1];
        %45 deg
        elseif alpha_b(i,j) == 2
            nd = [i+1 j+1];
            ng = [i-1 j-1];
        %90 deg
        elseif alpha_b(i,j) == 3
            nd = [i+1 j];
            ng = [i-1 j];
        %135 deg
        elseif alpha_b(i,j) == 4
            nd = [i+1 j-1];
            ng = [i-1 j+1];
        end
        %% And check if the gradient magnitude is is smaller than the
        %% gradient magnitude of one of its neighbours in the chosen
        %% direction. In this case, set it to zero in Mn.
        if M(nd(1),nd(2))>M(i,j)|| M(ng(1),ng(2))>M(i,j)
            Mn(i,j)=0;
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
Th = 0.12;               %% high treshold
StrongPixel = Mn > Th; %% Strong pixel map
% Create the weak pixel map
Tl = 0.04;               %% low treshold
WeakPixel = Mn > Tl - StrongPixel;
% Display
figure(fig+4); imagesc(StrongPixel); axis image; colormap gray; axis off; ...
    title('Strong Pixel'); axis xy
figure(fig+5); imagesc(WeakPixel); axis image; colormap gray; axis off; ...
    title('Weak Pixel'); axis xy

% Find the connected component (8-connectivity, use the function bwlabel)
[C, labels]= bwlabel(StrongPixel|WeakPixel,8);

% Compute the final edge map "EdgeCanny"
EdgeCanny = zeros(size(M)); %% Initialize

% For every connected component, check if oone of the pixels is a "strong
% pixel". In this case, set the whole component to be an edge
for k = 1:labels
     if max(max((C==k)&(StrongPixel==1)))>0 %there is a strong pixel in K
         EdgeCanny = EdgeCanny|(C==k); %add component
     end
end

% Display
figure(fig+6); imagesc(EdgeCanny); axis image; colormap gray; axis off; axis xy;...
    title('Final Canny output');


