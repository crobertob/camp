
% E1a) conversion from rgb to od.
% convert an rgb-value to optical density (od) space.
% a value of 255 should map to a value close to 0, a value of 0 should map
% to 1.
% Note: keep in mind that log(0) maps to -infinity, which should be
% avoided!
function D = rgb2od(I)
    if uint8(I) == 0
        D = 1;
    else
    D = -1*log10((double(I)+1)/256)/log10(256); %
    end
end