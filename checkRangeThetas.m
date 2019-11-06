function [condition] = checkRangeThetas(t1,t2)
% Description: Checking Range of Thetas for 2 DoF Decomposition and Approximation 
%
% Inputs:
%     t1, t2: input thetas
%
% Outputs:
%     condition: boolean
%
% Other m-files required: setConstraints
% Subfunctions: none
% MAT-files required: none
%
% Authors: Ashley Lacy and Karl Parks
% November 2019; Last revision: 11-6-2019

%------------- BEGIN CODE --------------

condition = false;

global theta1low theta1high theta2low theta2high

if (t1 >= theta1low && t1 <= theta1high)
    if (t2 >= theta2low && t2 <= theta2high)
        condition = true;
    end
end
end

