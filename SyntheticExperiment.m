SyntheticDataGeneration;

%% Synchronization clustering 

% Specify the number of grid partition.
numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 10;        
param.maxLayer = 30; % this is for manual termination.
param.epsilon = 0.02;

param.epsilon = param.epsilon * pi/2;
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2


disp('=======FastSync...============');
FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);

SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];
param.visualStyle = 'weightedSP';
param.weight = FastSyncResult.weight;
visualization(SPs,param);

hold on;
plot(keypoints(:,2),keypoints(:,1),'p','MarkerSize',25,'MarkerFaceColor','[.6 .6 .6]','Color',[0 0 0],'LineWidth',2);
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

%% Matching original trajectories to new prototype POIs.
% SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
% SP_pair_indeces is the SPs indeces pair as well as its count presented in
% the trajectory transition, whose row is [A_index, B_index, count].



[latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
% [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
[nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);

%========== for synthesis ==========
KeyPointsIndex = SyntheticKeyPointSearcher(latLong_using_prototypes_index,numbofKeyPoints);
KeyPointsIndex = unique(KeyPointsIndex,'stable');
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

SyntheticheatMap(SP_pairs,param,KeyPointsIndex(2:end));


hold on;
% plot(keypoints(:,2),keypoints(:,1),'p','MarkerSize',25,'MarkerFaceColor','[.6 .6 .6]','Color',[0 0 0],'LineWidth',2);
a = gca;
axis(gca,'square')
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
Embedding_time = 10;
accuracyOfROIDetection = zeros(Embedding_time,1);

NDCGK = zeros(Embedding_time, numbofSynTraj-1);
NDCGK_DTW = zeros(Embedding_time, numbofSynTraj-1);
NDCGK_Frechet = zeros(Embedding_time, numbofSynTraj-1);
NDCGK_LCS = zeros(Embedding_time, numbofSynTraj-1);
NDCGK_EDR = zeros(Embedding_time, numbofSynTraj-1);

for iter = 1:Embedding_time
    %% Trajectory Embedding

    % 1. Asymmetric SP embedding
    param.dim = 50;
    param.IterTime = 2;
    param.NegativeSamples = 3;
    param.learningRate = 0.15;  % should pay attention to tune it so it can let A and S fit in the appropriate range.
    param.window = 0;
    param.similarNum = 0;
    param.bin = 10;
    param.degreeRate = 0.8;

    [S, T, SP_neighbors] =  AsymmetricSPEmbedding_forSynthesis(SP_pair_indeces, latLong_using_prototypes_index, transferCount, KeyPointsIndex, param);
    SPEmbeddedVector = [S,T];
    [TrajEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index,'sum');
    disp('Embedding done!');



    % %% Find the Top-k most similar SP
    % param.number = false;
    % k = length(KeyPointsIndex)- 1;
    % idx = KeyPointsIndex(1);
    % [TopKIdx,minIdx] = findTopKSimilarSP(SPEmbeddedVector,k,idx,'E');
    % 
    % visualizeTopKSP(FastSyncResult.X, SP_pairs, param,idx,TopKIdx);
    % 


    %%
%     accuracyOfROIDetection = 0;
    k = length(KeyPointsIndex)- 1;
    for i = 1 : length(KeyPointsIndex)
        ii = KeyPointsIndex(i);
        [TopKIdx,minIdx] = findTopKSimilarSP(SPEmbeddedVector,k,ii,'E');
        accuracy = length(intersect(TopKIdx,KeyPointsIndex))/(length(KeyPointsIndex) - 1);
        fprintf('round[%d]: Point[%d] accuracy:  %f\n',i,ii,accuracy);
        accuracyOfROIDetection(iter) = accuracyOfROIDetection(iter) + accuracy;
    end
    accuracyOfROIDetection(iter) = accuracyOfROIDetection(iter) / length(KeyPointsIndex);
%     fprintf('Average accuracy:  %f\n',accuracyOfROIDetection);




    %% RetrieveTrajectoryPassSpecificPointSet
    % scatter(T(:,1),T(:,2))

%     [TrajEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index,'sum');


    rate = 0.2;
    [TraIndSet, allRate] = RetrieveTrajectoryPassSpecificPointSet(latLong_using_prototypes_index ,KeyPointsIndex , rate);


    %%
    % param.K = 4;
    % Tra_idx = kmeans(TrajEmbeddedVector, param.K);
    % param.Tra_idx = Tra_idx;
    % % visualization
    % param.numberOfVisualization = 2000;
    % visualTrajectoryEmbedding(latLong,param,1500);

    %% Find similar trajectories_using_TrajectoryEmbedding


    k = numbofSynTraj-1;
    [~, idx] = max(allRate);
    fprintf('TrajectoryEmbedding: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
    % Euclidean cosine
    [TopK_distance,TopK_index] = findSimilarVectors(TrajEmbeddedVector,k,idx,'Euclidean');
    % [~,TopK_index]= findSimilarTra_secondOrder(FastSyncResult.X,latLong_using_prototypes_index,latLong2SP,1,k,idx, 'multi');
    % visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index,index_of_trajectory);


    % Find similar trajectories_using_DTW
    fprintf('DTW: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
    [~, TopK_index_DTW] = Tra_distance_matrix_using_dtw_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
    % visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_DTW,index_of_trajectory);
    % Find similar trajectories_using_Frechet
    fprintf('Frechet: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
    [~, TopK_index_Frechet] = Tra_distance_matrix_using_Frechet_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
    % visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_Frechet,index_of_trajectory);
    % Find similar trajectories_using_LCS
    fprintf('LCS: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
    [~, TopK_index_LCS] = Tra_distance_matrix_using_LCS_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1);
    % visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_LCS,index_of_trajectory);
    % Find similar trajectories_using_EDR
    fprintf('EDR: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
    tol = max(param.axisRange(2) - param.axisRange(1), param.axisRange(4) - param.axisRange(3))/10;
    [~, TopK_index_EDR] = Tra_distance_matrix_using_EDR_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,idx,1,tol);
    % visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index_EDR,index_of_trajectory);

    NDCGK(iter,:) = NDCGatK((1:k)', allRate(TopK_index));
    NDCGK_DTW(iter,:) = NDCGatK((1:k)', allRate(TopK_index_DTW));
    NDCGK_Frechet(iter,:) = NDCGatK((1:k)', allRate(TopK_index_Frechet));
    NDCGK_LCS(iter,:) = NDCGatK((1:k)', allRate(TopK_index_LCS));
    NDCGK_EDR(iter,:) = NDCGatK((1:k)', allRate(TopK_index_EDR));

    
end


fprintf('ROI semantic detection Average accuracy:  %f\n', mean(accuracyOfROIDetection));


visualK = 30;
drawNDCG(NDCGK,NDCGK_DTW,NDCGK_Frechet,NDCGK_LCS,NDCGK_EDR,visualK);



