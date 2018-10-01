addpath('..')
addpath('OpenstreetMap_Handler')
dbstop if error;
%%
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

%% ================= For Trajectory Compression ===========================
param.numberOfVisualization = numbofSynTraj;
param.visualStyle = 'plot';
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];
visualization(latLong,param);

hold on;
plot(keypoints(:,2),keypoints(:,1),'^','MarkerSize',15,'MarkerFaceColor','[0.3010    0.7450    0.9330]','Color',[0 0 0],'LineWidth',2);
hold off;


%% Invoke hierarchical Sync Part 1: Initial the parameters

roundabouts = keypoints;
param.roundabouts = roundabouts;
Distance_mean = boundary;
param.Distance_mean = boundary;
numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 5;        
param.maxLayer = 50; % this is for manual termination.

str_save2 = num2str(param.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';
param.epsilon = (param.epsilon / Distance_mean * pi/2);
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2


param.visualStyle = 'heatmap';
param.visualthreshold = 1;
param.visualArrow = true;
param.isNodeColor = false;
param.number = false;


%% Invoke hierarchical Sync Part 2: Invoke iterations.
Max_epsilon_ratio = 0.05;
Max_epsilon = param.Distance_mean * Max_epsilon_ratio;
Max_nodeSize_M = [40 1400];
Max_edgeSize_M = [4 12];
Max_NodelineWidth = 1;

Layer = 10;
isVisual = false;

epsilon_meter = Max_epsilon./Layer * (1:Layer);
epsilon = epsilon_meter / Distance_mean * pi/2;
for l = 1:Layer
    nodeSize(l,:) = Max_nodeSize_M./Layer * l;
    edgeSize(l,:) = Max_edgeSize_M./Layer * l;
end
NodelineWidth = Max_NodelineWidth./Layer * (1:Layer);

% Initiation
last_FastSyncResult.latLong_via_ROI = latLong;
last_FastSyncResult.nodeCount=[];

% Whether sync with or without roundabouts
param.syncRoundabouts = true;
param.visualRoundabouts = param.syncRoundabouts;


% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_offline,result_multi_offline] =  InvokeHierarchicalSync(Layer, param, last_FastSyncResult,isVisual,epsilon,nodeSize,edgeSize,NodelineWidth);

%% ===============MultiResolution Visualization====================
if isVisual
    visualization3_multi(param_multi);
end

%% Evaluate the relationship between Representative Error and Epsilon radius.



DrawTheErrorLine(latLong,result_multi_offline,epsilon_meter);



