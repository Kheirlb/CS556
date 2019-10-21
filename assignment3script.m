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

n = 5000;

theta1low = 0;
theta1high = 170;
theta2low = -90;
theta2high = 90;

deltaTheta = 10;
numCellsRow = ceil(170/deltaTheta);
numCellsCol = ceil(180/deltaTheta);
thetaCountCell = zeros(numCellsRow,numCellsCol);

elementLimit = ceil((n/(numCellsRow*numCellsCol))*1.1);

for idx = 1:n
    theta1rand = (theta1high-theta1low).*rand(1,1);
    theta2rand = (theta2high-theta2low).*rand(1,1);
    theta1Index = ceil(theta1rand/deltaTheta);
    theta2Index = ceil(theta2rand/deltaTheta);
    thetaCountCell(theta1Index,theta2Index) = thetaCountCell(theta1Index,theta2Index) + 1;
    %use element limit and if statement here! 
end

% scatter(theta1rand,theta2rand);
% grid on;

% for idx = 1:n
%     %grab joint angle combination
%     theta1 = theta1rand(idx);
%     theta2 = theta2rand(idx);
%     %find x and y
%     x(idx) = 100*cos(theta1 + theta2) + 100*cos(theta1);
%     y(idx) = 100*sin(theta1 + theta2) + 100*sin(theta1);
%     
%     %
% end

% Storing Options
%table
%array
%cell
%numeric
