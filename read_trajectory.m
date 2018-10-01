%% visulization while reading data directly from raw file

clear;

% %Kaggle porto
% param.inputFile = 'Data/Kaggle/train.csv';
% param.readingNumOfTraj = 1000; %toltalnumber 1710670
% param.img = 'Data/Portugal.png';
% param.imgMap = 'Data/Portugal.png';
% param.imgNetwork = 'Data/Portugal_network_big.png';
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = kaggle_trajectory_reading(param);
% end
% % param.axisRange = [-8.6986 -8.5455 41.1105 41.2574]; %boundary of Portugal(Kaggle dataset)
% param.axisRange = [-8.7024 -8.5487 41.1347 41.2459]; % for illustration
% param.inChina = false;
% str_save1 = 'Kaggle';
% % Sampling trajectory:
% traN = 10000;
% [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
% numberOfTrajectories = length(index_of_trajectory);
% latLong(pointer_start(traN+1):end,:) = [];

% 
% %T-Drive
% param.inputFile = 'Data/T_Drive';
% param.readingNumOfTraj = 100;
% param.imgMap = 'Data/beijing1.png';
% param.img = 'figs/Tdrive_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% param.inChina = true;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords] = TDrive_trajectory_reading(param);
%     load('Data/Tdrive.mat');
% end
% str_save1 = 'TDrive';

% GeoLife
param.inputFile = 'Data/GeoLife';
param.readingNumOfTraj = 5000;
param.img = 'Data/beijing1.png';
% param.img = 'figs/GeoLife_raw.bmp';
param.imgMap = 'Data/beijing1.png';
param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
param.inChina = false;

if ~exist('latLong')
    [latLong,numberOfEffectiveRecords] = GeoLife_trajectory_reading(param);
%     load('Data/str_save/GeoLife_0p04_Embedding.mat');
end
% latLong  = SplitOneTrajectory2Many(latLong,100);
str_save1 = 'GeoLife';

% % Hurricane
% param.inputFile = 'Data/Hurricane/Hurricane.txt';
% param.readingNumOfTraj = 10000;
% param.imgMap = 'Data/Atlantic.png';
% param.img = 'Data/Atlantic.png';
% param.imgNetwork = 'Data/Hurricane_Network.png';
% param.axisRange = [-113.7077   44.7131    5.2206   74.7249]; % boundary of Atlantic
% param.inChina = false;
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Hurricane_trajectory_reading(param);
% end
% str_save1 = 'Hurricane';

% % Migration
% param.inputFile = 'Data/Migration/Swallows.csv';
% param.readingNumOfTraj = 10000;
% param.img = 'Data/SA.png';
% param.imgMap = 'Data/SA.png';
% param.axisRange = [-69.7465  -33.8018  -39.6058   16.8029]; % boundary of Atlantic
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Migration_trajectory_reading(param);
% end
% latLong  = SplitOneTrajectory2Many(latLong,3);
% str_save1 = 'Migration';
% param.inChina = false;
% 
% % FourSquare
% % param.inputFile = 'Data/Foursquare-JiHui-Content-Network/CA Dataset/checkin_CA_venues.txt';
% param.inputFile = 'Data/Foursquare-JiHui-Content-Network/CA Dataset/checkin_CA_venues.txt';
% param.readingNumOfTraj = 10000000;  
% param.imgMap = 'Data/LosAngles_small300.png';
% param.img = 'Data/LosAngles_small300.png';
% param.imgNetwork = 'Data/LosAngles_small300.png';
% % param.axisRange = [-118.5136   -117.7968    33.5952   34.1743]; % boundary of Atlantic
% param.axisRange = [-118.5301,  -118.0508  33.7917  34.1618];
% param.inChina = false;
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Foursquare_trajectory_reading(param);
% end
% str_save1 = 'Foursquare';


% basic clear procedure:
fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

disp('=======specify the boundary============');


latLong(latLong(:,3) < param.axisRange(1),:) = [];
latLong(latLong(:,3) > param.axisRange(2),:) = [];
latLong(latLong(:,2) < param.axisRange(3),:) = [];
latLong(latLong(:,2) > param.axisRange(4),:) = [];
latLong(find(isnan(latLong(:,2))),:) = [];
latLong(find(isnan(latLong(:,3))),:) = [];

fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

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


%% visualization
 


param.numberOfVisualization = 30000;

param.visualStyle = 'plot';
visualization(latLong,param);




%% Synchronization clustering 

% Specify the number of grid partition.
numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 10;        
param.maxLayer = 50; % this is for manual termination.
param.epsilon = 0.01;

str_save2 = num2str(param.epsilon); % for the data saving usage.
idx_point = strfind(str_save2,'.');
str_save2(idx_point) = 'p';

param.epsilon = param.epsilon * pi/2;
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2


disp('=======FastSync...============');
FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);
SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];



% 
% param.visualStyle = 'weightedSP';
% param.weight = FastSyncResult.weight;
% visualization(SPs,param);




%% Trace matching from prototype points to original points

% Specify the tracing indices:
indices = 310; 
isDisplay = true;

last_layer_indeces = Tracing_particular_point_from_prototype_to_original(FastSyncResult.map_record,indices,latLong(:,[2 3]),FastSyncResult.numberOfPartitions,isDisplay,param);

SPs = [ones(length(last_layer_indeces),1),...
    latLong(last_layer_indeces,2),latLong(last_layer_indeces,3)];
param.visualStyle = 'scatter';
visualization(SPs,param);


%% Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].

[latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);
nodeCount(:,1:2) = FastSyncResult.X;

%%
param.visualStyle = 'heatmap';
param.visualthreshold = 2;
param.SP_pair_indeces = SP_pair_indeces;
param.nodeCount = nodeCount;
param.visualArrow = true;
param.isNodeColor = false;
param.number = true;
visualization(SP_pairs,param);
param.number = false;

% axis([ 100 1351   140        1201]);
% h = gcf;
% h.Position = [483 179 625 530];

%% Query the poi category of the ROI;




str_save = strcat('Data/str_save/',str_save1,'_',str_save2,'.mat');

%% save data for embedding, due to that we need not proceed from scratch.
str_save = strcat('Data/str_save/',str_save1,'_',str_save2,'.mat');
save(str_save);
disp('save successfully!');

%%
atleastN = 2;
[numOfTrajectory,index_of_trajectory,latLong_using_prototypes_index] = GetNumberOfTrajectory(latLong_using_prototypes_index,atleastN);

%% Trajectory Semantics Retrieval using API 
ROILevel = 5;
TraLevel = 5;

[Category,Rate] = LabelConstructor(SPs, param.inChina);

% [Category1,Rate1] =  RemoveIndFromRate([1,3,5,9,16,17,18,10,21], Category,Rate);
LabelSimilarityMat = LabelMatConstructor(Rate,ROILevel);


TrajRate = TrajectoryLableConstructor(latLong_using_prototypes_index,Rate);
TrajSimMat = TrajMatSimConstructor(TrajRate, TraLevel );
% 
% [ia,ib] = sort(LabelSimilarityMat(206,:),'descend');
% ia = ia';
% ib=ib';
% ia = [ia ib];
% visualizeTopKSP(FastSyncResult.X, SP_pairs, param,206,ia(2:30,2));


%% Trajectory Embedding

% 1. Asymmetric SP embedding
param.dim = 100;
param.IterTime = 2;
param.NegativeSamples = 3;
param.learningRate = 0.15;
param.window = 1;
param.similarNum = 5;
param.bin = 5;
param.degreeRate = 0.5;

[S, T, SP_neighbors] =  AsymmetricSPEmbedding(SP_pair_indeces, latLong_using_prototypes_index, transferCount, param);
SPEmbeddedVector = [S,T];
[TrajEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index,'sum');
disp('Embedding done!');
% str_save_Embed = strcat('Data/str_save/',str_save1,'_',str_save2,'_Embedding','.mat');

%% Synthetic POI accuracy evaluation
    accuracyOfROIDetection = 0;
    k = size(SPEmbeddedVector,1)-1;
    Num = 20;
    for i = 1 : length(Num)
        ii = ceil(rand() * size(SPEmbeddedVector,1));
        [TopKIdx,minIdx] = findTopKSimilarSP(SPEmbeddedVector,k,ii,'E');
        accuracy = NDCGatK((1:k)', LabelSimilarityMat(ii,TopKIdx));
%         fprintf('round[%d]: Point[%d] accuracy:  %f\n',i,ii,accuracy);
        accuracyOfROIDetection = accuracyOfROIDetection + accuracy;
    end
    accuracyOfROIDetection = accuracyOfROIDetection / length(Num);
    fprintf('Average accuracy:  %f\n',accuracyOfROIDetection);

%
%% Find the Top-k most similar SP
param.number = false;
k = 4;
idx = 9;
[TopKIdx,minIdx] = findTopKSimilarSP(SPEmbeddedVector,k,idx,'E');

visualizeTopKSP(FastSyncResult.X, SP_pairs, param,idx,TopKIdx);


str_save_Embed = strcat('Data/str_save/',str_save1,'_',str_save2,'_Embedding','.mat');
save(str_save_Embed);
disp('save successfully!');

[TrajEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index,'sum');


%% Save embedding result 

% %% Visualizize the SPs embedding using Kmeans
% param.K = 4;
% idx = kmeans(SPEmbeddedVector, param.K);
% 
% param.idx = idx;
% 
% decisionmap = visualizeEmbedding(FastSyncResult.X, SP_pairs, param);


%% 2. trajectory embedding using addition model
% scatter(T(:,1),T(:,2))



% %% Trajectory semantic clustering
% param.K = 4;
% Tra_idx = kmeans(TrajEmbeddedVector, param.K);
% param.Tra_idx = Tra_idx;
% % visualization
% param.numberOfVisualization = 2000;
% visualTrajectoryEmbedding(latLong,param,1500);


% %% Derive other trajectory kmeans result:
% 
% 
% param.K = 7;
% 
% Tra_idx = kmeans(TrajEmbeddedVector, param.K);
% param.Tra_idx = Tra_idx;
% % visualization
% param.numberOfVisualization = 102;
% visualTrajectoryEmbedding(latLong,param);

% %% Trajectory distance matrix calculation using DTW=====================
% Trajectory_distance_mat_DTW = Tra_distance_matrix_using_dtw_index(latLong_using_prototypes_index, FastSyncResult.X);
% disp('DTW : 1. distance matrix done!');
% 
% similarityMat = max(max(Trajectory_distance_mat_DTW)) -  Trajectory_distance_mat_DTW;
% Tra_idx = spectral_clustering(similarityMat,param.K);
% disp('DTW : 2. spectral clustering done!');
% 
% param.Tra_idx = Tra_idx;
% % visualization
% param.numberOfVisualization = 10000;
% visualTrajectoryEmbedding(latLong,param);


%% visualizeOneTrajectory

visualizeOneTrajectory(latLong,latLong_new_representation,latLong_using_prototypes_index,param,274,[]);

%% Find similar trajectories_using_TrajectoryEmbedding
k = 100;
compareK = 100;
idx = 16;
rate = 0.6;

fprintf('TrajectoryEmbedding: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
% Euclidean cosine
[TopK_distance,TopK_index] = findSimilarVectors(TrajEmbeddedVector,numOfTrajectory - 1,idx,'Euclidean');
% [~,TopK_index]= findSimilarTra_secondOrder(FastSyncResult.X,latLong_using_prototypes_index,latLong2SP,1,k,idx, 'multi');
TopK_index = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index,compareK, rate);
visualize_TopK_similar_trajectories(latLong,param,idx,compareK,TopK_index,index_of_trajectory);

%% 



TraRandNum = 3;
compareK = 100;
k = numOfTrajectory-1;
rate = 0;

NDCGK = zeros(TraRandNum, compareK);
NDCGK_DTW = zeros(TraRandNum, compareK);
NDCGK_Frechet = zeros(TraRandNum, compareK);
NDCGK_LCS = zeros(TraRandNum, compareK);
NDCGK_EDR = zeros(TraRandNum, compareK);

for iter = 1 : TraRandNum
    idx = ceil(rand() * numOfTrajectory)
    [~,TopKTrajIdx] = findSimilarVectors(TrajEmbeddedVector,numOfTrajectory - 1,idx,'Euclidean');
    [~, TopK_index_DTW] = Tra_distance_matrix_using_dtw_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
    [~, TopK_index_Frechet] = Tra_distance_matrix_using_Frechet_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
    [~, TopK_index_LCS] = Tra_distance_matrix_using_LCS_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
    tol = max(param.axisRange(2) - param.axisRange(1), param.axisRange(4) - param.axisRange(3))/10;
    [~, TopK_index_EDR] = Tra_distance_matrix_using_EDR_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1,tol);
    %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    TopKTrajIdx = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopKTrajIdx,compareK, rate);
    TopK_index_DTW = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index_DTW,compareK, rate);
    TopK_index_Frechet = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index_Frechet,compareK, rate);
    TopK_index_LCS = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index_LCS,compareK, rate);
    TopK_index_EDR = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index_EDR,compareK, rate);
    %=================================%=================================
    NDCGK(iter,:) = NDCGatK((1:compareK)', TrajSimMat(idx,TopKTrajIdx));
    NDCGK_DTW(iter,:) = NDCGatK((1:compareK)', TrajSimMat(idx,TopK_index_DTW));
    NDCGK_Frechet(iter,:) = NDCGatK((1:compareK)', TrajSimMat(idx,TopK_index_Frechet));
    NDCGK_LCS(iter,:) = NDCGatK((1:compareK)', TrajSimMat(idx,TopK_index_LCS));
    NDCGK_EDR(iter,:) = NDCGatK((1:compareK)', TrajSimMat(idx,TopK_index_EDR));
    
%     visualize_TopK_similar_trajectories(latLong,param,idx,10,TopKTrajIdx,index_of_trajectory);
    
end

drawNDCG(NDCGK,NDCGK_DTW,NDCGK_Frechet,NDCGK_LCS,NDCGK_EDR);

%% Find similar trajectories_using_DTW
% fprintf('DTW: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
[~, TopK_index_DTW] = Tra_distance_matrix_using_dtw_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
% visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_DTW,index_of_trajectory);
%% Find similar trajectories_using_Frechet
% fprintf('Frechet: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
[~, TopK_index_Frechet] = Tra_distance_matrix_using_Frechet_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
% visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_Frechet,index_of_trajectory);
%% Find similar trajectories_using_LCS
% fprintf('LCS: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
[~, TopK_index_LCS] = Tra_distance_matrix_using_LCS_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
% visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_LCS,index_of_trajectory);
%% Find similar trajectories_using_EDR
% fprintf('EDR: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
tol = max(param.axisRange(2) - param.axisRange(1), param.axisRange(4) - param.axisRange(3))/10;
[~, TopK_index_EDR] = Tra_distance_matrix_using_EDR_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1,tol);
% visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_EDR,index_of_trajectory);
