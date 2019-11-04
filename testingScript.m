
x = -160;
y = 9;

%check if in workspace

load('coeff.mat');
deltaCM = 10;
xIndex = ceil(x/deltaCM) + 20;
yIndex = ceil(y/deltaCM) + 20;

t11 = coeff{xIndex,yIndex}(1,1)*x + coeff{xIndex,yIndex}(1,2)*y + coeff{xIndex,yIndex}(1,3);
t12 = coeff{xIndex,yIndex}(2,1)*x + coeff{xIndex,yIndex}(2,2)*y + coeff{xIndex,yIndex}(2,3);
t21 = coeff{xIndex,yIndex}(3,1)*x + coeff{xIndex,yIndex}(3,2)*y + coeff{xIndex,yIndex}(3,3);
t22 = coeff{xIndex,yIndex}(4,1)*x + coeff{xIndex,yIndex}(4,2)*y + coeff{xIndex,yIndex}(4,3);

thetaVector = [t11, t12, t21, t22];
