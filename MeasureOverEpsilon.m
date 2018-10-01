%% visulization while reading data directly from raw file

clear param;
clear;
%Kaggle 
param.inputFile = 'Data/Kaggle/train.csv';
param.readingNumOfTraj = 10000000; %toltalnumber 1710670
param.img = 'Data/Portugal_square.png';
if ~exist('latLong')
    [latLong,numberOfEffectiveRecords] = kaggle_trajectory_reading(param);
end
% param.axisRange = [-8.6986 -8.5455 41.1105 41.2574]; %boundary of Portugal(Kaggle dataset)
param.axisRange = [-8.7024 -8.5487 41.1347 41.2459]; % for illustration


% %T-Drive
% % param.inputFile = 'Data/T_Drive';
% % param.readingNumOfTraj = 10000;
% % param.img = 'Data/beijing1.png';
% % param.img = 'figs/Tdrive_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% % if ~exist('latLong')
% %     [latLong,numberOfEffectiveRecords] = TDrive_trajectory_reading(param);
% % end
% load('Data/Tdrive.mat');
% 
% % GeoLife
% param.inputFile = 'Data/GeoLife';
% param.readingNumOfTraj = 100000;
% % param.img = 'Data/beijing1.png';
% param.img = 'figs/GeoLife_raw.bmp';
% param.axisRange = [116.1935 116.5531 39.7513 40.0334 ]; % boundary of Beijing
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = GeoLife_trajectory_reading(param);
% end


% % Hurricane
% param.inputFile = 'Data/Hurricane/Hurricane.txt';
% param.readingNumOfTraj = 100000;
% % param.img = 'Data/Atlantic.png';
% param.img = 'figs/Hurricane_raw.png';
% param.axisRange = [-113.7077   44.7131    5.2206   74.7249]; % boundary of Atlantic
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Hurricane_trajectory_reading(param);
% end


% % Migration
% param.inputFile = 'Data/Migration/Swallows.csv';
% param.readingNumOfTraj = 10000;
% param.img = 'Data/SA.png';
% % param.img = 'figs/Hurricane_raw.png';
% param.axisRange = [-69.7465  -33.8018  -39.6058   16.8029]; % boundary of Atlantic
% 
% if ~exist('latLong')
%     [latLong,numberOfEffectiveRecords] = Migration_trajectory_reading(param);
% end

%% basic clear procedure:
fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

disp('=======specify the boundary============');


latLong(latLong(:,3) < param.axisRange(1),:) = [];
latLong(latLong(:,3) > param.axisRange(2),:) = [];
latLong(latLong(:,2) < param.axisRange(3),:) = [];
latLong(latLong(:,2) > param.axisRange(4),:) = [];
latLong(find(isnan(latLong(:,2))),:) = [];
latLong(find(isnan(latLong(:,3))),:) = [];

fprintf('number of effective records is [%d].\n original GPS coordinates number is [%d]\n',numberOfEffectiveRecords,size(latLong,1));

%% Synchronization clustering 

% Specify the number of grid partition.
numberOfPartition = 2 * 2^10;        % we partition the map as 1024*1024 by default, 
%which means points locate in the same grid same as the same point with weights

% Specify the parameters of clustering:
param.Knn = 10;        
param.maxLayer = 50; % this is for manual termination.
param.max_displacement = 1/numberOfPartition * pi/2; % approximate 0.001 * pi/2


delta = 0.01 * pi / 2;
n = 10;
t = zeros(n,1);
numberOfSP = zeros(n,1);
MSE = zeros(n,1);
latLong_next_level = latLong;
param.originallatLong = latLong;

for i = 1:n
    fprintf('[%d] step:   ',i);
    param.epsilon = delta * i;
    tic;
    FastSyncResult = Fast_Hierarchical_Synchronization(latLong_next_level (:,[2,3]),param);
    latLong_next_level = Match_latLong_to_next_level(latLong,FastSyncResult);
    t(i) = toc;
    totalMSE = FastSyncResult.totalMSE;
    MSE(i) = totalMSE;
    numberOfSP(i) = FastSyncResult.numberOfPrototypes;
    fprintf('time is [%f], totalMSE is [%f]\n',t(i),totalMSE);
end

disp('========================================================');
for i = 1:n
    fprintf('[%d] step:  #SP = [%d], time = [%f], MSE = [%f]\n',i,numberOfSP(i),t(i),MSE(i));
end

i = 1:10;
epsilon = 312 * i;

%
% 
% % ylabels{1} = '$|\mathcal{SP}|$';
% % ylabels{2} = '$runtime$';
% % ylabels{3} = '$MSE$';
% % [ax,hlines] = multiplotyyy({epsilon,numberOfSP},{epsilon,t},{epsilon,MSE},ylabels);
% 
% % legend(cat(1,hlines{:}),'$|\mathcal{SP}|$','$runtime$','$MSE$','location','w')
% figure % new figure
% [hAx, hLine1, hLine2] = plotyy(epsilon,numberOfSP,epsilon,MSE);
% hLine1.LineWidth = 2;
% hLine2.LineWidth = 2;
% hLine1.Marker='o';
% hLine1.MarkerSize = 11;
% hLine2.MarkerSize = 15;
% hLine2.Marker='pentagram';
% 
% hAx(1).FontSize = 20;
% hAx(2).FontSize = 20;
% 
% ll = legend({'Number of ROIs','MSE'},'FontSize',23);
% set(gca,'FontSize',20);
% xlabel('\epsilon','fontsize',35);
% 
% hAx(1).FontName = 'Times New Roman';
% hAx(2).FontName = 'Times New Roman';
% 
% gg = gca;
% gg.XLim = [0.015 0.16];
% 
% gg = gcf;
% gg.Position = [363 256 543 492];
% 
% % save('Data/Measure_Kaggle.mat');


%% Change FontSize to Huge

% ylabels{1} = '$|\mathcal{SP}|$';
% ylabels{2} = '$runtime$';
% ylabels{3} = '$MSE$';
% [ax,hlines] = multiplotyyy({epsilon,numberOfSP},{epsilon,t},{epsilon,MSE},ylabels);

% legend(cat(1,hlines{:}),'$|\mathcal{SP}|$','$runtime$','$MSE$','location','w')
figure % new figure
[hAx, hLine1, hLine2] = plotyy(epsilon,numberOfSP,epsilon,MSE);
hLine1.LineWidth = 2;
hLine2.LineWidth = 2;
hLine1.Marker='o';
hLine1.MarkerSize = 18;
hLine2.MarkerSize = 25;
hLine2.Marker='pentagram';

hAx(1).FontSize = 30;

hAx(2).FontSize = 30;


ll = legend({'#(ROIs)','MSE'},'FontSize',23);
ll.FontSize = 40;
set(gca,'FontSize',30);
xlabel('\epsilon (m)','fontsize',40);

hAx(1).FontName = 'Times New Roman';
hAx(2).FontName = 'Times New Roman';

gg = gca;
gg.XLim = [epsilon(1) epsilon(end)];
hAx(2).XLim = gg.XLim;
gg.Position = [0.1650 0.2000 0.6650 0.7050];


gg = gcf;
gg.Position = [363 316 423 432];