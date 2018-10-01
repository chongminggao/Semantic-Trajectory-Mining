%% visulization while reading data directly from raw file

% clear;

% %Kaggle 
% param.inputFile = 'Data/Kaggle/train.csv';
% param.readingNumOfTraj = 10000000; %toltalnumber 1710670
% param.img = 'Data/Portugal.png';
% param.imgMap = 'Data/Portugal.png';
% param.imgNetwork = 'Data/Portugal_network_big.png';
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = kaggle_trajectory_reading(param);
% end
% % param.axisRange = [-8.6986 -8.5455 41.1105 41.2574]; %boundary of Portugal(Kaggle dataset)
% param.axisRange = [-8.7024 -8.5487 41.1347 41.2459]; % for illustration
% str_save1 = 'Kaggle';

% %T-Drive
% param.inputFile = 'Data/T_Drive';
% param.readingNumOfTraj = 10000;
% param.imgMap = 'Data/beijing1.png';
% param.img = 'figs/Tdrive_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords] = TDrive_trajectory_reading(param);
%     load('Data/Tdrive.mat');
% end
% str_save1 = 'TDrive';

% GeoLife
param.inputFile = 'Data/GeoLife';
param.readingNumOfTraj = 100000;
% param.img = 'Data/beijing1.png';
param.img = 'figs/GeoLife_raw.bmp';
param.imgMap = 'Data/beijing1.png';
param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing

if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = GeoLife_trajectory_reading(param);
    load('Data/str_save/GeoLife_0p01_Embedding.mat');
end
% latLong  = SplitOneTrajectory2Many(latLong,100);
str_save1 = 'GeoLife';

% % Hurricane
% param.inputFile = 'Data/Hurricane/Hurricane.txt';
% param.readingNumOfTraj = 10000;
% param.imgMap = 'Data/Atlantic.png';
% param.img = 'figs/Hurricane_raw.png';
% param.axisRange = [-113.7077   44.7131    5.2206   74.7249]; % boundary of Atlantic
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

%%
% Specify the number of grid partition.
numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 10;        
param.maxLayer = 20; % this is for manual termination.
base = 0.01;
delta = 0.01;

numOfTra = length(unique(latLong(:,1)));
num = min(20, numOfTra - 1);

iter = 2;

tensor = zeros(num,numOfTra - 1,iter);
tensor_DTW = zeros(num,numOfTra - 1,iter);
tensor_Frechet = zeros(num,numOfTra - 1,iter);
tensor_LCS = zeros(num,numOfTra - 1,iter);
tensor_EDR = zeros(num,numOfTra - 1,iter);

randnum = randperm(numOfTra);

%%
for i = 1:iter
    fprintf('Start #[%d] SPs Searching\n',i);
    param.epsilon_print = base + (i-1) * delta;
    str_save2 = num2str(param.epsilon_print); % for the data saving usage.
    idx_point = strfind(str_save2,'.');
    str_save2(idx_point) = 'p';
    
    str_save = strcat('Data/str_save/',str_save1,'_',str_save2,'.mat');
    str_save_Embed = strcat('Data/str_save/',str_save1,'_',str_save2,'_Embedding_A','.mat')
    
    try
        if param.epsilon_print ~= 0.01
        load(str_save_Embed);
        end
    catch

        param.epsilon = param.epsilon_print * pi/2;
        param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2


        disp('=======FastSync...============');
        FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);

    %     SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];

    end
        [~,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces] = matching_to_SPs(latLong,FastSyncResult);
        [nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);
        param.visualStyle = 'heatmap';
        param.visualthreshold = 1;
        param.SP_pair_indeces = SP_pair_indeces;
        param.nodeCount = nodeCount;
        param.visualArrow = true;
        param.isNodeColor = false;
        visualization(SP_pairs,param);

        
        
        %% DTW
        
        fprintf('Start #[%d] round DTW calculation\n',i);
        [~, TopK_record_DTW] = Tra_distance_matrix_using_dtw_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,randnum,num);
        disp('DTW : 1. distance matrix done!');
        
        tensor_DTW(:,:,i) = TopK_record_DTW;
        
        %% LCS
        fprintf('Start #[%d] round LCS calculation\n',i);
        [~, TopK_record_LCS] = Tra_distance_matrix_using_LCS_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,randnum,num);
        disp('DTW : 1. distance matrix done!');
        tensor_LCS(:,:,i) = TopK_record_LCS;
        
        %% Frechet distance
        fprintf('Start #[%d] round Frechet calculation\n',i);
        [~, TopK_record_Frechet] = Tra_distance_matrix_using_Frechet_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,randnum,num);
        disp('DTW : 1. distance matrix done!');
        tensor_Frechet(:,:,i) = TopK_record_Frechet;
        
        %% EDR
        fprintf('Start #[%d] round EDR calculation\n',i);
        tol = max(param.axisRange(2) - param.axisRange(1), param.axisRange(4) - param.axisRange(3))/10;
        [~, TopK_record_EDR] = Tra_distance_matrix_using_EDR_index_randomK(latLong_using_prototypes_index, FastSyncResult.X,randnum,num,tol);
        disp('DTW : 1. distance matrix done!');
        tensor_EDR(:,:,i) = TopK_record_EDR;
        
    
        %% SP Embedding
        fprintf('Start #[%d] embedding\n',i);
        param.dim = 50;
        param.IterTime = 1;
        param.NegativeSamples = 3;
        param.learningRate = 0.025;
        param.window = 2;
        param.similarNum = 0;
        param.bin = 5;
        param.degreeRate = 0.8;

        [S, T, ~] =  AsymmetricSPEmbedding(SP_pair_indeces, latLong_using_prototypes_index, param);
        SPEmbeddedVector = [S,T];
        disp('Embedding done!');
    

        % Trajectory embedding using sum
        
        [TrajEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index,'sum');
    

        fprintf('Start #[%d] round neighbors searching\n',i);

        %% Similarity Using Embedding
        TopK_record = zeros(num,numOfTra - 1);    
        for j = 1:num
            idx = randnum(j);
            % Euclidean cosine
            [~,TopK_index] = findSimilarVectors(TrajEmbeddedVector,numOfTra - 1,idx,'Euclidean');
            TopK_record(j,:) = TopK_index';
        end
        tensor(:,:,i) = TopK_record;
        
        
%         %% Calculate using second order
%         
%         latLong2SP = [latLong(:,1),FastSyncResult.Map_Original_To_Prototype];
%         [~,maxIdx]= findSimilarTra_secondOrder(FastSyncResult.X,latLong_using_prototypes_index,latLong2SP,num,numOfTra - 1,randnum, 'binary');
%         tensor(:,:,i) = maxIdx;
%         
%         
        save(str_save_Embed);
        disp('save successfully!');
        


end
%%

fprintf('Start calculate consistency\n');
%% Embedding
intersetNum = zeros(num, numOfTra-1);
for k = 1:num
    mat = reshape(tensor(k,:,:),numOfTra-1,iter)';
    numberVec = countIntersect(mat);
    intersetNum(k,:) = numberVec;
end
drawData = mean(intersetNum)./(1:numOfTra-1);

%% DTW
intersetNum_DTW = zeros(num, numOfTra-1);
for k = 1:num
    mat = reshape(tensor_DTW(k,:,:),numOfTra-1,iter)';
    numberVec = countIntersect(mat);
    intersetNum_DTW(k,:) = numberVec;
end
drawData_DTW = mean(intersetNum_DTW)./(1:numOfTra-1);

%% LCS
intersetNum_LCS = zeros(num, numOfTra-1);
for k = 1:num
    mat = reshape(tensor_LCS(k,:,:),numOfTra-1,iter)';
    numberVec = countIntersect(mat);
    intersetNum_LCS(k,:) = numberVec;
end
drawData_LCS = mean(intersetNum_LCS)./(1:numOfTra-1);


%% Frechet
intersetNum_Frechet = zeros(num, numOfTra-1);
for k = 1:num
    mat = reshape(tensor_Frechet(k,:,:),numOfTra-1,iter)';
    numberVec = countIntersect(mat);
    intersetNum_Frechet(k,:) = numberVec;
end
drawData_Frechet = mean(intersetNum_Frechet)./(1:numOfTra-1);


%% EDR
intersetNum_EDR = zeros(num, numOfTra-1);
for k = 1:num
    mat = reshape(tensor_EDR(k,:,:),numOfTra-1,iter)';
    numberVec = countIntersect(mat);
    intersetNum_EDR(k,:) = numberVec;
end
drawData_EDR = mean(intersetNum_EDR)./(1:numOfTra-1);

fprintf('Done!\n');


figure;
hold on;
plot(1:numOfTra-1, drawData);
plot(1:numOfTra-1, drawData_DTW);
plot(1:numOfTra-1, drawData_Frechet);
plot(1:numOfTra-1, drawData_LCS);
plot(1:numOfTra-1, drawData_EDR);
hold off;
legend('Embedding','DTW','Frechet','LCS','EDR');

