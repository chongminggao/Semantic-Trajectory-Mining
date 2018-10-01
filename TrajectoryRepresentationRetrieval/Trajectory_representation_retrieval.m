%% Trajectory_representation_retrieval
% clear;
addpath('..');
dbstop if error;
%%
% 
% %Kaggle porto
% param.inputFile = '../Data/Kaggle/train.csv';
% param.readingNumOfTraj = 2000; %toltalnumber 1710670
% param.img = '../Data/Portugal.png';
% param.imgMap = '../Data/Portugal.png';
% param.imgNetwork = '../Data/Portugal_network_big.png';
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords,visitingTime] = kaggle_trajectory_reading(param);
%     load('../Data/Raw_Kaggle.mat')
% end
% % param.axisRange = [-8.6986 -8.5455 41.1105 41.2574]; %boundary of Portugal(Kaggle dataset)
% param.axisRange = [-8.7024 -8.5487 41.1347 41.2459]; % for illustration
% param.inChina = false;
% str_save1 = 'Kaggle';
% 
% % Sampling trajectory:



% %T-Drive
% param.inputFile = 'Data/T_Drive';
% param.readingNumOfTraj = 10000;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords,visitingTime] =  TDrive_trajectory_reading(param);
%     load('../Data/Raw_tdrive.mat');
% end
% param.imgMap = 'Data/beijing1.png';
% param.img = 'figs/Tdrive_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% param.inChina = true;
% str_save1 = 'TDrive';


% GeoLife
param.inputFile = '../Data/GeoLife';
param.readingNumOfTraj = 1000;
if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords,visitingTime] = GeoLife_trajectory_reading(param);
    load('../Data/Raw_geolife.mat');
end
param.img = '../Data/beijing1.png';
% param.img = 'figs/GeoLife_raw.bmp';
param.imgMap = '../Data/beijing1.png';
param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
param.inChina = true;
% latLong  = SplitOneTrajectory2Many(latLong,100);
str_save1 = 'GeoLife';

% %Chengdu
% param.inputFile = 'Data/Chengdu/x20140812.txt';
% param.readingNumOfTraj = 1000000;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords,visitingTime] = Chengdu_trajectory_reading(param);
%     load('../Data/Raw_chengdu.mat');
% end
% param.imgMap = '../Data/chengdu.png';
% param.img = '../Data/chengdu.png';
% param.axisRange = [103.9135 104.1799 30.5383 30.7651]; % boundary of Chengdu
% param.inChina = true;
% str_save1 = 'chengdu';

% %Shanghai
% param.inputFile = 'Data/Shanghai/Taxi_070220';
% param.readingNumOfTraj = 1000000;
% param.imgMap = '../Data/shanghai.png';
% param.img = '../Data/shanghai.png';
% param.axisRange = [121.2589 121.5878 31.0800 31.3660]; % boundary of Shanghai
% param.inChina = true;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords,visitingTime] = Shanghai_trajectory_reading(param);
%     load('../Data/Raw_shanghai.mat');
% end
% str_save1 = 'shanghai';

% basic clear procedure:
fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecord,size(latLong,1));

disp('=======specify the boundary============');

visitingTime(latLong(:,3) < param.axisRange(1)) = [];
latLong(latLong(:,3) < param.axisRange(1),:) = [];
visitingTime(latLong(:,3) > param.axisRange(2)) = [];
latLong(latLong(:,3) > param.axisRange(2),:) = [];
visitingTime(latLong(:,2) < param.axisRange(3)) = [];
latLong(latLong(:,2) < param.axisRange(3),:) = [];
visitingTime(latLong(:,2) > param.axisRange(4)) = [];
latLong(latLong(:,2) > param.axisRange(4),:) = [];
visitingTime(find(isnan(latLong(:,2)))) = [];
latLong(find(isnan(latLong(:,2))),:) = [];
visitingTime(find(isnan(latLong(:,3)))) = [];
latLong(find(isnan(latLong(:,3))),:) = [];

fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecord,size(latLong,1));

% %% For debug
% temp1 = [254.6522  492.1597   40.5807  283.9862];
% oriscale = [0        1047           0        1073];
% temp2(1) = param.axisRange(1) + (param.axisRange(2) - param.axisRange(1))/oriscale(2) * temp1(1);
% temp2(2) = param.axisRange(1) + (param.axisRange(2) - param.axisRange(1))/oriscale(2) * temp1(2);
% temp2(4) = param.axisRange(4) - (param.axisRange(4) - param.axisRange(3))/oriscale(4) * temp1(3);
% temp2(3) = param.axisRange(4) - (param.axisRange(4) - param.axisRange(3))/oriscale(4) * temp1(4);
% 
% latLong(latLong(:,3) < temp2(1),:) = [];
% latLong(latLong(:,3) > temp2(2),:) = [];
% latLong(latLong(:,2) < temp2(3),:) = [];
% latLong(latLong(:,2) > temp2(4),:) = [];


%% Further reduce the size:

% maxSize = 5000000;
% latLong(maxSize+1:end,:) = [];
% visitingTime(maxSize+1:end) = [];

%%

% traN = 1000;
% [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
% numberOfTrajectories = length(index_of_trajectory);
% latLong(pointer_start(traN+1):end,:) = [];
% visitingTime(pointer_start(traN+1):end,:) = [];


%%
% param.numberOfVisualization = 96;
% 
% param.visualStyle = 'plot';
% param.visualRoundabouts = false;
% 
% visualization(latLong,param);


%% Synchronization clustering 
[Distance_mean,D_upDown,D_leftRight] = CalculateapDistance(param);

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

disp('=======FastSync...============');
FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);
SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];

% % Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].

[latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount,nodeCountIdx,node_visual_count] = nodeCounting(SP_pairs,SP_pair_indeces);
latLong_next_level = Match_latLong_to_next_level(latLong,FastSyncResult);
try 
    nodeCount(:,1:2) = FastSyncResult.X;
catch
    templen = size(FastSyncResult.X,1) - size(nodeCount,1);
    nodeCount = [nodeCount;zeros(templen,3)];
    nodeCountIdx = [nodeCountIdx;zeros(templen,1)];
    nodeCount(:,1:2) = FastSyncResult.X;
end

%
param.nodeSize_M = [10 400];
param.edgeSize_M = [1.5 8];

param.visualStyle = 'heatmap';
param.visualthreshold = 2;
param.SP_pair_indeces = SP_pair_indeces;
param.nodeCount = nodeCount;
param.visualArrow = true;
param.isNodeColor = false;
param.number = false;
param.node_visual_count = node_visual_count;
% visualization(SP_pairs,param);
param.number = false;
%% Level 1
param_1 = param;
numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param_1.Knn = 5;        
param_1.maxLayer = 50; % this is for manual termination.
param_1.epsilon = 800;
str_save2 = num2str(param_1.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';
param_1.epsilon = (param_1.epsilon / Distance_mean * pi/2);
param_1.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2

disp('============Hierarchical FastSync...============');
FastSyncResult_1 = Fast_Hierarchical_Synchronization(latLong_next_level(:,[2,3]),param_1);
SPs_1 = [ones(FastSyncResult_1.numberOfPrototypes,1),FastSyncResult_1.X];

% % Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].

[latLong_new_representation_1,latLong_using_prototypes_index_1,SP_pairs_1, SP_pair_indeces_1,transferCount_1] = matching_to_SPs(latLong_next_level,FastSyncResult_1);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount_1,nodeCountIdx_1,node_visual_count_1] = nodeCounting(SP_pairs_1,SP_pair_indeces_1);
latLong_next_level_1 = Match_latLong_to_next_level(latLong_next_level,FastSyncResult_1);

try 
    nodeCount_1(:,1:2) = FastSyncResult_1.X;
catch
    templen = size(FastSyncResult_1.X,1) - size(nodeCount_1,1);
    nodeCount_1 = [nodeCount_1;zeros(templen,3)];
    nodeCountIdx_1 = [nodeCountIdx_1;zeros(templen,1)];
    nodeCount_1(:,1:2) = FastSyncResult_1.X;
end


%
param_1.nodeSize_M = [20 800];
param_1.edgeSize_M = [1.5 8];

param_1.visualStyle = 'heatmap';
param_1.visualthreshold = 2;
param_1.SP_pair_indeces = SP_pair_indeces_1;
param_1.nodeCount = nodeCount_1;
param_1.visualArrow = true;
param_1.isNodeColor = false;
param_1.number = false;
param_1.node_visual_count = node_visual_count_1;
% visualization(SP_pairs_1,param_1);
param_1.number = false;

%%  Level 2
param_2 = param_1;
numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param_2.Knn = 5;        
param_2.maxLayer = 50; % this is for manual termination.
param_2.epsilon = 1000;
str_save2 = num2str(param_2.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';
param_2.epsilon = (param_2.epsilon / Distance_mean * pi/2);
param_2.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2

disp('============Hierarchical FastSync...============');
FastSyncResult_2 = Fast_Hierarchical_Synchronization(latLong_next_level_1(:,[2,3]),param_2);
SPs_2 = [ones(FastSyncResult_2.numberOfPrototypes,1),FastSyncResult_2.X];

% % Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].

[latLong_new_representation_2,latLong_using_prototypes_index_2,SP_pairs_2, SP_pair_indeces_2,transferCount_2] = matching_to_SPs(latLong_next_level_1,FastSyncResult_2);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount_2,nodeCountIdx_2,node_visual_count_2] = nodeCounting(SP_pairs_2,SP_pair_indeces_2);
latLong_next_level_2 = Match_latLong_to_next_level(latLong_next_level_1,FastSyncResult_2);

try 
    nodeCount_2(:,1:2) = FastSyncResult_2.X;
catch
    templen = size(FastSyncResult_2.X,1) - size(nodeCount_2,1);
    nodeCount_2 = [nodeCount_2;zeros(templen,3)];
    nodeCountIdx_2 = [nodeCountIdx_2;zeros(templen,1)];
    nodeCount_2(:,1:2) = FastSyncResult_2.X;
end

param_2.nodeSize_M = [30 1000];
param_2.edgeSize_M = [2 10];
param_2.NodelineWidth = 1.5;
%
param_2.visualStyle = 'heatmap';
param_2.visualthreshold = 2;
param_2.SP_pair_indeces = SP_pair_indeces_2;
param_2.nodeCount = nodeCount_2;
param_2.visualArrow = true;
param_2.isNodeColor = false;
param_2.number = false;
param_2.node_visual_count = node_visual_count_2;
% visualization(SP_pairs_2,param_2);
param_2.number = false;


%%  Level 3
param_3 = param_1;
numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param_3.Knn = 5;        
param_3.maxLayer = 50; % this is for manual termination.
param_3.epsilon = 1500;
str_save2 = num2str(param_3.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';
param_3.epsilon = (param_3.epsilon / Distance_mean * pi/2);
param_3.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2

disp('============Hierarchical FastSync...============');
FastSyncResult_3 = Fast_Hierarchical_Synchronization(latLong_next_level_2(:,[2,3]),param_3);
SPs_3 = [ones(FastSyncResult_3.numberOfPrototypes,1),FastSyncResult_3.X];

% % Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].

[latLong_new_representation_3,latLong_using_prototypes_index_3,SP_pairs_3, SP_pair_indeces_3,transferCount_3] = matching_to_SPs(latLong_next_level_2,FastSyncResult_3);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount_3,nodeCountIdx_3,node_visual_count_3] = nodeCounting(SP_pairs_3,SP_pair_indeces_3);
latLong_next_level_2 = Match_latLong_to_next_level(latLong_next_level_2,FastSyncResult_3);

try 
    nodeCount_3(:,1:2) = FastSyncResult_3.X;
catch
    templen = size(FastSyncResult_3.X,1) - size(nodeCount_3,1);
    nodeCount_3 = [nodeCount_3;zeros(templen,3)];
    nodeCountIdx_3 = [nodeCountIdx_3;zeros(templen,1)];
    nodeCount_3(:,1:2) = FastSyncResult_3.X;
end

param_3.nodeSize_M = [40 1300];
param_3.edgeSize_M = [3 12];
param_3.NodelineWidth = 2;

%
param_3.visualStyle = 'heatmap';
param_3.visualthreshold = 2;
param_3.SP_pair_indeces = SP_pair_indeces_3;
param_3.nodeCount = nodeCount_3;
param_3.visualArrow = true;
param_3.isNodeColor = false;
param_3.number = false;
param_3.node_visual_count = node_visual_count_3;
% visualization(SP_pairs_3,param_3);
param_3.number = false;
%% 3-D plot


Mapping_to_son_1  = Map_this_to_last(FastSyncResult_1.Map_Prototype_To_Original,FastSyncResult.Map_Original_To_Prototype);
param_1.Mapping_to_son = Mapping_to_son_1;
param_1.lastNodeCount = nodeCount;

% visualization3(SP_pairs, param, SP_pairs_1, param_1);

Mapping_to_son_2  = Map_this_to_last(FastSyncResult_2.Map_Prototype_To_Original,FastSyncResult_1.Map_Original_To_Prototype);
param_2.Mapping_to_son = Mapping_to_son_2;
param_2.lastNodeCount = nodeCount_1;

Mapping_to_son_3  = Map_this_to_last(FastSyncResult_3.Map_Prototype_To_Original,FastSyncResult_2.Map_Original_To_Prototype);
param_3.Mapping_to_son = Mapping_to_son_3;
param_3.lastNodeCount = nodeCount_2;

visualization3( SP_pairs, param, SP_pairs_1, param_1,SP_pairs_2, param_2,SP_pairs_3, param_3);

%% Trajectory Semantics Retrieval using API 
ROILevel = 4;
TraLevel = 4;

[Category,Rate] = LabelConstructor(SPs, param.inChina);
% [Category1,Rate1] =  RemoveIndFromRate([1,3,5,9,16,17,18,10,21], Category,Rate);
LabelSimilarityMat = LabelMatConstructor(Rate,ROILevel);

[Category_1,Rate_1] = LabelConstructor(SPs_1, param.inChina);
[Category_2,Rate_2] = LabelConstructor(SPs_2, param.inChina);
LabelSimilarityMat_1 = LabelMatConstructor(Rate_1,ROILevel);
LabelSimilarityMat_2 = LabelMatConstructor(Rate_2,ROILevel);

TrajRate = TrajectoryLableConstructor(latLong_using_prototypes_index,Rate);
TrajSimMat = TrajMatSimConstructor(TrajRate, TraLevel);



[DTW_Similar_Mat, LCSS_Similar_Mat, EDR_Similar_Mat, Frechet_Similar_Mat] = Trajectory_Index_DTW_LCSS_EDR_Frechet(latLong_using_prototypes_index, FastSyncResult.X,param);

%% ROI statistic information preparing

type1 = 3; % number of similar degree neighborhoods
type2 = 3; % number of similar neighbors' degree distribution neighborhoods
bin = 5;
type3 = 3; % number of similar visiting time distribution similar neighborhoods
type4 = 3; % number of similar staying time distribution similar neighborhoods
type5 = 3; % number of Domain Similar Neighobors;
timeDistributionBin = 15;

[type3Neighorhoods, type4Neighorhoods] = ROITimeCount(latLong, FastSyncResult.Map_Original_To_Prototype, visitingTime, size(nodeCount,1),timeDistributionBin,type3,type4);
[SourceNeighbor,weightedDegreeCount] = findNeighborsOfSourceSP(SP_pair_indeces,size(param.nodeCount,1),nodeCount(:,3));
type1Neighorhoods = Type1Constructor(nodeCount,type1);
type2Neighorhoods = Type2Constructor(...
    SourceNeighbor,bin,weightedDegreeCount,...
    transferCount,type2);
type5Neighorhoods = Type5Constructor(LabelSimilarityMat,type5);

% Add layer 1 and layer 2
cell_type1Neighorhoods{1} = type1Neighorhoods;
cell_type2Neighorhoods{1} = type2Neighorhoods;
cell_type3Neighorhoods{1} = type3Neighorhoods;
cell_type4Neighorhoods{1} = type4Neighorhoods;
cell_type5Neighorhoods{1} = type5Neighorhoods;


[cell_type3Neighorhoods{2},cell_type4Neighorhoods{2}] = ROITimeCount(latLong, FastSyncResult_1.Map_Original_To_Prototype, visitingTime, size(nodeCount_1,1),timeDistributionBin,type3,type4);
[cell_type3Neighorhoods{3},cell_type4Neighorhoods{3}] = ROITimeCount(latLong, FastSyncResult_2.Map_Original_To_Prototype, visitingTime, size(nodeCount_2,1),timeDistributionBin,type3,type4);

[SourceNeighbor_1,weightedDegreeCount_1] = findNeighborsOfSourceSP(SP_pair_indeces_1,size(nodeCount_1,1),nodeCount_1(:,3));
[SourceNeighbor_2,weightedDegreeCount_2] = findNeighborsOfSourceSP(SP_pair_indeces_2,size(nodeCount_2,1),nodeCount_2(:,3));
cell_type1Neighorhoods{2} = Type1Constructor(nodeCount_1,type1);
cell_type1Neighorhoods{3} = Type1Constructor(nodeCount_2,type1);
cell_type2Neighorhoods{2} = Type2Constructor(...
    SourceNeighbor_1,bin,weightedDegreeCount_1,...
    transferCount_1,type2);
cell_type2Neighorhoods{3} = Type2Constructor(...
    SourceNeighbor_2,bin,weightedDegreeCount_2,...
    transferCount_2,type2);

cell_type5Neighorhoods{2} = Type5Constructor(LabelSimilarityMat_1,type5);
cell_type5Neighorhoods{3} = Type5Constructor(LabelSimilarityMat_2,type5);