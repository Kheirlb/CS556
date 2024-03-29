% Description: Testing Script for 2 DoF Decomposition and Approximation 
%
% Outputs:
%     figure 1: workspace
%     figure 2: jointspace
%     statistics on variance and time
%
% Other m-files required: setConstraints, findxyIndex, customIk,
% closedIk_v2
% Subfunctions: none
% MAT-files required: thrustCoeff.mat
%
% Authors: Ashley Lacy and Karl Parks
% November 2019; Last revision: 11-6-2019

%------------- BEGIN CODE --------------

clear; clc; close all;

%% Initial values
setConstraints;
%load('storedXY.mat')
%load('xyVec.mat')

%% randomly generate points and compare
xlow = -200;
xhigh = 200;
ylow = -200;
yhigh = 200;

testSize = 100;
xTestVec = (xhigh-xlow).*rand(testSize,1) + xlow;
yTestVec = (yhigh-ylow).*rand(testSize,1) + ylow;
xyVec = [xTestVec, yTestVec];
% xTestVec = xyVec(:,1);
% yTestVec = xyVec(:,2);

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
thetas = cell(testSize,3);

xUsed = [];
yUsed = [];
xVar = [];
yVar = [];
xVar2 = [];
yVar2 = [];
mark2ans1 = [];
mark2ans2 = [];

storeThetas1 = zeros(1,2);
storeThetas2 = zeros(1,2);
storeClosedThetas1 = zeros(1,2);
storeClosedThetas2 = zeros(1,2);

timeCountVec = [];

for testi = 1:testSize
    x = xTestVec(testi);
    y = yTestVec(testi);
  try
        thetas{testi,1} = [x,y];
        tic;
        thetasIk = customIK(x,y);
        timeCountVec = [timeCountVec, toc];
        storeThetas1 = [storeThetas1; thetasIk(1:2)];
        if length(thetasIk) > 2 
            storeThetas2 = [storeThetas2; thetasIk(3:4)];
        end
        thetas{testi,2} = thetasIk;
        
        %compare variance here!!!
        
        if length(thetasIk) > 0
            xUsed = [xUsed, x];
            yUsed = [yUsed, y];
            mark2ans1 = [mark2ans1, length(xUsed)];
            xVar = [xVar, 100*cosd(thetasIk(1) + thetasIk(2)) + 100*cosd(thetasIk(1))];
            yVar = [yVar, 100*sind(thetasIk(1) + thetasIk(2)) + 100*sind(thetasIk(1))];
        end
        if length(thetasIk) > 2
            xUsed = [xUsed, x];
            yUsed = [yUsed, y];
            mark2ans2 = [mark2ans2, length(xUsed)];
            xVar = [xVar, 100*cosd(thetasIk(3) + thetasIk(4)) + 100*cosd(thetasIk(3))];
            yVar = [yVar, 100*sind(thetasIk(3) + thetasIk(4)) + 100*sind(thetasIk(3))];
        end
        
        thetasIkClosed = closedIk_v2(x,y,l1,l2);
        storeClosedThetas1 = [storeClosedThetas1; thetasIkClosed(1:2)];
        if length(thetasIk) > 2 
            storeClosedThetas2 = [storeClosedThetas2; thetasIkClosed(3:4)];
        end
%         thetas{testi,3} = thetasIkClosed;       
%         if length(thetasIkClosed) > 0
%             xVar2 = [xVar2, 100*cosd(thetasIkClosed(1) + thetasIkClosed(2)) + 100*cosd(thetasIkClosed(1))];
%             yVar2 = [yVar2, 100*sind(thetasIkClosed(1) + thetasIkClosed(2)) + 100*sind(thetasIkClosed(1))];
%         end
%         if length(thetasIkClosed) > 2
%             xVar2 = [xVar2, 100*cosd(thetasIkClosed(3) + thetasIkClosed(4)) + 100*cosd(thetasIkClosed(3))];
%             yVar2 = [yVar2, 100*sind(thetasIkClosed(3) + thetasIkClosed(4)) + 100*sind(thetasIkClosed(3))];
%         end
  catch
      %catch if not in workspace
      didNotWork = didNotWork + 1; %workspace counter
  end
end

%% workspace figure
fig1 = figure(1);
sz = 30;
scatter(xTestVec,yTestVec,3,'filled','MarkerFaceColor',[0 0 0]); %randomXY
hold on
axis equal
grid on
%plot(xSpace,ySpace,'c');
scatter(xSpace,ySpace,1,'filled','MarkerFaceColor',[0 0 0.5]); %workspace
scatter(xUsed,yUsed,sz*2,'MarkerEdgeColor',[0 0 1],'LineWidth',1.5); %selected
scatter(xVar,yVar,sz/2,'filled','MarkerFaceColor',[1 0 0]); %customIk
%scatter(xVar2,yVar2,sz/3,'filled','MarkerFaceColor',[0 1 0]); %closedIk

%show points with two answers
scatter(xVar(mark2ans1),yVar(mark2ans1),80,'m','LineWidth',1.25);

%show points with two answers
scatter(xVar(mark2ans2),yVar(mark2ans2),170,'k','LineWidth',1.25);

variance_cm = 0;
variance_cm_vec = zeros(length(xUsed), 1);
%plot variance using lines
for iter = 1:length(xUsed)
    plot([xUsed(iter), xVar(iter)],[yUsed(iter), yVar(iter)], 'k')
    plot([xUsed(iter), xVar(iter)],[yUsed(iter), yVar(iter)], 'k');
    variance_cm = sqrt((xVar(iter)- xUsed(iter))^2 + (yVar(iter) - yUsed(iter))^2);
    variance_cm_vec(iter) = variance_cm;
end

legend('randomXY','workspace','in range','customIk','1st Sol','2nd Sol','variance');
xlabel('X Distance [cm]');
ylabel('Y Distance [cm]');
title('2 DoF Spatial Decompostion Work-Space (FofM)');

%% joint space
fig2 = figure(2);
scatter(storeThetas1(:,1),storeThetas1(:,2),'MarkerEdgeColor',[0 1 0]);
hold on;
axis equal;
grid on;
scatter(storeThetas2(:,1),storeThetas2(:,2),'MarkerEdgeColor',[0 0.5 0]);
scatter(storeClosedThetas1(:,1),storeClosedThetas1(:,2),10,'filled','MarkerFaceColor',[1 0 0]);
scatter(storeClosedThetas2(:,1),storeClosedThetas2(:,2),10,'filled','MarkerFaceColor',[0.5 0 0]);
legend('custom 1','custom 2','closed 1','closed 2');
xlabel('t1 angle [deg]');
ylabel('t2 angle [deg]');
title('2 DoF Spatial Decompostion Joint-Space (FofM)');

%% print statistics
fprintf('Average Online Computation Time: %0.2f ms\n', mean(timeCountVec)*1000);
fprintf('Average Variance: %0.2f cm\n', mean(variance_cm_vec));
fprintf('Max Variance: %0.2f cm\n', max(variance_cm_vec));