%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function cost_function
% implement intensity based registration

function [similarity_value] = cost_function(transform_params, img_fixed, img_moving, similarity_measure);

global img_registertest

% construct current transformation
angle = transform_params(1);
dx    = transform_params(2);
dy    = transform_params(3);

%%% TODO:
% apply current transformation to img_moving
%   store result in "img_registertest"
img_registertest = image_rotate(img_moving, angle, [0 0]);
img_registertest = image_translate(img_registertest, [dx dy]);

% calculate similarity measure
switch upper(similarity_measure)
    case 'SSD'
        %%% TODO:
        % calculate SSD
        similarity_value = mean2((img_fixed-img_registertest).^2);
    case 'SAD'
        %%% TODO:
        % calculate SAD
        similarity_value = mean2(abs(img_fixed-img_registertest));
        
    case 'NCC'
        %%% TODO:
        % calculate NCC
        m_f = mean2(img_fixed);
        m_r = mean2(img_registertest);
        s_f = std2(img_fixed);
        s_r = std2(img_registertest);
        similarity_value = -abs(mean2((double((img_fixed-m_f).*(img_registertest-m_r)))./(s_f*s_r)));        
    case 'MI'
        %%% TODO:
        % calculate MI, use the function joint_histogram
        px=hist(double(img_fixed(:)), 256);
        py=hist(double(img_registertest(:)), 256);
        pxy=joint_histogram(img_fixed,img_registertest);
        similarity_value=0;
        for i=1:256
            for j=1:256
                if (px(i) * py(j)>0) && (pxy(i,j)/(px(i).*py(j)))>0
                    similarity_value=similarity_value+...
                        pxy(i,j)*log(pxy(i,j)/(px(i).*py(j)));
                end
            end
         end      
end;