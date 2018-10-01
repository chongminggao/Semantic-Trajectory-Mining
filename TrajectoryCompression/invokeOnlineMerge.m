function [param_multi_online, result_multi_online,AveError,ErrorVectors] = invokeOnlineMerge(param_multi_base,result_multi_base,latLong_merge, isVisual,latLong_base)
    param_multi_online = param_multi_base;
    result_multi_online = result_multi_base;
    
    numofOnline = length(unique(latLong_merge(:,1)));
    [~,pointer] = unique(latLong_merge(:,1),'stable');
    pointer = [pointer;size(latLong_merge,1) + 1];
    
    %=====================
    AveError = zeros(numofOnline + 1, 1);
    ErrorVectors = cell(numofOnline + 1, 1);
    [AveError(1),ErrorVectors{1}] = DMDK_calculate_error(latLong_base, result_multi_online);   
    %=====================
    
    for i = 1:numofOnline
        oneLatLong = latLong_merge(pointer(i):pointer(i+1)-1, :);
        [param_multi_online, result_multi_online] = merge(param_multi_online, result_multi_online, oneLatLong, isVisual);
        
        %=====================
        [aveError, vector]= DMDK_calculate_error(latLong_base, result_multi_online);
        AveError(i+1) = aveError;
        ErrorVectors{i+1} = vector;
        %=====================
        
    end
end


function [param_multi, result_multi] = merge(param_multi, result_multi, oneLatLong, isVisual)
    Layer = length(param_multi);
    isFirstLevel = true;
    isOnlineAdd = true;
    
    for l = 1:Layer
        param = param_multi{l};
        this_FastSyncResult = result_multi{l};
        latLong_via_ROI = this_FastSyncResult.latLong_via_ROI;
        latLong_new = [latLong_via_ROI;oneLatLong];
        this_FastSyncResult.latLong_via_ROI = latLong_new;
        
        if l == 1
%             last_FastSyncResult.latLong_via_ROI = this_FastSyncResult.latLong_via_ROI;
            last_FastSyncResult.nodeCount = [this_FastSyncResult.latLong_via_ROI(:,2:3),ones(size(this_FastSyncResult.latLong_via_ROI,1),1)];
        else
            last_FastSyncResult = result_multi{l-1};
        end
        
        [param_l, FastSyncResult] = SingleSync(param, last_FastSyncResult, isFirstLevel, isVisual, isOnlineAdd, this_FastSyncResult);
        param_multi{l} = param_l;
        result_multi{l} = FastSyncResult;
        isFirstLevel = false;
        
    end
end


