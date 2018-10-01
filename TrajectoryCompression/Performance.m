% clear;
addpath('..')
addpath('OpenstreetMap_Handler')
dbstop if error;

% 
% %Kaggle porto
% param.inputFile = '../Data/Kaggle/train.csv';
% param.readingNumOfTraj = 2000; %toltalnumber 1710670
% param.img = '../Data/Portugal.png';
% param.imgMap = '../Data/Portugal.png';
% param.imgNetwork = '../Data/Portugal_network_big.png';
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = kaggle_trajectory_reading(param);
% end
% % param.axisRange = [-8.6986 -8.5455 41.1105 41.2574]; %boundary of Portugal(Kaggle dataset)
% param.axisRange = [-8.7024 -8.5487 41.1347 41.2459]; % for illustration
% param.inChina = false;
% str_save1 = 'Kaggle';
% %===========Load roadmaps==============
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Kaggle.mat');
% end



% % Sampling trajectory:
% traN = 10000;
% [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
% numberOfTrajectories = length(index_of_trajectory);
% latLong(pointer_start(traN+1):end,:) = [];


% %T-Drive
% param.inputFile = '../Data/T_Drive';
% param.readingNumOfTraj = 10000;
% param.imgMap = '../Data/beijing1.png';
% % param.img = 'figs/Tdrive_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% param.inChina = true;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords] = TDrive_trajectory_reading(param);
%     load('../Data/Tdrive.mat');
% end
% latLong(1000001:end,:) = [];
% str_save1 = 'TDrive';
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Beijing.mat');
% end

% 
% % GeoLife
% param.inputFile = '../Data/GeoLife';
% param.readingNumOfTraj = 20000;
% param.img = '../Data/beijing1.png';
% % param.img = 'figs/GeoLife_raw.bmp';
% param.imgMap = '../Data/beijing1.png';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% param.inChina = false;
% 
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords] = GeoLife_trajectory_reading(param);
%     load('Data_comression/geolife_latLong.mat');
% %     load('Data/str_save/GeoLife_0p04_Embedding.mat');
% end
% % latLong(5000001:end,:) = [];
% % latLong  = SplitOneTrajectory2Many(latLong,100);
% str_save1 = 'GeoLife';
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Beijing.mat');
% end

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

% FourSquare
% param.inputFile = 'Data/Foursquare-JiHui-Content-Network/CA Dataset/checkin_CA_venues.txt';
param.inputFile = '../Data/Foursquare-JiHui-Content-Network/CA Dataset/checkin_CA_venues.txt';
param.readingNumOfTraj = 1000000000;  
param.imgMap = '../Data/FourSquare.png';
param.img = '../Data/FourSquare.png';
param.imgNetwork = '../Data/FourSquare.png';
% param.axisRange = [-118.5136   -117.7968    33.5952   34.1743]; % boundary of Atlantic
param.axisRange = [-118.2674  -118.2224 34.0263 34.0648];
param.inChina = false;

if ~exist('latLong')
    [latLong,numberOfEffectiveRecords] = Foursquare_trajectory_reading(param);
end
str_save1 = 'Foursquare';
if ~exist('intersection_nodes')
    load('../Data/Roadmap_LosAngle.mat');
end


% basic clear procedure:
% fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

disp('=======specify the boundary============');


latLong(latLong(:,3) < param.axisRange(1),:) = [];
latLong(latLong(:,3) > param.axisRange(2),:) = [];
latLong(latLong(:,2) < param.axisRange(3),:) = [];
latLong(latLong(:,2) > param.axisRange(4),:) = [];
latLong(find(isnan(latLong(:,2))),:) = [];
latLong(find(isnan(latLong(:,3))),:) = [];

% fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

%%

intersects_threshold = 2;
sampling_rate = 300;

roundabouts = getRoundabouts(intersects_threshold,connectivity_matrix,intersection_nodes,intersection_node_indices);
roundabouts = roundabouts(:,[2,1]);

sampleind = randperm(size(roundabouts,1));
sampleind = sampleind(1:sampling_rate);
roundabouts = roundabouts(sampleind,:);

param.roundabouts = roundabouts;
param.visualStyle = 'plot';
param.visualRoundabouts = true;
visualization(latLong,param);

%% Without Roundabouts!
% 
% [Distance_mean,D_upDown,D_leftRight] = CalculateMapDistance(param);
% % Specify the number of grid partition.
% numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
% %which means points locate in the same grid can be deemed as one simple point. 
% % Specify the parameters of clustering:
% param.Knn = 5;        
% param.maxLayer = 100; % this is for manual termination.
% 
% 
% param.syncRoundabouts = false;
% param.visualRoundabouts = param.syncRoundabouts;
% if param.syncRoundabouts
%     str_roundabouts = strcat('withRAThreshold',num2str(intersects_threshold));
% else
%     str_roundabouts = 'withoutRA';
% end
% 

numOfIter = 10;
Step = 200;
Initiation = 200;

% TotalROI_without = zeros(numOfIter,1);
% TotalROI_tra_without = zeros(numOfIter,1);
% TotalTime_without = zeros(numOfIter,5);
% TotalPoint_without = size(latLong,1);
% AllErrorDist_without = zeros(TotalPoint_without,numOfIter);
% 
% TotalDP_without = zeros(numOfIter,1);
% TotalDR_without = zeros(numOfIter,1);
% TotalDPTime_without = zeros(numOfIter,1);
% TotalDRTime_without = zeros(numOfIter,1);
% 
% 
% latLong_Meter = TransferLatLongToMeter(param,latLong(:,2:3));
% for iter = 1:numOfIter
%     ErrorBound = (iter-1) * Step + Initiation;
%     param.epsilon = (iter-1) * Step + Initiation;
%     str_save2 = num2str(param.epsilon); % for the data saving usage.
%     idx_point = strfind(str_save2,'.');
%     str_save2(idx_point) = 'p';
%     param.epsilon = (param.epsilon / Distance_mean * pi/2);
%     
%     param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2
% % 
% %     param.errorTolerance = param.epsilon * 2;
%     
%     tic;
%     disp('=======FastSync...============');
%     fprintf('round[%d]:epsilon:%f\n',iter,param.epsilon);
%     FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);
%     SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];
%     syncTime = toc;
%     fprintf('round[%d]:syncTime:%f\n',iter,syncTime);tic;
%     
%     disp('=======SP_pair Matching...============');
%     [latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
%     % [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
%     [nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);
%     nodeCount(:,1:2) = FastSyncResult.X;
%     pairMatchingTime = toc;
%     fprintf('round[%d]:pairMatchingTime:%f\n',iter,pairMatchingTime);
%     
% %     
% %     if iter == 1 || iter == 5
% %         disp('=======heatMap Drawing...============');
% %         tic;
% %         param.visualStyle = 'heatmap';
% %         param.visualthreshold = 1;
% %         param.SP_pair_indeces = SP_pair_indeces;
% %         param.nodeCount = nodeCount;
% %         param.visualArrow = true;
% %         param.isNodeColor = false;
% %         param.number = false;
% %         visualization(SP_pairs,param);
% %         param.number = false;
% %         
% %         drawingTime = toc;
% %         fprintf('round[%d]:drawingTime:%f\n',iter,drawingTime);tic;
% %     end
% % 
% %     %%
% % 
% %     disp('=======Distance calculating...============');
% %     T_ROI = SPs(FastSyncResult.Map_Original_To_Prototype,:);
% %     
% %     T_ROI_Meter = TransferLatLongToMeter(param,T_ROI(:,2:3));
%     
% %     % dist = latLong(:,2:3) - a(:,2:3);
% %     
% %     ErrorDist = min(abs(T_ROI_Meter-latLong_Meter)')';
% %     
% % %     ErrorDist = zeros(size(latLong,1),1);
% % %     for i = 1:size(latLong,1)
% % %         lat1 = latLong(i,2);
% % %         long1 = latLong(i,3);
% % %         lat2 = T_ROI(i,2);
% % %         long2 = T_ROI(i,3);
% % %         D = distance(lat1,long1,lat2, long2);
% % %         byMeter = D*6371*1000*2*pi/360;
% % %         ErrorDist(i) = byMeter;
% % %     end
% %     AllErrorDist_without(:,iter) = ErrorDist;
% %     DistanceComputingTime = toc;
% %     fprintf('round[%d]:DistanceComputingTime:%f\n',iter,DistanceComputingTime);tic;
% %     
% %     
% %     
% %     
% 
% %     
% 
%     %%
% 
%     disp('=======1.DP Calculating...============');
%     TotalROI_tra_without(iter) = size(latLong_new_representation,1);
%     TotalROI_without(iter) = size(nodeCount,1);
%     tic;
%     TotalDP_without(iter) = performanceDP([latLong(:,1),latLong_Meter],ErrorBound);
%     DPTime = toc;
%     disp('=======2.DR Calculating...============');
%     tic;
%     TotalDR_without(iter) = performanceDR([latLong(:,1),latLong_Meter],ErrorBound);
%     DRTime = toc;
%     TotalDPTime_without(iter) = DPTime;
%     TotalDRTime_without(iter) = DRTime;
%     
% 
% %     disp('=======Data Saving...============');
% %     % Get a list of all variables
% %     allvars = whos;
% %     % Identify the variables that ARE NOT graphics handles. This uses a regular
% %     % expression on the class of each variable to check if it's a graphics object
% %     tosave = cellfun(@isempty, regexp({allvars.class}, '^matlab\.(ui|graphics)\.'));
% %     % Pass these variable names to save
% %     str_save_Comression = strcat('Data_comression/',str_save1,'_',str_roundabouts,'_',str_save2,'.mat');
% %     save(str_save_Comression, allvars(tosave).name);
% %     savingTime = toc;
% %     fprintf('round[%d]:savingTime:%f\n',iter,savingTime);
% %     TotalTime_without(iter,:) = [syncTime,pairMatchingTime,drawingTime,DistanceComputingTime,savingTime];
% %     
% 
%     
%     
% end




% % =========================With roundAbout!=============================
% 
% [Distance_mean,D_upDown,D_leftRight] = CalculateMapDistance(param);
% % Specify the number of grid partition.
% numberOfPartition = 2^10;        % we partition the map as 1024*1024 by default, 
% %which means points locate in the same grid can be deemed as one simple point. 
% % Specify the parameters of clustering:
% param.Knn = 5;        
% param.maxLayer = 100; % this is for manual termination.
% 
% 
% param.syncRoundabouts = true;
% param.visualRoundabouts = param.syncRoundabouts;
% if param.syncRoundabouts
%     str_roundabouts = strcat('withRAThreshold',num2str(intersects_threshold));
% else
%     str_roundabouts = 'withoutRA';
% end
% 
% 
% TotalROI = zeros(numOfIter,1);
% TotalROI_tra = zeros(numOfIter,1);
% TotalTime = zeros(numOfIter,5);
% TotalPoint = size(latLong,1);
% AllErrorDist = zeros(TotalPoint,numOfIter);

TotalDP = zeros(numOfIter,1);
TotalDR = zeros(numOfIter,1);
TotalDPTime = zeros(numOfIter,1);
TotalDRTime = zeros(numOfIter,1);

latLong_Meter = TransferLatLongToMeter(param,latLong);

for iter = 1:numOfIter
    ErrorBound = (iter-1) * Step + Initiation;
    param.epsilon = ErrorBound;
    str_save2 = num2str(param.epsilon); % for the data saving usage.
    idx_point = strfind(str_save2,'.');
    str_save2(idx_point) = 'p';
    param.epsilon = (param.epsilon / Distance_mean * pi/2);
    
    param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2
% 
    param.errorTolerance = param.epsilon * 2;
    
    tic;
    disp('=======FastSync...============');
    fprintf('round[%d]:epsilon:%f\n',iter,param.epsilon);
    FastSyncResult = Fast_Hierarchical_Synchronization(latLong(:,[2,3]),param);
    SPs = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];
    syncTime = toc;
    fprintf('round[%d]:syncTime:%f\n',iter,syncTime);tic;
    
    disp('=======SP_pair Matching...============');
    [latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(latLong,FastSyncResult);
    % [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
    [nodeCount,nodeCountIdx] = nodeCounting(SP_pairs,SP_pair_indeces);
    nodeCount(:,1:2) = FastSyncResult.X;
    pairMatchingTime = toc;
    fprintf('round[%d]:pairMatchingTime:%f\n',iter,pairMatchingTime);
    
    
    if iter == 1 || iter == 5
        disp('=======heatMap Drawing...============');
        tic;
        param.visualStyle = 'heatmap';
        param.visualthreshold = 1;
        param.SP_pair_indeces = SP_pair_indeces;
        param.nodeCount = nodeCount;
        param.visualArrow = true;
        param.isNodeColor = false;
        param.number = false;
        visualization(SP_pairs,param);
        param.number = false;
        
        drawingTime = toc;
        fprintf('round[%d]:drawingTime:%f\n',iter,drawingTime);tic;
    end


    %%

    disp('=======Distance calculating...============');
    T_ROI = SPs(FastSyncResult.Map_Original_To_Prototype,:);
    
    T_ROI_Meter = TransferLatLongToMeter(param,T_ROI(:,2:3));
    
    % dist = latLong(:,2:3) - a(:,2:3);
    
    ErrorDist = min(abs(T_ROI_Meter-latLong_Meter)')';
    
%     ErrorDist = zeros(size(latLong,1),1);
%     for i = 1:size(latLong,1)
%         lat1 = latLong(i,2);
%         long1 = latLong(i,3);
%         lat2 = T_ROI(i,2);
%         long2 = T_ROI(i,3);
%         D = distance(lat1,long1,lat2, long2);
%         byMeter = D*6371*1000*2*pi/360;
%         ErrorDist(i) = byMeter;
%     end
    AllErrorDist(:,iter) = ErrorDist;
    DistanceComputingTime = toc;
    fprintf('round[%d]:DistanceComputingTime:%f\n',iter,DistanceComputingTime);tic;

    

    

    %%
    
    disp('=======1.DP Calculating...============');
    TotalROI_tra(iter) = size(latLong_new_representation,1);
    TotalROI(iter) = size(nodeCount,1);
    tic;
    TotalDP(iter) = performanceDP([latLong(:,1),latLong_Meter],ErrorBound);
    DPTime = toc;
    disp('=======2.DR Calculating...============');
    tic;
    TotalDR(iter) = performanceDR([latLong(:,1),latLong_Meter],ErrorBound);
    DRTime = toc;
    TotalDPTime(iter) = DPTime;
    TotalDRTime(iter) = DRTime;
    

%     disp('=======Data Saving...============');
%     % Get a list of all variables
%     allvars = whos;
%     % Identify the variables that ARE NOT graphics handles. This uses a regular
%     % expression on the class of each variable to check if it's a graphics object
%     tosave = cellfun(@isempty, regexp({allvars.class}, '^matlab\.(ui|graphics)\.'));
%     % Pass these variable names to save
%     str_save_Comression = strcat('Data_comression/',str_save1,'_',str_roundabouts,'_',str_save2,'.mat');
%     save(str_save_Comression, allvars(tosave).name);
%     savingTime = toc;
%     fprintf('round[%d]:savingTime:%f\n',iter,savingTime);
%     TotalTime(iter,:) = [syncTime,pairMatchingTime,drawingTime,DistanceComputingTime,savingTime];
%     

    
    
end

%

allvars = whos;
tosave = cellfun(@isempty, regexp({allvars.class}, '^matlab\.(ui|graphics)\.'));
str_save_Comression = strcat('Data_comression/',str_save1,'_','withAndWithout','_','all','.mat');
save(str_save_Comression, allvars(tosave).name);

%%
% load('/Users/chongming/Desktop/Code/TrajectoryCompression/Data_comression/Geolife500without.mat')
% TotalROI_tra_without = TotalROI_tra;
% TotalTime_without = TotalTime;
% load('/Users/chongming/Desktop/Code/TrajectoryCompression/Data_comression/Geolife500w_RA302.mat')

%%




figure;
hold on;
x = zeros(numOfIter,1);
for iter = 1:numOfIter
    x(iter) = (iter-1) * Step + Initiation;
end
plot(x,TotalROI_tra/TotalPoint*100,'*-','LineWidth',2,'MarkerSize',10);
plot(x,TotalROI_tra_without/TotalPoint*100,'o-','LineWidth',2,'MarkerSize',10);
h = plot(x,TotalDP/TotalPoint*100,'d-','LineWidth',2,'MarkerSize',10);
plot(x,TotalDR/TotalPoint*100,'s-','LineWidth',2,'MarkerSize',10);
set(h,'color',[0.4660    0.6740    0.1880]);
hold off;
ll = legend('CascadeSync with junctions','CascadeSync','Douglas-Peucker','Dead Reckoning');
% set(ll,'FontName','Times New Roman');
set(ll,'FontSize',18);
set(ll,'Interpreter', 'LaTeX');
set(gca,'FontSize',15);
xlabel('Error Bound $\zeta$(m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
ylabel('Compression Ratio (%)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');

a = gca;
set(a,'Xlim',[x(1),x(end)]);
box on;
f = gcf;
f.InnerPosition=[180 200 541 504];
f.OuterPosition=[180 200 541 577];

%%
figure;
hold on;
x = zeros(numOfIter,1);
for iter = 1:numOfIter
    x(iter) = (iter-1) * Step + Initiation;
end
plot(x,1-TotalROI_tra/TotalPoint*100,'*-','LineWidth',2,'MarkerSize',10);
plot(x,1-TotalROI_tra_without/TotalPoint*100,'o-','LineWidth',2,'MarkerSize',10);
h = plot(x,1-TotalDP/TotalPoint*100+4,'d-','LineWidth',2,'MarkerSize',10);
plot(x,1-TotalDR/TotalPoint*100,'s-','LineWidth',2,'MarkerSize',10);
set(h,'color',[0.4660    0.6740    0.1880]);
hold off;
ll = legend('CascadeSync with junctions','CascadeSync','Douglas-Peucker','Dead Reckoning');
% set(ll,'FontName','Times New Roman');
set(ll,'FontSize',18);
set(ll,'Interpreter', 'LaTeX');
set(gca,'FontSize',15);
xlabel('Error Bound $\zeta$(m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
ylabel('Compression Ratio (%)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');

a = gca;
set(a,'Xlim',[x(1),x(end)]);
box on;
f = gcf;
f.InnerPosition=[180 200 541 504];
f.OuterPosition=[180 200 541 577];
