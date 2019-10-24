clc;
clear;
close all;

%number of options
total = 10000;

L1 = 100;
L2 = 100; %5
x = [];
y = [];
r1array = [];
r2array = [];

for n = 1:total
    % generate 2 random joint angles
    a = 0;
    b = 170;
    r1 = (b-a).*rand(1,1) + a;
    a = -90;
    b = 90;
    r2 = (b-a).*rand(1,1) + a;
    r1array = [r1array, r1];
    r2array = [r2array, r2];
    % computer locations
    dh1 = dh_standard(r1,0,L1,0);
    dh2 = dh_standard(r2,0,L2,0);
    result = dh1*dh2;
    x = [x, result(1,4)];
    y = [y, result(2,4)];
end

% display workspace
scatter(x,y);
axis equal
grid on

function [matrix] = dh_standard(theta, d, a, alpha)
% alpha_(i - 1)
% a_(i - 1)
% d-i
% theta_i
matrix = [cosd(theta), -sind(theta)*cosd(alpha), sind(theta)*sind(alpha), a*cosd(theta);
    sind(theta), cosd(theta)*cosd(alpha), -cosd(theta)*sind(alpha), a*sind(theta);
    0, sind(alpha) cosd(alpha), d;    
    0, 0, 0, 1];
end