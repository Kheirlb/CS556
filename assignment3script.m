clear; clc; close all;
%Authors: Ashley Lacy and Karl Parks

%% Constraints & Initialization
n = 50000;

%global theta1low theta1high theta2low theta2high deltaTheta deltaCM l1 l2
setConstraints;

numCellsRow = ceil((theta1high-theta1low)/deltaTheta);
numCellsCol = ceil((theta2high-theta2low)/deltaTheta);
thetaCountCell = zeros(numCellsRow,numCellsCol);
rowsXY = ceil(2 *(l1+l2)/deltaCM);
colsXY = ceil(2 *(l1+l2)/deltaCM);
xyCell = cell(rowsXY,colsXY);

elementMin = ceil((n/(numCellsRow*numCellsCol))*1.1);

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
    theta2shift = (theta2high-theta2low)/(2*deltaTheta);
    thetaCountCell(theta1Index,theta2Index + theta2shift) = thetaCountCell(theta1Index,theta2Index + theta2shift) + 1; %here...
    theta1Array = [theta1Array,theta1rand];
    theta2Array = [theta2Array,theta2rand];
    x = 100*cosd(theta1rand + theta2rand) + 100*cosd(theta1rand);
    y = 100*sind(theta1rand + theta2rand) + 100*sind(theta1rand);
    xArray = [xArray, x];
    yArray = [yArray, y];
    xIndex = ceil(x/deltaCM) + (l1+l2)/deltaCM;
    yIndex = ceil(y/deltaCM) + (l1+l2)/deltaCM;
    %2xN Double Array in Each Cell. X is top row, Y is bottom row
    xyCell{xIndex,yIndex} = [xyCell{xIndex,yIndex};[x,y,theta1rand,theta2rand]];
end

% creating temporay arrays of split data
xyCell1 = cell(rowsXY,colsXY);
xyCell2 = cell(rowsXY,colsXY);

coeff = cell(rowsXY,colsXY); %creating primary online array

disp('generated x and y')
%% k-mean

for rowIdx = 1:rowsXY
    for colIdx = 1:colsXY
        [numRowsPerCell, ~] = size(xyCell{rowIdx,colIdx});
        if numRowsPerCell > 2 && numRowsPerCell < 6
            xyCell1{rowIdx,colIdx} = [xyCell1{rowIdx,colIdx}; xyCell{rowIdx,colIdx}(:,:)];
        end
        if numRowsPerCell >= 6
            idx = kmeans(xyCell{rowIdx,colIdx}(:,1:2),2,'Replicates',25);
            for i = 1:length(idx)
                if idx(i) == 1
                    xyCell1{rowIdx,colIdx} = [xyCell1{rowIdx,colIdx}; xyCell{rowIdx,colIdx}(i,1:4)];
                else
                    xyCell2{rowIdx,colIdx} = [xyCell2{rowIdx,colIdx}; xyCell{rowIdx,colIdx}(i,1:4)];
                end
            end
        end
    end
end

disp('completed k-mean')
%% linear regression and coefficients

myWait = waitbar(0,'Generating Coeff');

for rowIdx = 1:rowsXY
    for colIdx = 1:colsXY
        [numRowsPerCell1, ~] = size(xyCell1{rowIdx,colIdx});
        if numRowsPerCell1 > 2
            modelt1 = fitlm(xyCell1{rowIdx,colIdx}(:,1:2),xyCell1{rowIdx,colIdx}(:,3));
            a = modelt1.Coefficients.Estimate(2);
            b = modelt1.Coefficients.Estimate(3);
            c = modelt1.Coefficients.Estimate(1);
            modelt2 = fitlm(xyCell1{rowIdx,colIdx}(:,1:2),xyCell1{rowIdx,colIdx}(:,4));
            d = modelt2.Coefficients.Estimate(2);
            e = modelt2.Coefficients.Estimate(3);
            f = modelt2.Coefficients.Estimate(1);
            coeff{rowIdx,colIdx} = [a, b, c;
                                    d, e, f];
        end
        [numRowsPerCell2, ~] = size(xyCell2{rowIdx,colIdx});
        if numRowsPerCell2 > 2
            modelt3 = fitlm(xyCell2{rowIdx,colIdx}(:,1:2),xyCell2{rowIdx,colIdx}(:,3));
            a2 = modelt3.Coefficients.Estimate(2);
            b2 = modelt3.Coefficients.Estimate(3);
            c2 = modelt3.Coefficients.Estimate(1);
            modelt4 = fitlm(xyCell2{rowIdx,colIdx}(:,1:2),xyCell2{rowIdx,colIdx}(:,4));
            d2 = modelt4.Coefficients.Estimate(2);
            e2 = modelt4.Coefficients.Estimate(3);
            f2 = modelt4.Coefficients.Estimate(1);

            secondCoeff = [a2, b2, c2;
                           d2, e2, f2];
            coeff{rowIdx,colIdx} = [coeff{rowIdx,colIdx}; secondCoeff];
        end
    end
    waitbar((rowIdx/rowsXY),myWait,'Generating Coeff');
end

close(myWait);

disp('completed coefficient generation')
save('coeff.mat','coeff');

%% Plotting
fig1 = figure;
scatter(theta1Array, theta2Array);
grid on

fig2 = figure;
scatter(xArray, yArray);
xlim([-200, 200]);
ylim([-200, 200]);
grid on

close all;
testingScriptV2;

%% Saving early work for reference
% k-mean work, single cell
% probably wise to create a new cell array
% each cell would then contains to more cells that separate the data

%if r>2 but r<6
%xyCell1{4,21} = [xyCell1{4,21}; xyCell{4,21}(i,1:4)];


% idx = kmeans(xyCell{4,21}(:,1:2),2);
% for i = 1:length(idx)
%     if idx(i) == 1
%         xyCell1{4,21} = [xyCell1{4,21}; xyCell{4,21}(i,1:4)];
%     else
%         xyCell2{4,21} = [xyCell2{4,21}; xyCell{4,21}(i,1:4)];
%     end
% end

% Linear Regression and Store Coefficients
% linear regression on each nested cell for both cluster tables
% store 3 for this cluster coefficients
%r>2

% modelt1 = fitlm(xyCell1{4,21}(:,1:2),xyCell1{4,21}(:,3));
% a = modelt1.Coefficients.Estimate(2);
% b = modelt1.Coefficients.Estimate(3);
% c = modelt1.Coefficients.Estimate(1);
% modelt2 = fitlm(xyCell1{4,21}(:,1:2),xyCell1{4,21}(:,4));
% d = modelt2.Coefficients.Estimate(2);
% e = modelt2.Coefficients.Estimate(3);
% f = modelt2.Coefficients.Estimate(1);
% %r>2
% modelt1 = fitlm(xyCell2{4,21}(:,1:2),xyCell2{4,21}(:,3));
% a2 = modelt1.Coefficients.Estimate(2);
% b2 = modelt1.Coefficients.Estimate(3);
% c2 = modelt1.Coefficients.Estimate(1);
% modelt2 = fitlm(xyCell2{4,21}(:,1:2),xyCell2{4,21}(:,4));
% d2 = modelt2.Coefficients.Estimate(2);
% e2 = modelt2.Coefficients.Estimate(3);
% f2 = modelt2.Coefficients.Estimate(1);
% 
% coeff{4,21} = [ a, b, c;
%                 d, e, f;
%                 a2, b2, c2;
%                 d2, e2, f2];

% EARLY EARLY WORK

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
