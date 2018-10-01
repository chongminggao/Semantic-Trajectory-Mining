%% 
Num = 100;

[means,stds] = ROI_accuracy_calculation(SPEmbeddedVector,LabelSimilarityMat,Num,true);
fprintf(sigir_fileID, 'ROI1. Random Average accuracy:\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');




[means,stds] = ROI_accuracy_calculation(SPEmbeddedVector,LabelSimilarityMat,Num,false);
fprintf(sigir_fileID, 'ROI2. Average accuracy\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');

%% POI accuracy evaluation

[means,stds] = ROI_accuracy_calculation(SPEmbeddedVector_multi,LabelSimilarityMat,Num,true);
fprintf(sigir_fileID, 'ROI1M. Random Average accuracy:\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');

[means,stds] = ROI_accuracy_calculation(SPEmbeddedVector_multi,LabelSimilarityMat,Num,false);
fprintf(sigir_fileID, 'ROI3. Average accuracy:\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');


%% Evaluate Semantic Trajectory Similarity:
Num = 100;
rate = 0.1;
% NDCG = 10;


[means,stds] = Trajectory_accuracy_calculation(latLong_using_prototypes_index,TrajEmbeddedVector,TrajSimMat,Num,rate,true);
fprintf(sigir_fileID, 'T1. Random Average accuracy:\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');

[means,stds] = Trajectory_accuracy_calculation(latLong_using_prototypes_index,TrajEmbeddedVector,TrajSimMat,Num,rate,false);
fprintf(sigir_fileID, 'T2. Average accuracy:\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');

[means,stds] = Trajectory_accuracy_calculation(latLong_using_prototypes_index,TrajEmbeddedVector_multi,TrajSimMat,Num,rate,false);
fprintf(sigir_fileID, 'T3. Multi Average accuracy:\n');
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');



%% DTW, LCSS, Frechet, EDR Distance and Instance constructor

% TOPK = 10;
[accuracy_DTW, accuracy_EDR, accuracy_LCSS, accuracy_Frechet] = Trajectory_accuracy_Comparison(latLong_using_prototypes_index, DTW_Similar_Mat, LCSS_Similar_Mat, EDR_Similar_Mat, Frechet_Similar_Mat,TrajSimMat,Num,rate);

fprintf(sigir_fileID, 'T4. DTW Average accuracy:\n');
means = mean(accuracy_DTW);
stds = std(accuracy_DTW);
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');

fprintf(sigir_fileID, 'T5. LCSS Average accuracy:\n');
means = mean(accuracy_LCSS);
stds = std(accuracy_LCSS);
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');



fprintf(sigir_fileID, 'T6. EDR Average accuracy:\n');
means = mean(accuracy_EDR);
stds = std(accuracy_EDR);
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');



fprintf(sigir_fileID, 'T7. Frechet Average accuracy:\n');
means = mean(accuracy_Frechet);
stds = std(accuracy_Frechet);
for i = 1:length(means)
	fprintf(sigir_fileID, '%f ',means(i));
end
fprintf(sigir_fileID, '\nstd:\n');
for i = 1:length(stds)
	fprintf(sigir_fileID, '%f ',stds(i));
end
fprintf(sigir_fileID, '\n\n');

%% Find the Top-k most similar SP
% param.number = false;
% k = 4;
% idx = 9;
% [TopKIdx,~] = findTopKSimilarSP(SPEmbeddedVector,k,idx,'E');
% 
% visualizeTopKSP(FastSyncResult.X, SP_pairs, param,idx,TopKIdx);



%% visualizeOneTrajectory

% visualizeOneTrajectory(latLong,latLong_new_representation,latLong_using_prototypes_index,param,274,[]);

 %% Find similar trajectories_using_TrajectoryEmbedding
% k = 100;
% compareK = 100;
% idx = 16;
% rate = 0.6;
% 
% fprintf(sigir_fileID, 'TrajectoryEmbedding: the top [%d] most similar trajectories  of [%d] are found.\n',k,idx);
% % Euclidean cosine
% [TopK_distance,TopK_index] = findSimilarVectors(TrajEmbeddedVector,numOfTrajectory - 1,idx,'Euclidean');
% % [~,TopK_index]= findSimilarTra_secondOrder(FastSyncResult.X,latLong_using_prototypes_index,latLong2SP,1,k,idx, 'multi');
% TopK_index = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index,compareK, rate);
% visualize_TopK_similar_trajectories(latLong,param,idx,compareK,TopK_index,index_of_trajectory);
% 

