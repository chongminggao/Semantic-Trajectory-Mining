function [param, FastSyncResult] = SingleSync(param, last_FastSyncResult, isFirstLevel, isVisual, isOnlineAdd, this_FastSyncResult)
    
    if ~isOnlineAdd
        last_latLong_via_ROI = last_FastSyncResult.latLong_via_ROI;
    else
        last_latLong_via_ROI = this_FastSyncResult.latLong_via_ROI;
    end

    FastSyncResult = Fast_Hierarchical_Synchronization(last_latLong_via_ROI(:,[2,3]),param);
    

    % % Matching original trajectories to new prototype POIs.
    % SP_pairs represents the SPs pairs, whose row is [Along, Alat, Blong, BLat]
    % SP_pair_indeces is the SPs indeces pair as well as its count presented in
    % the trajectory transition, whose row is [A_index, B_index, count].

    
    latLong_via_ROI = Match_latLong_to_next_level(last_latLong_via_ROI,FastSyncResult);
    FastSyncResult.latLong_via_ROI = latLong_via_ROI;
    
    
    
    %% ========== if indicate the need of visualization ===============
    if isVisual
        [latLong_ROI,latLong_ROI_index,SP_pairs, SP_pair_indeces,transferCount] = matching_to_SPs(last_latLong_via_ROI,FastSyncResult);
        FastSyncResult.latLong_new_representation_reduced = latLong_ROI;
        FastSyncResult.latLong_ROI = latLong_ROI_index;
        param.SP_pairs = SP_pairs;
        param.SP_pair_indeces = SP_pair_indeces;
        % [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,2);
%     =========================
%             param.nodeSize_M = [20 800];
%             param.edgeSize_M = [1.5 8];
%     =========================


        [nodeCount,nodeCountIdx,node_visual_count] = nodeCounting(SP_pairs,SP_pair_indeces);
        try 
            nodeCount(:,1:2) = FastSyncResult.X;
        catch
            templen = size(FastSyncResult.X,1) - size(nodeCount,1);
            nodeCount = [nodeCount;zeros(templen,3)];
            nodeCountIdx = [nodeCountIdx;zeros(templen,1)];
            nodeCount(:,1:2) = FastSyncResult.X;
        end
        param.nodeCount = nodeCount;
        FastSyncResult.nodeCount = nodeCount;
        param.node_visual_count = node_visual_count;
        last_nodeCount = last_FastSyncResult.nodeCount;
        param.lastNodeCount = last_nodeCount;
        
         visualization(SP_pairs,param);
    end
% =======================================================================
    

    
    if ~isFirstLevel
        % ===========if there are any online additional ROI ===============
        if length(FastSyncResult.Map_Original_To_Prototype) > length(last_FastSyncResult.Map_Original_To_Prototype)
            last_FastSyncResult.Map_Original_To_Prototype = [last_FastSyncResult.Map_Original_To_Prototype;
                FastSyncResult.Map_Original_To_Prototype(length(last_FastSyncResult.Map_Original_To_Prototype)+1:end)];
        end
        % ==================================================================
        Mapping_to_son  = Map_this_to_last(FastSyncResult.Map_Prototype_To_Original,last_FastSyncResult.Map_Original_To_Prototype);
        param.Mapping_to_son = Mapping_to_son;
%         if isVisual
%             last_nodeCount = last_FastSyncResult.nodeCount;
%             param.lastNodeCount = last_nodeCount;
%         end
    else
        param.Mapping_to_son = FastSyncResult.Map_Prototype_To_Original;        
    end
    
    
end