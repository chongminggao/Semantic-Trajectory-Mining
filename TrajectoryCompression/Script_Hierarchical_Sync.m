%% Synchronization clustering 
[Distance_mean,D_upDown,D_leftRight] = CalculateapDistance(param);
param.Distance_mean = Distance_mean;
numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 5;        
param.maxLayer = 50; % this is for manual termination.

param.epsilon = 400;
str_save2 = num2str(param.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';
param.epsilon = (param.epsilon / Distance_mean * pi/2);
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2


param.visualStyle = 'heatmap';
param.visualthreshold = 2;
param.visualArrow = true;
param.isNodeColor = false;
param.number = false;


%% 
Max_epsilon_ratio = 0.05;
Max_epsilon = Distance_mean * Max_epsilon_ratio;
Max_nodeSize_M = [40 1400];
Max_edgeSize_M = [4 12];
Max_NodelineWidth = 1;

Layer = 4;
isVisual = true;

epsilon_meter = Max_epsilon./(Layer:-1:1);
epsilon = epsilon_meter / Distance_mean * pi/2;
for l = 1:Layer
    nodeSize(l,:) = Max_nodeSize_M./Layer * l;
    edgeSize(l,:) = Max_edgeSize_M./Layer * l;
end
NodelineWidth = Max_NodelineWidth./(Layer:-1:1);


% Initiation
param_multi = cell(Layer,1);
last_latLong_level = latLong;
last_FastSyncResult = [];
last_nodeCount = [];
isFirstLevel = true;

% Whether sync with or without roundabouts
param.syncRoundabouts = true;
param.visualRoundabouts = param.syncRoundabouts;

% Loop For obtain the hierarchical Sync.
for l = 1:Layer
    param.epsilon = epsilon(l);
    param.errorTolerance = param.epsilon * 1;
    
    param.nodeSize_M = nodeSize(l,:);
    param.edgeSize_M = edgeSize(l,:);
    param.NodelineWidth = NodelineWidth(l);
    fprintf('============Hierarchical FastSync Round [%d]...============',l);
    [param_l, latLong_level, FastSyncResult, nodeCount] = SingleSync(param, last_latLong_level, last_FastSyncResult, last_nodeCount, isFirstLevel,isVisual);
    isFirstLevel = false;
    param_multi{l} = param_l;

    last_latLong_level = latLong_level;
    last_FastSyncResult = FastSyncResult;
    last_nodeCount = nodeCount;
end



%% ReWriten


% ===============MultiResolution Visualization====================


visualization3_multi(param_multi);





