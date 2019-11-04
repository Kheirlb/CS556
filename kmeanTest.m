close all;

xIdx = 4;
yIdx = 21;

scatter(xyCell{xIdx,yIdx}(:,1),xyCell{xIdx,yIdx}(:,2))
hold on
scatter(xyCell1{xIdx,yIdx}(:,1),xyCell1{xIdx,yIdx}(:,2))
%scatter(xyCell2{xIdx,yIdx}(:,1),xyCell2{xIdx,yIdx}(:,2),'c',[0 1 0])