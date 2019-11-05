function [xIndex,yIndex] = findxyIndex(x,y)
setConstraints;

xIndex = ceil(x/deltaCM) + (l1+l2)/deltaCM;
yIndex = ceil(y/deltaCM) + (l1+l2)/deltaCM;
end

