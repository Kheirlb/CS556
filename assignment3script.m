clear; clc; close all;
%Authors: Ashley Lacy and Karl Parks

%% Constraints & Initialization
n = 25000;

%global theta1low theta1high theta2low theta2high deltaTheta deltaCM l1 l2
setConstraints;

numCellsRow = ceil((theta1high-theta1low)/deltaTheta);
numCellsCol = ceil((theta2high-theta2low)/deltaTheta);
thetaCountCell = zeros(numCellsRow,numCellsCol);
rowsXY = ceil(2 *(l1+l2)/deltaCM);
colsXY = ceil(2 *(l1+l2)/deltaCM);
xyCell = cell(rowsXY,colsXY);

rowsTheta = numCellsRow;
colsTheta = numCellsCol;
thetaCell = cell(rowsTheta,colsTheta);

elementMin = ceil((n/(numCellsRow*numCellsCol))*1.1);

xArray = [];
yArray = [];
theta1Array = [];
theta2Array = [];

%% Generate Thetas and Calculate Forward Kinematics
for idx = 1:n
    theta1rand = (theta1high-theta1low).*rand(1,1);
    theta2rand = theta2low + (theta2high-theta2low).*rand(1,1);
    
    theta2shift = (theta2high-theta2low)/(2*deltaTheta);
    theta1Index = ceil(theta1rand/deltaTheta);
    theta2Index = ceil(theta2rand/deltaTheta + theta2shift);
    %the above could end up being a negative number.... then it would not pull correctly from
   
    thetaCountCell(theta1Index,theta2Index) = thetaCountCell(theta1Index,theta2Index) + 1; %here...
    theta1Array = [theta1Array,theta1rand];
    theta2Array = [theta2Array,theta2rand];
    x = 100*cosd(theta1rand + theta2rand) + 100*cosd(theta1rand);
    y = 100*sind(theta1rand + theta2rand) + 100*sind(theta1rand);
    xArray = [xArray, x];
    yArray = [yArray, y];
    [xIndex,yIndex] = findxyIndex(x,y);
    %2xN Double Array in Each Cell. X is top row, Y is bottom row
    xyCell{xIndex,yIndex} = [xyCell{xIndex,yIndex};[x,y,theta1rand,theta2rand]];
    thetaCell{theta1Index,theta2Index} = [thetaCell{theta1Index,theta2Index};[theta1rand,theta2rand,x,y]];
end

% creating temporay arrays of split data
xyCell1 = cell(rowsXY,colsXY);
xyCell2 = cell(rowsXY,colsXY);
thetaCell1 = cell(numCellsRow,numCellsCol);
thetaCell2 = cell(numCellsRow,numCellsCol);

coeff = cell(rowsXY,colsXY); %creating primary online array
thetaCoeff = cell(rowsXY,colsXY);

disp('generated x and y, and the fofm thetas')
%% k-mean

for rowIdx = 1:numCellsRow
    for colIdx = 1:numCellsCol
        [numRowsPerCell, ~] = size(thetaCell{rowIdx,colIdx});
        if numRowsPerCell > 2 && numRowsPerCell < 6
            thetaCell1{rowIdx,colIdx} = [thetaCell1{rowIdx,colIdx}; thetaCell{rowIdx,colIdx}(:,:)];
        end
        if numRowsPerCell >= 6
            idx = kmeans(thetaCell{rowIdx,colIdx}(:,1:2),2,'Replicates',25);
            for i = 1:length(idx)
                if idx(i) == 1
                    thetaCell1{rowIdx,colIdx} = [thetaCell1{rowIdx,colIdx}; thetaCell{rowIdx,colIdx}(i,1:4)];
                else
                    thetaCell2{rowIdx,colIdx} = [thetaCell2{rowIdx,colIdx}; thetaCell{rowIdx,colIdx}(i,1:4)];
                end
            end
        end
    end
end

disp('completed k-mean for thetas')

% for rowIdx = 1:rowsXY
%     for colIdx = 1:colsXY
%         [numRowsPerCell, ~] = size(xyCell{rowIdx,colIdx});
%         if numRowsPerCell > 2 && numRowsPerCell < 6
%             xyCell1{rowIdx,colIdx} = [xyCell1{rowIdx,colIdx}; xyCell{rowIdx,colIdx}(:,:)];
%         end
%         if numRowsPerCell >= 6
%             idx = kmeans(xyCell{rowIdx,colIdx}(:,1:2),2,'Replicates',25);
%             for i = 1:length(idx)
%                 if idx(i) == 1
%                     xyCell1{rowIdx,colIdx} = [xyCell1{rowIdx,colIdx}; xyCell{rowIdx,colIdx}(i,1:4)];
%                 else
%                     xyCell2{rowIdx,colIdx} = [xyCell2{rowIdx,colIdx}; xyCell{rowIdx,colIdx}(i,1:4)];
%                 end
%             end
%         end
%     end
% end
% 
% disp('completed k-mean for x and y')
%% linear regression and coefficients

msgT = 'Generating Coeff for Thetas';
myWait = waitbar(0,msgT);

for rowIdx = 1:numCellsRow
    for colIdx = 1:numCellsCol
        [numRowsPerCell1, ~] = size(thetaCell1{rowIdx,colIdx});
        if numRowsPerCell1 > 2
            modelt1 = fitlm(thetaCell1{rowIdx,colIdx}(:,3:4),thetaCell1{rowIdx,colIdx}(:,1));
            a = modelt1.Coefficients.Estimate(2);
            b = modelt1.Coefficients.Estimate(3);
            c = modelt1.Coefficients.Estimate(1);
            modelt2 = fitlm(thetaCell1{rowIdx,colIdx}(:,3:4),thetaCell1{rowIdx,colIdx}(:,2));
            d = modelt2.Coefficients.Estimate(2);
            e = modelt2.Coefficients.Estimate(3);
            f = modelt2.Coefficients.Estimate(1);
            for rowIter = 1:length(thetaCell1{rowIdx,colIdx}(:,3))
                [xIndex,yIndex] = findxyIndex(thetaCell1{rowIdx,colIdx}(rowIter,3),thetaCell1{rowIdx,colIdx}(rowIter,4));
                if isempty(thetaCoeff{xIndex,yIndex})
                    t2 = d*thetaCell1{rowIdx,colIdx}(rowIter,3) + e*thetaCell1{rowIdx,colIdx}(rowIter,4) + f;
                    thetaCoeff{xIndex,yIndex} = [a, b, c, 0;
                                                 d, e, f, t2];
                end
            end
        end
        [numRowsPerCell2, ~] = size(thetaCell2{rowIdx,colIdx});
        if numRowsPerCell2 > 2
            modelt3 = fitlm(thetaCell2{rowIdx,colIdx}(:,3:4),thetaCell2{rowIdx,colIdx}(:,1));
            a2 = modelt3.Coefficients.Estimate(2);
            b2 = modelt3.Coefficients.Estimate(3);
            c2 = modelt3.Coefficients.Estimate(1);
            modelt4 = fitlm(thetaCell2{rowIdx,colIdx}(:,3:4),thetaCell2{rowIdx,colIdx}(:,2));
            d2 = modelt4.Coefficients.Estimate(2);
            e2 = modelt4.Coefficients.Estimate(3);
            f2 = modelt4.Coefficients.Estimate(1);
            for rowIter = 1:length(thetaCell2{rowIdx,colIdx}(:,3))
                [xIndex,yIndex] = findxyIndex(thetaCell2{rowIdx,colIdx}(rowIter,3),thetaCell2{rowIdx,colIdx}(rowIter,4));
                [rowCount, ~] = size(thetaCoeff{xIndex,yIndex});
                if rowCount == 0 
                    t2 = d2*thetaCell2{rowIdx,colIdx}(rowIter,3) + e2*thetaCell2{rowIdx,colIdx}(rowIter,4) + f2;
                    secondCoeff = [a2, b2, c2, 0;
                                   d2, e2, f2, t2];
                    thetaCoeff{xIndex,yIndex} = [thetaCoeff{xIndex,yIndex}; secondCoeff];
                end
                if rowCount == 2 
                    t21 = thetaCoeff{xIndex,yIndex}(2,4);
                    t22 = d2*thetaCell2{rowIdx,colIdx}(rowIter,3) + e2*thetaCell2{rowIdx,colIdx}(rowIter,4) + f2;
                    if (t22 < 0 && t21 > 0) || (t22 > 0 && t21 < 0)   
                        secondCoeff = [a2, b2, c2, 0;
                                       d2, e2, f2, t22];
                        thetaCoeff{xIndex,yIndex} = [thetaCoeff{xIndex,yIndex}; secondCoeff];
                    end
                end    
            end
        end
    end
    waitbar((rowIdx/rowsXY),myWait,msgT);
end

close(myWait);
disp('completed coefficient generation for thetas')

% msgXY = 'Generating Coeff for x and y';
% myWait = waitbar(0,msgXY);
% 
% for rowIdx = 1:rowsXY
%     for colIdx = 1:colsXY
%         [numRowsPerCell1, ~] = size(xyCell1{rowIdx,colIdx});
%         if numRowsPerCell1 > 2
%             modelt1 = fitlm(xyCell1{rowIdx,colIdx}(:,1:2),xyCell1{rowIdx,colIdx}(:,3));
%             a = modelt1.Coefficients.Estimate(2);
%             b = modelt1.Coefficients.Estimate(3);
%             c = modelt1.Coefficients.Estimate(1);
%             modelt2 = fitlm(xyCell1{rowIdx,colIdx}(:,1:2),xyCell1{rowIdx,colIdx}(:,4));
%             d = modelt2.Coefficients.Estimate(2);
%             e = modelt2.Coefficients.Estimate(3);
%             f = modelt2.Coefficients.Estimate(1);
%             coeff{rowIdx,colIdx} = [a, b, c;
%                                     d, e, f];
%         end
%         [numRowsPerCell2, ~] = size(xyCell2{rowIdx,colIdx});
%         if numRowsPerCell2 > 2
%             modelt3 = fitlm(xyCell2{rowIdx,colIdx}(:,1:2),xyCell2{rowIdx,colIdx}(:,3));
%             a2 = modelt3.Coefficients.Estimate(2);
%             b2 = modelt3.Coefficients.Estimate(3);
%             c2 = modelt3.Coefficients.Estimate(1);
%             modelt4 = fitlm(xyCell2{rowIdx,colIdx}(:,1:2),xyCell2{rowIdx,colIdx}(:,4));
%             d2 = modelt4.Coefficients.Estimate(2);
%             e2 = modelt4.Coefficients.Estimate(3);
%             f2 = modelt4.Coefficients.Estimate(1);
% 
%             secondCoeff = [a2, b2, c2;
%                            d2, e2, f2];
%             coeff{rowIdx,colIdx} = [coeff{rowIdx,colIdx}; secondCoeff];
%         end
%     end
%     waitbar((rowIdx/rowsXY),myWait,msgXY);
% end
% 
% close(myWait);
% 
% disp('completed coefficient generation for x and y')

%% saving data
save('coeff.mat','coeff');
save('thetaCoeff.mat','thetaCoeff');

%% Plotting
fig1 = figure;
scatter(theta1Array, theta2Array);
grid on
axis equal
xlabel('t1 angle [deg]');
ylabel('t2 angle [deg]');
title('Randomly Generated Joint-Space (t1,t2)');

fig2 = figure;
scatter(xArray, yArray);
xlim([-200, 200]);
ylim([-200, 200]);
grid on
axis equal
xlabel('X Distance [cm]');
ylabel('Y Distance [cm]');
title('Work-Space after Forward Kinematics from Randomly Generated Joint-Space');

%%
%close all;
%testingScriptV2;

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
