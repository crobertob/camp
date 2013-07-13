%% Exercise in Computer Aided Medical
%% Procedures II (Validation)
%% Abouzar Eslami, PhD, Sebastian Poelsterl, Prof. Nassir Navb
%% Summer 2013

clear all
close all
%%%%%%%%%%%%%%%%%%
% Part a
%%%%%%%%%%%%%%%%%%%
% Read normtemp dataset
M = csvread('normtemp.csv', 1,0);
%
males = M(M(:,2) == 1,:);
females = M(M(:,2) == 2,:);
disp('Difference between temperatures in males and females');
result = ttest2(males, females);
%the null hypothesis states that the data in vectors x and y comes
% from independent
%random samples from normal distributions with equalmeans and equal but
%unknown variances
if result == 1
    disp('Result: Null hypothesis rejected at 5% significance level (means probably not equivalent');
else
    disp('Result: Null hypothesis not rejected (means probably are equivalent) ');
end

%%
%%%%%%%%%%%%%%%%%%
% Part b
%%%%%%%%%%%%%%%%%%
% Read galton dataset
N = csvread('galton.csv',1,0);
result_height = ttest(N(:,1),N(:,2));
display('Difference between child and parents height');
if result == 1
    disp('Result: Null hypothesis rejected at 5% significance level (means probably not equivalent');
else
    disp('Result: Null hypothesis not rejected (means probably are equivalent) ');
end
% This test assumes that the variance is unknown but equal for both 
% of the distributions, and this is not the case since the size of the
% sample of the parent's height is 2.

%%
%%%%%%%%%%%%%%%%%%
% Part c
%%%%%%%%%%%%%%%%%%
n = 100;
V_1 = randn(n,1);
V_2 = 0.3 + randn(n,1);
% Test should return positive
V_tp = V_1(V_1<0.15); % true positive
tp = length(V_tp); % samples that are true positive
V_fn = V_1(V_1>=0.15); % false negative
fn = length(V_fn); %fn samples
% Test should return negative
V_tn = V_2(V_2>=0.15); % true negative
tn = length(V_tn); %tn samples
V_fp = V_2(V_2<0.15); % false positive
fp = length(V_fp); %fp samples
disp(['Number of true positives: ' num2str(tp)]);
disp(['Number of false negatives: ' num2str(fn)]);
disp(['Number of true negatives: ' num2str(tn)]);
disp(['Number of false positives: ' num2str(fp)]);

accuracy = (tp + tn)/(tp+tn+fn+fp);
disp(['Accuracy of the classifier: ' num2str(accuracy)]);
sensitivity = tp/(tp+fn); % true positive rate
disp(['Sensitivity of the classifier: ' num2str(sensitivity)]);
specificity = tn/(tn+fp); % true negative rate
disp(['Specificity of the classifier: ' num2str(specificity)]);

%%
%%%%%%%%%%%%%%%%%%
% Part d
%%%%%%%%%%%%%%%%%%
data1 = 0.5*randn(n,1);
data2 = 0.5*randn(n,1);
data_mean = (data1+data2)./2;
data_diff = data1-data2;
middle = mean(data_diff);
sd = std(data_diff);
figure(1);
hold on;
plot(data_mean,data_diff,'rx');
plot(data_mean,middle*ones(1,length(data_mean)),'b-');
plot(data_mean,-1.96*sd*ones(1,length(data_mean)),'b-');
plot(data_mean,+1.96*sd*ones(1,length(data_mean)),'b-');
hold off;
title('Bland Altman plot')
figure(2);
boxplot([data1,data2]);
title('Box plot')

%%
%%%%%%%%%%%%%%%%%%
% Part e
%%%%%%%%%%%%%%%%%%
%% Read the image
I = imread('vessel.png'); 
I = double(I(:,:,1));

%% Set the Parameters
sigmas = [1:1:5];
beta  = 1;
c     = 100;

%% Create matrices to store all vesselness images
AllScale =zeros([size(I) length(sigmas)]);

%% Display the original image
figure(1); subplot(1,2,1); imagesc(I); axis image; colormap gray;axis off; title('Original');

% Frangi filter for all the scales sigma
for i = 1:length(sigmas)
    
    % 1. Calculate the 2D hessian for the scale sigmas(i)
    %% ToDo: Fill Hessian2D
    [Dxx,Dxy,Dyy] = Hessian2D(I,sigmas(i));
    
    % Correct for scale
    Dxx = (sigmas(i)^2)*Dxx;
    Dxy = (sigmas(i)^2)*Dxy;
    Dyy = (sigmas(i)^2)*Dyy;
    % Calculate eigenvalues and vectors and sort the eigenvalues
    [Lambda1,Lambda2]=eig2image(Dxx,Dxy,Dyy);

    % 2. Compute the similarity measures that make sense in 2D
    % and the corresponding vesselness measure
    Rb  = Lambda1./Lambda2;
    S   = sqrt(Lambda1.^2+Lambda2.^2);
    Vesselness = exp(-Rb/(2*beta^2)) .* (ones(size(I))-exp(-S.^2/(2*c^2)));
    
    % 3. Set to Vesselness to 0 if Lambda2 is positive
    % and Store the results in the matrix AllScale
    if Lambda2>0
        Vesselness = 0;
    end
    AllScale(:,:,i) = Vesselness;
    
    figure(1); subplot(1,2,2); imagesc(Vesselness); axis image; colormap gray;axis off; title(sigmas(i));
    pause(0.1)
end

% 4. Which scale returns the highest vesselness value?
% Deduce the filtered image If
If = max(AllScale,[],3);

% Display
figure(1); subplot(1,2,2); imagesc(If); axis image; ...
    colormap gray;axis off; title('Frangi filter');
%%
%%%%%%%%%%%%%%%%%%
% Part f
%%%%%%%%%%%%%%%%%%
