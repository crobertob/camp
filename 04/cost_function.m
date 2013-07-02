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




% calculate similarity measure
switch upper(similarity_measure)
    case 'SSD'
        %%% TODO:
        % calculate SSD
        
        
    case 'SAD'
        %%% TODO:
        % calculate SAD
        
        
    case 'NCC'
        %%% TODO:
        % calculate NCC
        
        
    case 'MI'
        %%% TODO:
        % calculate MI, use the function joint_histogram
        
end;