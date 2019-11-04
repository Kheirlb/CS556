clear; clc; close all;

%% Initial values
setConstraints;
load('storedXY.mat')

%% randomly generate points and compare
xlow = -200;
xhigh = 200;
ylow = -200;
yhigh = 200;

testSize = 600;
xTestVec = (xhigh-xlow).*rand(testSize,1) + xlow;
yTestVec = (yhigh-ylow).*rand(testSize,1) + ylow;
xyVec = [xTestVec, yTestVec];

%show workspace
L1 = l1;
L2 = l2;
xSpace = [];
ySpace = [];
skip = 2;
for n = theta1low:skip:theta1high
    dh1 = dh_standard(n,0,L1,0);
    for m = theta2low:skip:theta2high
        dh2 = dh_standard(m,0,L2,0);
        result = dh1*dh2;
        xSpace = [xSpace, result(1,4)];
        ySpace = [ySpace, result(2,4)];
    end
end


didNotWork = 0;
thetas = cell(100,3);

xUsed = [];
yUsed = [];
xVar = [];
yVar = [];
xVar2 = [];
yVar2 = [];

for testi = 1:testSize
    x = xTestVec(testi);
    y = yTestVec(testi);
   try
        thetas{testi,1} = [x,y];
        thetasIk = customIk(x,y);
        thetasIkClosed = closedIk(x,y,l1,l2);
        %if checkRangeThetas(thetasIkClosed(1), thetasIkClosed(2))
        thetas{testi,2} = thetasIk;
        thetas{testi,3} = thetasIkClosed;
        
        xUsed = [xUsed, x];
        yUsed = [yUsed, y];
        %compare variance here!!!
        
        if length(thetasIk) > 0
            xVar = [xVar, 100*cosd(thetasIk(1) + thetasIk(2)) + 100*cosd(thetasIk(1))];
            yVar = [yVar, 100*sind(thetasIk(1) + thetasIk(2)) + 100*sind(thetasIk(1))];
        end
        if length(thetasIk) > 2
            xVar = [xVar, 100*cosd(thetasIk(3) + thetasIk(4)) + 100*cosd(thetasIk(3))];
            yVar = [yVar, 100*sind(thetasIk(3) + thetasIk(4)) + 100*sind(thetasIk(3))];
        end        
        
        if length(thetasIkClosed) > 0
            xVar2 = [xVar2, 100*cosd(thetasIkClosed(1) + thetasIkClosed(2)) + 100*cosd(thetasIkClosed(1))];
            yVar2 = [yVar2, 100*sind(thetasIkClosed(1) + thetasIkClosed(2)) + 100*sind(thetasIkClosed(1))];
        end
        if length(thetasIkClosed) > 2
            xVar2 = [xVar2, 100*cosd(thetasIkClosed(3) + thetasIkClosed(4)) + 100*cosd(thetasIkClosed(3))];
            yVar2 = [yVar2, 100*sind(thetasIkClosed(3) + thetasIkClosed(4)) + 100*sind(thetasIkClosed(3))];
        end
   catch
        %catch if not in workspace
       didNotWork = didNotWork + 1; %workspace counter
   end
end

sz = 30;
scatter(xTestVec,yTestVec,3,'filled','MarkerFaceColor',[0 0 0.25]); %randomXY
hold on
scatter(xSpace,ySpace,1,'filled','MarkerFaceColor',[0 0.5 0.5]); %workspace
axis equal
grid on
scatter(xUsed,yUsed,sz,'MarkerEdgeColor',[0 0 1],'LineWidth',1.5);
scatter(xVar,yVar,sz,'filled','MarkerFaceColor',[1 0 0]);
scatter(xVar2,yVar2,sz,'filled','MarkerFaceColor',[0 1 0]);
legend('randomXY','workspace','selected','customIk','closedIk')
ylabel('Distance [cm]');
xlabel('Distance [cm]');
title('Workspace');