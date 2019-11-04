clear; clc; close all;
%Authors: Ashley Lacy and Karl Parks

%% Creating foward kinematics robot
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

%% Constraints & Initialization
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

%% Generate Thetas and Calculate Forward Kinematics
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
    %2xN Double Array in Each Cell. X is top row, Y is bottom row
    xyCell{xIndex,yIndex} = [xyCell{xIndex,yIndex};[x,y,theta1rand,theta2rand]];
end

%% k-mean work, single cell
% probably wise to create a new cell array
% each cell would then contains to more cells that separate the data

xyCell1 = cell((ceil(2*(r+s)/deltaCM)),(ceil(2*(r+s)/deltaCM)));
xyCell2 = cell((ceil(2*(r+s)/deltaCM)),(ceil(2*(r+s)/deltaCM)));
coeff = cell((ceil(2*(r+s)/deltaCM)),(ceil(2*(r+s)/deltaCM)));


%if r>2 but r<6
%xyCell1{4,21} = [xyCell1{4,21}; xyCell{4,21}(i,1:4)];


idx = kmeans(xyCell{4,21}(:,1:2),2);
for i = 1:length(idx)
    if idx(i) == 1
        xyCell1{4,21} = [xyCell1{4,21}; xyCell{4,21}(i,1:4)];
    else
        xyCell2{4,21} = [xyCell2{4,21}; xyCell{4,21}(i,1:4)];
    end
end

%% Linear Regression and Store Coefficients
% linear regression on each nested cell for both cluster tables
% store 3 for this cluster coefficients
%r>2

modelt1 = fitlm(xyCell1{4,21}(:,1:2),xyCell1{4,21}(:,3));
a = modelt1.Coefficients.Estimate(2);
b = modelt1.Coefficients.Estimate(3);
c = modelt1.Coefficients.Estimate(1);
modelt2 = fitlm(xyCell1{4,21}(:,1:2),xyCell1{4,21}(:,4));
d = modelt2.Coefficients.Estimate(2);
e = modelt2.Coefficients.Estimate(3);
f = modelt2.Coefficients.Estimate(1);
%r>2
modelt1 = fitlm(xyCell2{4,21}(:,1:2),xyCell2{4,21}(:,3));
a2 = modelt1.Coefficients.Estimate(2);
b2 = modelt1.Coefficients.Estimate(3);
c2 = modelt1.Coefficients.Estimate(1);
modelt2 = fitlm(xyCell2{4,21}(:,1:2),xyCell2{4,21}(:,4));
d2 = modelt2.Coefficients.Estimate(2);
e2 = modelt2.Coefficients.Estimate(3);
f2 = modelt2.Coefficients.Estimate(1);

coeff{4,21} = [ a, b, c;
                d, e, f;
                a2, b2, c2;
                d2, e2, f2];

%% Begin Generating Coeff

for yidx = 1:40
%if r>2 & r<6
%  put in cell1
%if r >= 6
% k-mean
% if (sum(idx(:) == 1)) > 3
%   put in cell1 
% put in cell2 


%% Plotting
fig1 = figure;
scatter(theta1Array, theta2Array);
grid on

fig2 = figure;
scatter(xArray, yArray);
grid on

%% Early Work
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
