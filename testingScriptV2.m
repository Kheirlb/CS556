clear; clc; close all;

%% Initial values
l1 = 100; %cm
l2 = l1;
theta1low = 0;
theta1high = 170;
theta2low = -90;
theta2high = 90;

%% randomly generate points and compare
xlow = -200; xhigh = 200; ylow = -200; yhigh = 200;

testSize = 100;
xTestVec = (xhigh-xlow).*rand(testSize,1) + xlow;
yTestVec = (yhigh-ylow).*rand(testSize,1) + ylow;
scatter(xTestVec,yTestVec);
hold on
didNotWork = 0;
thetas = cell(100,2);

for testi = 1:testSize
    x = xTestVec(testi);
    y = yTestVec(testi);
    try
        thetas{testi,1} = customIk(x,y);
        scatter(x,y,'filled','d');
        thetas{testi,2} = customIkClosed(x,y,l1,l2);
        %compare variance here!!!
        
    catch
        %catch if not in workspace
        didNotWork = didNotWork + 1; %workspace counter
    end
end