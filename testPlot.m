clc; clear; close all;

load('coeff.mat');
[r,c] = size(coeff);

m = zeros(r,c);
x = [];
y = [];

for xIndex = 1:r
    for yIndex = 1:c
        if ~isempty(coeff{xIndex,yIndex})
            m(xIndex,yIndex) = 1;
            x = [x,xIndex];
            y = [y,yIndex];
        end
    end
end

scatter(x,y);
grid on;
