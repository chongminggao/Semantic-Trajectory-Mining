%% visulization while reading data directly from raw file
clear;
addpath('..')
addpath('OpenstreetMap_Handler')
addpath('Util')
dbstop if error;

%%

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
param.axisRange = [116.315148, 116.318450,39.984516, 39.984702]; % boundary of Test
param.inChina = true;
% latLong  = SplitOneTrajectory2Many(latLong,100);
str_save1 = 'GeoLife';



[Distance_mean,D_upDown,D_leftRight] = CalculateapDistance(param);
param.Distance_mean = Distance_mean;

%%


Layer = 4;

Max_epsilon_ratio = 0.15;
Max_epsilon = param.Distance_mean * Max_epsilon_ratio;
epsilon_meter = Max_epsilon./Layer * (1:Layer);
epsilon = epsilon_meter / Distance_mean * pi/2;

%% Invoke hierarchical Sync Part 1: Initial the parameters

numberOfPartition = 2*2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid can be deemed as one simple point. 

% Specify the parameters of clustering:
param.Knn = 5;        
param.maxLayer = 50; % this is for manual termination.
param.max_displacement = 1/numberOfPartition * pi/2; % approximate as 0.001 * pi/2
isVisual = false;
param_multi= cell(Layer,1);


% Whether sync with or without roundabouts
param.syncRoundabouts = false;
param.visualRoundabouts = param.syncRoundabouts;

for l = 1:Layer
    param.epsilon = epsilon(l);
    param.errorTolerance = param.epsilon * 1;
    param_multi{l} = param;
end


% Invoke hierarchical CascadeSync 

[param_multi_without, result_multi_without, Time_without] =  InvokeHierarchicalSync(Layer, param_multi, latLong, isVisual);
