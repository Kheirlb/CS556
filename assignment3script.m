clear; clc; close all;
%Authors: Ashley Lacy and Karl Parks

% Creating foward kinematics robot
r = 100; %cm r = length 1
s = r;     % s = length 2
syms theta1 theta2 rob
% theta, d, a, alpha
% link angle, link offset, link length, link twist
DH = [theta1 0 r 0; theta2 0 s 0]
rob = SerialLink(DH)
robfk = rob.fkine([theta1 theta2])
xEq = robfk.t(1,1);
yEq = robfk.t(2,1);

n = 25000;

theta1low = 0;
theta1high = 170;
theta2low = -90;
theta2high = 90;

deltaTheta = 10;
deltaCM = 10;
numCellsRow = ceil(170/deltaTheta);
numCellsCol = ceil(180/deltaTheta);
thetaCountCell = zeros(numCellsRow,numCellsCol);
xyCell = cell((ceil(2*(r+s)/deltaCM)),(ceil(2*(r+s)/deltaCM)));

elementLimit = ceil((n/(numCellsRow*numCellsCol))*1.1);

xArray = [];
yArray = [];
theta1Array = [];
theta2Array = [];


for idx = 1:n
    theta1rand = (theta1high-theta1low).*rand(1,1);
    theta2rand = theta2low + (theta2high-theta2low).*rand(1,1);
    theta1Index = ceil(theta1rand/deltaTheta);
    theta2Index = ceil(theta2rand/deltaTheta);%this could end up being a negative number.... then it would not pull correctly from
    thetaCountCell(theta1Index,theta2Index+9) = thetaCountCell(theta1Index,theta2Index+9) + 1; %here...
    theta1Array = [theta1Array,theta1rand];
    theta2Array = [theta2Array,theta2rand];
    x = 100*cosd(theta1rand + theta2rand) + 100*cosd(theta1rand);
    y = 100*sind(theta1rand + theta2rand) + 100*sind(theta1rand);
    xArray = [xArray, x];
    yArray = [yArray, y];
    xIndex = ceil(x/deltaCM) + 20;
    yIndex = ceil(y/deltaCM) + 20;
    xyCell{xIndex,yIndex} = [xyCell{xIndex,yIndex},[x,y]'];
    
    %use element limit and if statement here! 
end

% scatter(theta1rand,theta2rand);
% grid on;

% for idx = 1:n
%     %grab joint angle combination
%     theta1 = theta1rand(idx);
%     theta2 = theta2rand(idx);
%     %find x and y
%     
%     %
% end

% Storing Options
%table
%array
%cell
%numeric

%fitlm
