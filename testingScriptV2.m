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
preach = [160.0,9.0]
%robik = rob.ikcon(robfk, preach)

%% inverse 
l1 = 100; %cm
l2 = l1;
x = -160;
y = 9;
t2rad1 = atan2(sqrt(1-((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2))),((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2)));
t2rad2 = atan2(-sqrt(1-((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2))),((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2)));

t2deg1 = rad2deg(t2rad1);
t2deg2 = rad2deg(t2rad2);

k1 = l1 + l2*cos(t2rad1);
k2 = l2*sin(t2rad1);
t1rad1 = atan2(y,x) - atan2(k2,k1);
t1deg1 = rad2deg(t1rad1);

k1 = l1 + l2*cos(t2rad2);
k2 = l2*sin(t2rad2);
t1rad2 = atan2(y,x) - atan2(k2,k1);
t1deg2 = rad2deg(t1rad2);

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
        
        %compare variance here!!!
        
    catch
        %catch if not in workspace
        didNotWork = didNotWork + 1; %workspace counter
    end
end