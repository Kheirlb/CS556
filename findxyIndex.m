function [xIndex,yIndex] = findxyIndex(x,y)
% Description: Calculating File Indices for 2 DoF Decomposition and Approximation 
%
% Inputs:
%     x, y: coordinate
%
% Outputs:
%     xIndex,yIndex: matrix indices
%
% Other m-files required: setConstraints
% Subfunctions: none
% MAT-files required: none
%
% Authors: Ashley Lacy and Karl Parks
% November 2019; Last revision: 11-6-2019

%------------- BEGIN CODE --------------

setConstraints;

xIndex = ceil(x/deltaCM) + (l1+l2)/deltaCM;
yIndex = ceil(y/deltaCM) + (l1+l2)/deltaCM;
end

