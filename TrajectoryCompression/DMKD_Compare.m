%% Invoke Compare Algorithms;
Layer = 10;

Max_epsilon_ratio = 0.15;
Max_epsilon = param.Distance_mean * Max_epsilon_ratio;
epsilon_meter = Max_epsilon./Layer * (1:Layer);
epsilon = epsilon_meter / Distance_mean * pi/2;

latLong_Meter = TransferLatLongToMeter(param,latLong);

ratios_DP = zeros(Layer,1);
ratios_DPSED = zeros(Layer,1);
ratios_DR = zeros(Layer,1);
ratios_Squish = zeros(Layer,1);

aveError_DP = zeros(Layer,1);
aveError_DPSED = zeros(Layer,1);
aveError_DR = zeros(Layer,1);
aveError_Squish = zeros(Layer,1);

aveErrorSED_DP = zeros(Layer,1);
aveErrorSED_DPSED = zeros(Layer,1);
aveErrorSED_DR = zeros(Layer,1);
aveErrorSED_Squish = zeros(Layer,1);

Time_DP = zeros(Layer,1);
Time_DPSED = zeros(Layer,1);
Time_DR = zeros(Layer,1);
Time_Squish = zeros(Layer,1);
% Time_CascadeSync = zeros(Layer,1);
% Time_CascadeSync_with = zeros(Layer,1);



for l = 1:Layer
    tic;
    [ratios_DP(l), aveError_DP(l), aveErrorSED_DP(l)] = invoke_Algorithm(@Wrapper_DP, latLong_Meter, visitingTime, epsilon_meter(l));
    Time_DP(l) = toc;tic;
    [ratios_DPSED(l), aveError_DPSED(l), aveErrorSED_DPSED(l)] = invoke_Algorithm(@Wrapper_DPSED, latLong_Meter, visitingTime, epsilon_meter(l));
    Time_DPSED(l) = toc;tic;
    [ratios_DR(l), aveError_DR(l), aveErrorSED_DR(l)] = invoke_Algorithm(@DeadReckoning, latLong_Meter, visitingTime, epsilon_meter(l));
    Time_DR(l) = toc;tic;
    [ratios_Squish(l), aveError_Squish(l), aveErrorSED_Squish(l)] = invoke_Algorithm(@Squish, latLong_Meter, visitingTime, epsilon_meter(l));
    Time_Squish(l) = toc;
end
tic;
[ratios_MDL, aveError_MDL, aveErrorSED_MDL] = invoke_Algorithm(@TraCluster_MDL, latLong_Meter, visitingTime, epsilon_meter);
t = toc;
Time_MDL = ones(Layer,1) * t;
ratios_MDL = ones(Layer,1) * ratios_MDL;
aveError_MDL = ones(Layer,1) * aveError_MDL;
aveErrorSED_MDL = ones(Layer,1) * aveErrorSED_MDL;


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
[ratios_without, aveErrors_without] = Calculate_CascadeResult_Ratio_Error(latLong_Meter, param_multi_without, result_multi_without);

for l = 1:Layer
    param_multi{l}.syncRoundabouts = true;
    param_multi{l}.visualRoundabouts = param_multi{l}.syncRoundabouts;
end
[param_multi_with, result_multi_with, Time_with] =  InvokeHierarchicalSync(Layer, param_multi, latLong, isVisual);
[ratios_with, aveErrors_with] = Calculate_CascadeResult_Ratio_Error(latLong_Meter, param_multi_with, result_multi_with);

save(strjoin({'DMKD_ratioResult_', str_save1, '.mat'}));


%% Draw the comparing line

try
    Cell_epsilon = {epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter};
    Cell_ratio = {ratios_DP, ratios_DPSED, ratios_DR, ratios_Squish, ratios_MDL, ratios_without, ratios_with};
    legend_str = {'Douglas-Peucker','Douglas-Peucker with SED','Dead Reckoning','Squish','Traclus-MDL', 'CascadeSync', 'CascadeSync with intersections'};
    Cell_error = {aveError_DP, aveError_DPSED, aveError_DR, aveError_Squish, aveError_MDL, aveErrors_without, aveErrors_with};
    Cell_errorSED = {aveErrorSED_DP, aveErrorSED_DPSED, aveErrorSED_DR, aveErrorSED_Squish, aveErrorSED_MDL, aveErrors_without, aveErrors_with};
    Cell_Time = {Time_DP, Time_DPSED, Time_DR, Time_Squish, Time_MDL, Time_without, Time_with};
catch
    Cell_epsilon = {epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter, epsilon_meter};
    Cell_ratio = {ratios_DP, ratios_DPSED, ratios_DR, ratios_Squish, ratios_MDL, ratios_without};
    legend_str = {'Douglas-Peucker','Douglas-Peucker with SED','Dead Reckoning','Squish','Traclus-MDL','CascadeSync'};
    Cell_error = {aveError_DP, aveError_DPSED, aveError_DR, aveError_Squish, aveError_MDL, aveErrors_without};
    Cell_errorSED = {aveErrorSED_DP, aveErrorSED_DPSED, aveErrorSED_DR, aveErrorSED_Squish, aveErrorSED_MDL, aveErrors_without};
    Cell_Time = {Time_DP, Time_DPSED, Time_DR, Time_Squish, Time_MDL, Time_without};
end


drawMultiLines(Cell_epsilon, Cell_ratio, legend_str, 'Error Bound $\zeta$(m)', 'Compression Ratio');
% drawMultiLines(Cell_epsilon, Cell_Time, legend_str, 'Error Bound $\zeta$(m)', 'Time (s)');
% drawMultiLines(Cell_ratio, Cell_error, legend_str, 'Compression Ratio (%)', 'Error (m)');
% drawMultiLines(Cell_ratio, Cell_errorSED, legend_str, 'Compression Ratio (%)', 'SED Error (m)');


%%

aveTime_DP = vpa(mean(Time_DP) * 34.84)
aveTime_DPSED = vpa(mean(Time_DPSED) * 34.84)
aveTime_DR = vpa(mean(Time_DR) * 34.84)
aveTime_Squish = vpa(mean(Time_Squish) * 34.84)
aveTime_MDL = vpa(mean(Time_MDL) * 34.84)
aveTime_without = vpa(mean(Time_without) * 34.84)
aveTime_with = vpa(mean(Time_with) * 34.84)