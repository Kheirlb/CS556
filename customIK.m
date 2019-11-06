function [thetaVector] = customIK(x,y)
% Description: Custom IK for 2 DoF Decomposition and Approximation 
%
% Inputs:
%     x, y: coordinate
%
% Outputs:
%     thetaVector: 2 or 4 thetas for 1 or 2 solutions
%
% Other m-files required: setConstraints, findxyIndex, checkRangeThetas
% Subfunctions: none
% MAT-files required: thetaCoeff.mat
%
% Authors: Ashley Lacy and Karl Parks
% November 2019; Last revision: 11-6-2019

%------------- BEGIN CODE --------------

load('thetaCoeff.mat');
coeff = thetaCoeff;
thetaVector = [];
setConstraints;

[xIndex,yIndex] = findxyIndex(x,y);

msg = 'Unreachable or Difficult to Reach';
[numDataRow, numDataCol] = size(coeff);
if (xIndex < 1 || xIndex > numDataRow)
    %error(msg);
    return;
end

if (yIndex < 1 || yIndex > numDataCol)
    %error(msg);
    return;
end

if isempty(coeff{xIndex,yIndex})
    %error(msg);
    return;
end

t11 = coeff{xIndex,yIndex}(1,1)*x + coeff{xIndex,yIndex}(1,2)*y + coeff{xIndex,yIndex}(1,3);
t12 = coeff{xIndex,yIndex}(2,1)*x + coeff{xIndex,yIndex}(2,2)*y + coeff{xIndex,yIndex}(2,3);
if checkRangeThetas(t11,t12)
    thetaVector = [t11, t12];
end

[numRowPerCell, ~] = size(coeff{xIndex,yIndex});
if numRowPerCell > 2
    t21 = coeff{xIndex,yIndex}(3,1)*x + coeff{xIndex,yIndex}(3,2)*y + coeff{xIndex,yIndex}(3,3);
    t22 = coeff{xIndex,yIndex}(4,1)*x + coeff{xIndex,yIndex}(4,2)*y + coeff{xIndex,yIndex}(4,3);
    if checkRangeThetas(t21,t22)
        thetaVector = [thetaVector, t21, t22];
    end
end

end

