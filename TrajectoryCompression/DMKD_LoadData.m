%% visulization while reading data directly from raw file
clear;
addpath('..')
addpath('OpenstreetMap_Handler')
addpath('Util')
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
% %===========Load roadmaps==============
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Kaggle.mat');
% end


% 
% %T-Drive
% param.inputFile = 'Data/T_Drive';
% param.readingNumOfTraj = 10000;
% if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords,visitingTime] =  TDrive_trajectory_reading(param);
%     load('../Data/Raw_tdrive.mat');
% end
% param.imgMap = '../Data/beijing1.png';
% param.img = '../Data/beijing1.png';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% param.inChina = true;
% str_save1 = 'TDrive';
% if ~exist('intersection_nodes')
%     load('../Data/Roadmap_Beijing.mat');
% end
% 

% GeoLife
param.inputFile = '../Data/GeoLife';
param.readingNumOfTraj = 1000;
if ~exist('latLong')
    [latLong,numberOfEffectiveRecords,visitingTime] = GeoLife_trajectory_reading(param);
%     load('../Data/Raw_geolife.mat');
end
param.img = '../Data/beijing1.png';
% param.img = 'figs/GeoLife_raw.bmp';
param.imgMap = '../Data/beijing1.png';
param.axisRange = [116.1935 116.5531 39.7513 40.0334]; % boundary of Beijing
param.inChina = true;
% latLong  = SplitOneTrajectory2Many(latLong,100);
str_save1 = 'GeoLife';
if ~exist('intersection_nodes')
    load('../Data/Roadmap_Beijing.mat');
end


% % Hurricane
% param.inputFile = '../Data/hurricane_data';
% param.readingNumOfTraj = 1000000;
% param.imgMap = 'Data/Atlantic.png';
% param.img = 'Data/Atlantic.png';
% % param.imgNetwork = 'Data/Hurricane_Network.png';
% param.axisRange = [-113.7077   44.7131    5.2206   74.7249]; % boundary of Atlantic
% param.inChina = false;
% 
% if ~exist('latLong')
%     load('../Data/Raw_hurricane.mat');
% %     [latLong,numberOfEffectiveRecord,visitingTime] = Hurricane_trajectory_reading(param);
% end
% str_save1 = 'Hurricane';

% % Migration
% param.inputFile = '../Data/Swallows.csv';
% param.readingNumOfTraj = 10000;
% param.img = 'Data/SA.png';
% param.imgMap = 'Data/SA.png';
% param.axisRange = [-69.7465  -33.8018  -39.6058   16.8029]; % boundary of Atlantic
% 
% % if ~exist('latLong')
%     [latLong,numberOfEffectiveRecord,visitingTime] = Migration_trajectory_reading(param);
% % end
% % latLong  = SplitOneTrajectory2Many(latLong,100);
% latLong  = reSplitTraj(latLong,visitingTime);
% str_save1 = 'Migration';
% param.inChina = false;


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

[Distance_mean,D_upDown,D_leftRight] = CalculateapDistance(param);
param.Distance_mean = Distance_mean;




%% Further reduce the size:

% maxSize = 5000000;
% latLong(maxSize+1:end,:) = [];
% visitingTime(maxSize+1:end) = [];

%==============================================

% traN = 1000;
% [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
% numberOfTrajectories = length(index_of_trajectory);
% latLong(pointer_start(traN+1):end,:) = [];
% visitingTime(pointer_start(traN+1):end,:) = [];


%%
param.numberOfVisualization = 20;
% 
param.visualStyle = 'plot';
param.visualRoundabouts = false;

visualization(latLong,param);


%% Load Semantic ROI?? Intersection

intersects_threshold = 2;
sampling_rate = 1000;

roundabouts = getRoundabouts(intersects_threshold,connectivity_matrix,intersection_nodes,intersection_node_indices);
roundabouts = roundabouts(:,[2,1]);

sampleind = randperm(size(roundabouts,1));
sampleind = sampleind(1:sampling_rate);
roundabouts = roundabouts(sampleind,:);

param.roundabouts = roundabouts;
% 
% param.visualStyle = 'plot';
% param.visualRoundabouts = true;
% visualization(latLong,param);

