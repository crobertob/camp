%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate joint histogram of 2 images

function [histo] = joint_histogram(img1, img2);

bins = 256;

histo = zeros(bins, bins);

for i=1:numel(img1) % numel(img) = length(img(:))
   x = round((double(img1(i))/255)*bins); % normalize values of intensity
   y = round((double(img2(i))/255)*bins);

   %Add one to histogram in case the intensity value is present in the
   %image
    if(x>0 && y>0)
        histo(x,y) = histo(x,y) + 1;
    end
end