
isVisual = true;


% Whether sync with or without roundabouts
param.syncRoundabouts = false;

%% Obtain the base network and merged network of online merge version

ratio_merge_base = 0.50;
numberOfMergeBase = ceil(numberOfOffline * ratio_merge_base);
numberOfmerge = numberOfOffline - numberOfMergeBase;

% Initiation
latLong_merge_base = latLong(1:numberOfMergeBase,:);
latLong_merge = latLong(numberOfMergeBase + 1: numberOfOffline,:);

% ===========================
% latLong_merge(:,1) = -1;
% ===========================


latLong_init = latLong_merge_base;

% isVisual = true;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_merge_base, result_multi_merge_base] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);
[param_multi_merge, result_multi_merge, average_merge,error_merge] = invokeOnlineMerge(param_multi_merge_base,result_multi_merge_base,latLong_merge, isVisual,latLong_offline);




%% Conduct the online Truncate operation
ratio_truncate_base = 1.50;
numberOfTruncateBase = ceil(numberOfOffline * ratio_truncate_base);
numberOftruncate = numberOfTruncateBase - numberOfOffline;

% Initiation
latLong_truncate_base = latLong(1:numberOfTruncateBase,:);

% ===========================
% latLong_truncate_base(numberOfTruncateBase - numberOftruncate + 1:end, 1) = -1;
% ===========================

latLong_truncate_index = numberOfOffline + 1: numberOfTruncateBase;

latLong_init = latLong_truncate_base;

% isVisual = true;

% Invoke hierarchical Sync Part 3: Invoke iterations.
[param_multi_truncate_base, result_multi_truncate_base] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual);
[param_multi_truncate, result_multi_truncate,average_truncate,error_truncate] = invokeOnlineTruncate(param_multi_truncate_base,result_multi_truncate_base, latLong_truncate_index, isVisual,latLong_truncate_base);

%% Plot the error agaist the merging or diff trajectory

drawErrorAgaistUpdateNumber(error_merge, error_truncate);

set(gca,'Xlim',[1 50])

