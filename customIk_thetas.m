function [thetaVector] = customIk_thetas(x,y)
load('thetaCoeff.mat');
thetaVector = [];
setConstraints;

[xIndex,yIndex] = findxyIndex(x,y);

theta2shift = (theta2high-theta2low)/(2*deltaTheta);
theta1Index = ceil(theta1rand/deltaTheta);
theta2Index = ceil(theta2rand/deltaTheta + theta2shift);

msg = 'Unreachable or Difficult to Reach';
[numDataRow, numDataCol] = size(thetaCoeff);
if (theta1Index < 1 || theta1Index > numDataRow)
    %error(msg);
    return;
end

if (theta2Index < 1 || theta2Index > numDataCol)
    %error(msg);
    return;
end

if isempty(thetaCoeff{theta1Index,theta2Index})
    %error(msg);
    return;
end

t11 = thetaCoeff{theta1Index,theta2Index}(1,1)*x + thetaCoeff{theta1Index,theta2Index}(1,2)*y + thetaCoeff{theta1Index,theta2Index}(1,3);
t12 = thetaCoeff{theta1Index,theta2Index}(2,1)*x + thetaCoeff{theta1Index,theta2Index}(2,2)*y + thetaCoeff{theta1Index,theta2Index}(2,3);
if checkRangeThetas(t11,t12)
    thetaVector = [t11, t12];
end

[numRowPerCell, ~] = size(thetaCoeff{theta1Index,theta2Index});
if numRowPerCell > 2
    t21 = thetaCoeff{theta1Index,theta2Index}(3,1)*x + thetaCoeff{theta1Index,theta2Index}(3,2)*y + thetaCoeff{theta1Index,theta2Index}(3,3);
    t22 = thetaCoeff{theta1Index,theta2Index}(4,1)*x + thetaCoeff{theta1Index,theta2Index}(4,2)*y + thetaCoeff{theta1Index,theta2Index}(4,3);
    if checkRangeThetas(t21,t22)
        thetaVector = [thetaVector, t21, t22];
    end
end

end

