%% Trajectory Embedding

% 1. Asymmetric SP embedding
param.dim = 100;
param.IterTime = 1;
param.NegativeSamples = 3;
param.learningRate = 0.15;



% profile on;
tic;
[S, T] =  AsymmetricSPEmbedding(SP_pair_indeces, latLong_using_prototypes_index,type1Neighorhoods, type2Neighorhoods, type3Neighorhoods,type4Neighorhoods,type5Neighorhoods, param);
EmbeddingTime = toc;
fprintf('======================\nEmbedding Done, Time: %f\n',EmbeddingTime);
% profile off;
% profile viewer;
SPEmbeddedVector = [S,T];
[TrajEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index,'sum');
disp('Embedding done!');
% str_save_Embed = strcat('Data/str_save/',str_save1,'_',str_save2,'_Embedding','.mat');


%% Multi-Resolution Trajectory Embedding

param.dim = 100;
param.IterTime = 2;
param.NegativeSamples = 3;
param.learningRate = 0.15;
param.tradeoff = 1;


param.nodeCount_0 = nodeCount;
param.nodeCount_1 = nodeCount_1;
param.nodeCount_2 = nodeCount_2;


cell_SP_pair_indeces = {SP_pair_indeces,SP_pair_indeces_1,SP_pair_indeces_2};
cell_latLong_using_prototypes_index = {latLong_using_prototypes_index,latLong_using_prototypes_index_1,latLong_using_prototypes_index_2};

Mapping_son_to_parent_1 = Map_to_Parent(size(nodeCount,1), Mapping_to_son_1);
Mapping_son_to_parent_2 = Map_to_Parent(size(nodeCount_1,1), Mapping_to_son_2);
Mapping_son_to_parent = {Mapping_son_to_parent_1,Mapping_son_to_parent_2};

% profile on;
% tic;
[S, T] =  Multi_AsymmetricSPEmbedding(cell_SP_pair_indeces, cell_latLong_using_prototypes_index, Mapping_son_to_parent, param, cell_type1Neighorhoods, cell_type2Neighorhoods, cell_type3Neighorhoods,cell_type4Neighorhoods,cell_type5Neighorhoods);
EmbeddingTime = toc;
fprintf('======================\nEmbedding Done, Time: %f\n',EmbeddingTime);
% profile off;
% profile viewer;
SPEmbeddedVector_multi = [S{1},T{1}];
[TrajEmbeddedVector_multi,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector_multi, latLong_using_prototypes_index,'sum');
disp('Embedding done!');