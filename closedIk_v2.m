function [thetaVector] = closedIk_v2(x,y,l1,l2)
% Description: Closed Form Solution IK for 2 DoF Decomposition and Approximation 
%
% Inputs:
%     x, y: coordinate
%     l1, l2: distances
%
% Outputs:
%     thetaVector: 2 or 4 thetas for 1 or 2 solutions
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% Authors: Ashley Lacy and Karl Parks
% November 2019; Last revision: 11-6-2019

%------------- BEGIN CODE --------------

thetaVector = [];

t2rad1 = acos((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2));
t1rad1 = atan2(y,x) - atan2(l2*sin(t2rad1), l1 + l2*cos(t2rad1));

t2rad2 = -acos((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2));
t1rad2 = atan2(y,x) - atan2(l2*sin(t2rad2), l1 + l2*cos(t2rad2));

t2deg1 = rad2deg(t2rad1);
t1deg1 = rad2deg(t1rad1);
t2deg2 = rad2deg(t2rad2);
t1deg2 = rad2deg(t1rad2);

if checkRangeThetas(t1deg1,t2deg1)
    thetaVector = [t1deg1, t2deg1];
end

if checkRangeThetas(t1deg2,t2deg2)
    thetaVector = [thetaVector, t1deg2, t2deg2];
end

end

