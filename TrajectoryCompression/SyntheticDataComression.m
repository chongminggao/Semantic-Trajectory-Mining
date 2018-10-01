%% Generate Synthetic Data set PART 1: Initial the data parameters.

boundary = 100; % side length of the map.
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];

numbofSynthesisPoints = 200; % number of points
numbofKeyPoints = 30;  % number of keypoints
numbofSynTraj = 50;  % number of trajectory

if numbofKeyPoints >= numbofSynTraj
    error('k should be smaller than T');
end

selection = randperm(numbofSynTraj);
selection = selection(1:numbofKeyPoints);

points = (boundary-1) * rand(numbofSynthesisPoints,2) + 0.5;

startInd = ceil(numbofSynthesisPoints * rand(numbofSynTraj,1));
endInd = ceil(numbofSynthesisPoints * rand(numbofSynTraj,1));
% keyInd = startInd(1:numbofKeyPoints);
% 
% keypoints = points(keyInd,:);
startPoints = points(startInd,:);
endPoints = points(endInd,:);


%% Generate Synthetic Data set PART 2: Generate using PRM tool

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
keypoints = zeros(numbofKeyPoints,2);
num = 0;
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
    if  sum(i == selection) ~= 0 
        num  = num + 1;
        len = size(path,1);
        ind = ceil(rand() * len);
        keypoints(num,:) = path(ind,:);
    end
%     show(prm)
end
% save('SyntheticData.mat');

roundabouts = keypoints;
param.roundabouts = roundabouts;

%% ============= For Trajectory Compression Visualization===========================
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

%% For Trajectory Compression visualization 
% 2018.3.26: I lost the utility of this section
figure
param.numberOfVisualization = numbofSynTraj;
param.visualStyle = 'plot';
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];
Synvisualization(latLong,param);

hold on;
minn = param.axisRange([1,3]);
maxx = param.axisRange([2,4]);
Xlim = xlim;
Ylim = ylim;
pp = patch([.4 Xlim(2)-.4 Xlim(2)-.4 .4],[.4 .4 Ylim(2)-.4 Ylim(2)-.4],[1 1 1]);
pp.FaceAlpha = 0.75;
pp.LineStyle = 'none';


weights = param.weight;
nodeSize = (weights+1);
nodeSize = 60 + 500*(nodeSize - min(nodeSize))/(max(nodeSize)-min(nodeSize));
keypoints(:,3) = nodeSize(1:size(keypoints,1));

hold on;
scatter(keypoints(:,2),keypoints(:,1),keypoints(:,3),'^','MarkerFaceColor','[0.3010    0.7450    0.9330]','MarkerEdgeColor',[0 0 0],'LineWidth',2);

param.visualStyle = 'weightedSP';
param.weight = FastSyncResult.weight;
Synvisualization(SPs,param);

a = gca;
axis(a,'square')
a.LineWidth = 4;
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

%%
numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 5;        
param.maxLayer = 100; % this is for manual termination.
param.epsilon = 0.025;

str_save2 = num2str(param.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';

param.epsilon = param.epsilon * pi/2;
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2

param.errorTolerance = param.epsilon * 2;
param.syncRoundabouts = true;

disp('=======FastSync...============');
FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);
SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];

[latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);
nodeCount(:,1:2) = FastSyncResult.X;

%%

%========== for synthesis ==========
KeyPointsIndex = 1:numbofKeyPoints;
%========== for synthesis ==========

param.visualStyle = 'heatmap'; 
param.visualthreshold = 1;
param.SP_pair_indeces = SP_pair_indeces;
param.nodeCount = nodeCount;
param.visualArrow = true;
param.isNodeColor = false;
param.number = false;
param.idx0 = KeyPointsIndex(1);
% visualization(SP_pairs,param);
% param.number = false;

SyntheticCompressedVisualization(SP_pairs,param,KeyPointsIndex(2:end));

hold on;
% plot(keypoints(:,2),keypoints(:,1),'p','MarkerSize',25,'MarkerFaceColor','[.6 .6 .6]','Color',[0 0 0],'LineWidth',2);
a = gca;
axis(param.axisRange)
axis(gca,'square')
set(a,'XTick',[],'XTickLabel',[]);
set(a,'YTick',[],'YTickLabel',[]);
box on;
a.Position = [0 0 1 1];
a.LineWidth = 4;
f = gcf;
pos =  f.Position;
if pos(4) < pos(3)
    pos(3) = pos(4);
end
f.Position = pos;
hold off;
