clear; clc; close all;

%% Creating inverse kinematics robot
r = 100; %cm r = length 1
s = r;     % s = length 2
syms theta1 theta2 rob x y
% theta, d, a, alpha
% link angle, link offset, link length, link twist
DH = [theta1 0 r 0; theta2 0 s 0]
rob = SerialLink(DH)
robfk = rob.fkine([theta1 theta2])
xEq = robfk.t(1,1);
yEq = robfk.t(2,1);

robik = rob.ikine([x y])

%% generate points and compare
xlow = -200;
xhigh = 200;
ylow = -200;
yhigh = 200;

testSize = 100;
xTestVec = (xhigh-xlow).*rand(testSize,1) + xlow;
yTestVec = (yhigh-ylow).*rand(testSize,1) + ylow;
scatter(xTestVec,yTestVec);
hold on
didNotWork = 0;
thetas = cell(1,100);

for testi = 1:testSize
    try
        thetas{testi} = customIk(xTestVec(testi),yTestVec(testi));
        scatter(xTestVec(testi),yTestVec(testi),'filled','d');
        
    catch
        %catch if not in workspace
        didNotWork = didNotWork + 1; %workspace counter
    end
end