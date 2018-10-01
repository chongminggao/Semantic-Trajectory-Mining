function [param_multi_online, result_multi_online,AveError,ErrorVectors] = invokeOnlineTruncate(param_multi_base,result_multi_base, latLong_truncate_index, isVisual,latLong_base)
    param_multi_online = param_multi_base;
    result_multi_online = result_multi_base;
    
    latLong_index = result_multi_base{1}.latLong_via_ROI(:,1);
%     numofTruncatedTraj= length(unique(latLong_index(latLong_truncate_index)));
    [Traindeces,~] = unique(latLong_index(latLong_truncate_index),'stable');
    
    %=====================
    AveError = zeros(length(Traindeces)+ 1, 1);
    ErrorVectors = cell(length(Traindeces)+ 1, 1);
    [AveError(1),ErrorVectors{1}] = DMDK_calculate_error(latLong_base, result_multi_online);
    %=====================
    
    for i = length(Traindeces):-1:1
        Traindex = Traindeces(i);
        index = find(latLong_index == Traindex);
        notTruncatedIndex = setdiff(index,latLong_truncate_index);
        if ~isempty(notTruncatedIndex)
            for j = 1:length(notTruncatedIndex)
                index(index ==  notTruncatedIndex(j)) = [];
            end
        end
        [param_multi_online, result_multi_online] = truncate(param_multi_online, result_multi_online, index, isVisual);
        latLong_index = result_multi_online{1}.latLong_via_ROI(:,1);
        
        
        %=====================
        [aveError, errorVector] = DMDK_calculate_error(latLong_base, result_multi_online);
        ErrorVectors{length(Traindeces) - i + 2} = errorVector;
        AveError(length(Traindeces) - i + 2) = aveError;
        %=====================
    end
end


function [param_multi, result_multi] = truncate(param_multi, result_multi, index, isVisual)
    Layer = length(param_multi);
    isFirstLevel = true;
    isOnlineAdd = true;
    
    for l = 1:Layer
        param = param_multi{l};
        this_FastSyncResult = result_multi{l};
        latLong_new = this_FastSyncResult.latLong_via_ROI;
        latLong_new(index,:) = [];
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

function visualization_tuncated_version(param_multi_online)
    for i = 1:length(param_multi_online)
        param = param_multi_online{i};
        SP_pairs = param.SP_pairs;
        visualization(SP_pairs,param);
    end
end

