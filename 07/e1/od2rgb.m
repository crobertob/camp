% E1a) build the inverse function of rgb2od
function I = od2rgb(D)
  I = uint8(256*(10.^(-1*D*log(256)))-1); % 
end