function [param_multi,result_multi,Times] = InvokeHierarchicalSync(Layer, param_multi, latLong_init,isVisual)
%     param_multi = cell(Layer,1);
    result_multi = cell(Layer,1);
    isFirstLevel = true;
    isOnlineAdd = false;
    
    last_FastSyncResult.latLong_via_ROI = latLong_init;
    last_FastSyncResult.nodeCount = [last_FastSyncResult.latLong_via_ROI(:,2:3),ones(size(last_FastSyncResult.latLong_via_ROI,1),1)];

    Times = ones(Layer,1);
    
    % Loop For obtain the hierarchical Sync.
    for l = 1:Layer
        param = param_multi{l};
        fprintf('============Hierarchical FastSync Round [%d]...============\n',l);
        tic;
        [param_l, FastSyncResult] = SingleSync(param, last_FastSyncResult, isFirstLevel,isVisual,isOnlineAdd);
        Times(l) = toc;
        isFirstLevel = false;
        param_multi{l} = param_l;
        result_multi{l} = FastSyncResult;

%         last_latLong_via_ROI = latLong_level;
        last_FastSyncResult = FastSyncResult;
%         last_nodeCount = nodeCount;
    end

end