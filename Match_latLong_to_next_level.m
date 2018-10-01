function latLong_next_level = Match_latLong_to_next_level(latLong,FastSyncResult)
% ===================================================================
% Associate the every single node in the trajectories to the SP found in
% last procedure. then derive a statistic result of the edge weight of SP network.

    
    matching = FastSyncResult.Map_Original_To_Prototype;
    latLong_next_level = latLong;
    
    
%     matching(matching <= 0) = 1;
    latLong_next_level(:,2:3) = FastSyncResult.X(matching,:);
    
end




