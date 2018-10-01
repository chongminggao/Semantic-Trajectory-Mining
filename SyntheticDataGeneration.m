boundary = 100; % side length of the map.
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];

numbofSynthesisPoints = 200; % number of points
numbofKeyPoints = 20;  % number of keypoints
numbofSynTraj = 50;  % number of trajectory


if numbofKeyPoints >= numbofSynTraj
    error('k should be smaller than T');
end

points = (boundary-1) * rand(numbofSynthesisPoints,2) + 0.5;

startInd = ceil(numbofSynthesisPoints * rand(numbofSynTraj,1));
endInd = ceil(numbofSynthesisPoints * rand(numbofSynTraj,1));
keyInd = startInd(1:numbofKeyPoints);

keypoints = points(keyInd,:);
startPoints = points(startInd,:);
endPoints = points(endInd,:);


%% 

map = ones(boundary * 2,'logical');
map(2:end-1,2:end-1) = false;
map = robotics.BinaryOccupancyGrid(map, 2);
% show(map)


prm = robotics.PRM;
prm.Map = map;

%==================================================
prm.NumNodes = 2000;
prm.ConnectionDistance = 3;
%==================================================


latLong = [];

for i = 1:numbofSynTraj
    startLocation = startPoints(i,:);
    endLocation = endPoints(i,:);
    update(prm);
    path = findpath(prm, startLocation, endLocation);

    while isempty(path)
        prm.NumNodes = prm.NumNodes + 100;
        update(prm);
        path = findpath(prm, startLocation, endLocation);
    end
    fprintf('iteration[%d] = [prm.NumNodes] has increase to %d\n',i,prm.NumNodes);
    latLong = [latLong;[i * ones(size(path,1),1) , path]];

%     show(prm)
    
    
end

%% For Trajectory Retrieval paper
% param.numberOfVisualization = numbofSynTraj;
% param.visualStyle = 'plot';
% param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];
% visualization(latLong,param);
% 
% 
% 
% hold on;
% plot(keypoints(:,2),keypoints(:,1),'p','MarkerSize',25,'MarkerFaceColor','[.6 .6 .6]','Color',[0 0 0],'LineWidth',2);
% a = gca;
% axis(a,'square')
% set(a,'XTick',[],'XTickLabel',[]);
% set(a,'YTick',[],'YTickLabel',[]);
% box on;
% a.Position = [0 0 1 1];
% f = gcf;
% pos =  f.Position;
% if pos(4) < pos(3)
%     pos(3) = pos(4);
% end
% f.Position = pos;
% hold off;

%% For Trajectory Compression
param.numberOfVisualization = numbofSynTraj;
param.visualStyle = 'plot';
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];
visualization(latLong,param);


hold on;
plot(keypoints(:,2),keypoints(:,1),'^','MarkerSize',15,'MarkerFaceColor','[0.5660    0.7740    0.2880]','Color',[0 0 0],'LineWidth',2);
a = gca;
axis(a,'square')
set(a,'XTick',[],'XTickLabel',[]);
set(a,'YTick',[],'YTickLabel',[]);
box on;
a.Position = [0 0 1 1];
f = gcf;
pos =  f.Position;
if pos(4) < pos(3)
    pos(3) = pos(4);
end
f.Position = pos;
hold off;
