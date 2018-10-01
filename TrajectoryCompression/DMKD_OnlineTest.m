addpath('..')
dbstop if error;
%
boundary = 100; % side length of the map.
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];


numbofSynthesisPoints = 200; % number of points
numbofKeyPoints = 30;  % number of keypoints
numbofSynTraj = 200;  % number of trajectory

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


%% Generate Synthetic Data

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
Distance_mean = boundary;
param.Distance_mean = boundary;

%% ================= For Synthetic Trajectory Visualization ===========================
param.numberOfVisualization = numbofSynTraj;
param.visualStyle = 'plot';
param.axisRange = [0.5, boundary - 0.5 ,0.5, boundary - 0.5];
visualization(latLong_offline,param);

hold on;
plot(keypoints(:,2),keypoints(:,1),'^','MarkerSize',15,'MarkerFaceColor','[0.3010    0.7450    0.9330]','Color',[0 0 0],'LineWidth',2);
hold off;


%% Invoke hierarchical Sync Part 1: Initial the parameters

numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 5;        
param.maxLayer = 50; % this is for manual termination.


param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2


param.visualStyle = 'heatmap';
param.visualthreshold = 1;
param.visualArrow = true;
param.isNodeColor = false;
param.number = true;


%% Invoke hierarchical Sync Part 2: Prepare iterations.
Max_epsilon_ratio = 0.10;
Max_epsilon = param.Distance_mean * Max_epsilon_ratio;
Max_nodeSize_M = [40 1400];
Max_edgeSize_M = [4 12];
Max_NodelineWidth = 1;

Layer = 10;
isVisual = false;


% Whether sync with or without roundabouts
param.syncRoundabouts = false;
param.visualRoundabouts = param.syncRoundabouts;

param_multi= cell(Layer,1);
epsilon_meter = Max_epsilon./Layer * (1:Layer);

% % ==============DMKD visualization parameters ===================
% epsilon_meter = [100 300 500 1000 3000];
% % ==============DMKD visualization parameters ===================

epsilon = epsilon_meter / Distance_mean * pi/2;
NodelineWidth = Max_NodelineWidth./Layer * (1:Layer);

%==========


for l = 1:Layer
    param.epsilon = epsilon(l);
    param.epsilon_meter = epsilon_meter(l);
    param.errorTolerance = param.epsilon * 1;
    param.nodeSize_M = Max_nodeSize_M./Layer * l;
    param.edgeSize_M = Max_edgeSize_M./Layer * l;
    param.NodelineWidth = NodelineWidth(l);
    param_multi{l} = param;
end


offline_ratio = 1.0;
numberOfTraj = size(latLong,1);
numberOfOffline = ceil(numberOfTraj * offline_ratio);
% Initiation
latLong_offline = latLong(1:numberOfOffline,:);
latLong_init = latLong_offline;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_offline,result_multi_offline, Time_without] =  InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);

% visualization3_multi(param_multi_offline);

%% Obtain the base network and merged network of online merge version

ratio_merge_base = 0.50;
numberOfMergeBase = ceil(numberOfOffline * ratio_merge_base);
numberOfmerge = numberOfOffline - numberOfMergeBase;

% Initiation
latLong_merge_base = latLong(1:numberOfMergeBase,:);
latLong_merge = latLong(numberOfMergeBase + 1: numberOfOffline,:);

latLong_merge(:,1) = -1;

latLong_init = latLong_merge_base;

% isVisual = true;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_merge_base, result_multi_merge_base] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);
[param_multi_merge, result_multi_merge] = invokeOnlineMerge(param_multi_merge_base,result_multi_merge_base,latLong_merge, isVisual);


%% Obtain the base network and merged network of online merge version

ratio_merge_base = 0.33;
numberOfMergeBase = ceil(numberOfOffline * ratio_merge_base);
numberOfmerge = numberOfOffline - numberOfMergeBase;

% Initiation
latLong_merge_base = latLong(1:numberOfMergeBase,:);
latLong_merge = latLong(numberOfMergeBase + 1: numberOfOffline,:);

latLong_merge(:,1) = -1;
latLong_merge(1:floor(length(latLong_merge)/2),1) = -2;

latLong_init = latLong_merge_base;

% isVisual = true;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_merge_base, result_multi_merge_base] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);
[param_multi_merge_2, result_multi_merge_2] = invokeOnlineMerge(param_multi_merge_base,result_multi_merge_base,latLong_merge, isVisual);


%% Conduct the online Truncate operation
ratio_truncate_base = 1.50;
numberOfTruncateBase = ceil(numberOfOffline * ratio_truncate_base);
numberOftruncate = numberOfTruncateBase - numberOfOffline;

% Initiation
latLong_truncate_base = latLong(1:numberOfTruncateBase,:);

% ===========================
latLong_truncate_base(numberOfTruncateBase - numberOftruncate + 1:end, 1) = -1;
% ===========================

latLong_truncate_index = numberOfOffline + 1: numberOfTruncateBase;

latLong_init = latLong_truncate_base;

% isVisual = true;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_truncate_base, result_multi_truncate_base] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);
[param_multi_truncate, result_multi_truncate] = invokeOnlineTruncate(param_multi_truncate_base,result_multi_truncate_base, latLong_truncate_index, isVisual);


%% Conduct the online Truncate operation
ratio_truncate_base = 1.70;
numberOfTruncateBase = ceil(numberOfOffline * ratio_truncate_base);
numberOftruncate = numberOfTruncateBase - numberOfOffline;

numberOfPart1 = floor(numberOftruncate/2);
% Initiation
latLong_truncate_base = latLong(1:numberOfTruncateBase,:);
% ===========================
latLong_truncate_base(numberOfTruncateBase - numberOftruncate + 1: numberOfTruncateBase - numberOftruncate + numberOfPart1,1) = -1;
latLong_truncate_base(numberOfTruncateBase - numberOftruncate + numberOfPart1 + 1:end,1) = -2;
% ===========================
latLong_truncate_index = numberOfOffline + 1: numberOfTruncateBase;

latLong_init = latLong_truncate_base;

% isVisual = true;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_truncate_base, result_multi_truncate_base] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);
[param_multi_truncate_2, result_multi_truncate_2] = invokeOnlineTruncate(param_multi_truncate_base,result_multi_truncate_base, latLong_truncate_index, isVisual);


%% ===============MultiResolution Visualization====================

% Prerequisit: isVisual = truel; in the Hiearachical Sync

% visualization3_multi(param_multi_offline);
% visualization3_multi(param_multi_merge);
% visualization3_multi(param_multi_truncate);

%% Compare the offline and online error


% DrawTheErrorLine(latLong,result_multi_offline,epsilon_meter);
% DrawTheErrorLine(latLong,result_multi_online,epsilon_meter);

result_compare_list = {result_multi_offline,result_multi_merge, result_multi_merge_2, result_multi_truncate, result_multi_truncate_2};

CompareTheErrorLine(latLong_offline,epsilon_meter,result_compare_list);
ll = legend('Offline: $100$','Merge: $50+50$','Merge: $34+33+33$','Split: $150-50$', 'Split: $166-33-33$');
% set(ll,'FontName','Times New Roman');
set(ll,'FontSize',18);
set(ll,'Interpreter', 'LaTeX');

%% 
synthetic_drawbbplot(epsilon_meter, result_multi_offline, latLong_offline)


%% Complete the Online network updating
% [param_multi, result_multi] = merge(param_multi, result_multi, oneLatLong)


%% Evaluate the online error




% for i = 1:numberOfTraj
%     [param_multi_online, result_multi_online] =
%     invokeOnlineMerge(param_multi_base,result_multi_base,latLong_Online, isVisual);
%     
% end