function [thetaVector] = customIk(x,y)
load('coeff.mat');
thetaVector = [];
setConstraints;

xIndex = ceil(x/deltaCM) + 20;
yIndex = ceil(y/deltaCM) + 20;

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

