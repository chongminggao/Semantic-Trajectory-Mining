function[ratios, aveErrors] = Calculate_CascadeResult_Ratio_Error(latLong_Meter, param_multi_offline,result_multi_offline)
    Layer = length(param_multi_offline);
    
    ratios = zeros(Layer,1);
    aveErrors = zeros(Layer,1);
    
    for l = 1:Layer
        param = param_multi_offline{l};
        result = result_multi_offline{l};
        
        [latLong_new_representation,~] = matching_to_ROIs(latLong_Meter,result);
        ratio = Calculate_Ratio(result,latLong_new_representation);
        ratios(l) = ratio;
        
        aveError = Calculate_aveError(result,param,latLong_Meter);
        aveErrors(l) = aveError;
    end

end


function aveError = Calculate_aveError(result,param,latLong_Meter)
    latLong_ROI = result.X(result.Map_Original_To_Prototype,:);
    latLong_ROI = [latLong_Meter(:,1),latLong_ROI];
    latLong_ROI_Meter = TransferLatLongToMeter(param,latLong_ROI);
    
    distVector = distancebetween(latLong_ROI_Meter(:,2:3), latLong_Meter(:,2:3));
    aveError = mean(distVector);
end


function distVector = distancebetween(A, B)
    C = A-B;
    distVector = ( C(:,1).^2 + C(:,2).^2 ).^(1/2);
end


function ratio = Calculate_Ratio(result,latLong_new_representation)
    len_compressed = size(latLong_new_representation,1);
    len = length(result.Map_Original_To_Prototype);
    ratio = 1- len_compressed/len;
end


function [latLong_new_representation,latLong_using_prototypes_index] = matching_to_ROIs(latLong,FastSyncResult)
% ===================================================================
% Associate the every single node in the trajectories to the SP found in
% last procedure. then derive a statistic result of the edge weight of SP network.

    
    matching = FastSyncResult.Map_Original_To_Prototype;
    [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');

    numberOfPrototypes = FastSyncResult.numberOfPrototypes;
    numberOfTrajectories = length(index_of_trajectory);

    % The columns of assocation_mat are trajectories, rows are prototypes.
    transferCount = zeros(numberOfPrototypes);
    
    latLong_new_representation = zeros(size(latLong));
    latLong_using_prototypes_index = zeros(size(latLong,1),2);
    
    index = 1;

    for i = 1:numberOfTrajectories
% reduce and simplify the series [1,2,2,2,3,3,4,4] into [1,2,3,4]
        if i ~= numberOfTrajectories
            reduced_points = matching(pointer_start(i) : pointer_start(i+1)-1);
        else
            reduced_points = matching(pointer_start(i) : end);
        end
                
        if length(reduced_points) > 1 % only contains one SP, can't become a SP pair.
            reduced_index_set = false(length(reduced_points),1);
            repeatItem = 0;

            for j = 2: length(reduced_points)
                if(reduced_points(j) == reduced_points(j-1))
                    reduced_index_set(j) = true;
                    repeatItem = repeatItem + 1;
                else
                    transferCount(reduced_points(j-1),reduced_points(j)) = transferCount(reduced_points(j-1),reduced_points(j)) + 1;
                end
            end

            reduced_points(reduced_index_set)=[];
            
        end
        
        

        new_representation_for_this_trajectory = [index_of_trajectory(i) * ones(length(reduced_points),1), FastSyncResult.X(reduced_points,:)];
        numForThis = size(new_representation_for_this_trajectory,1);
        latLong_new_representation(index:(index + numForThis-1) ,:) = new_representation_for_this_trajectory;
        latLong_using_prototypes_index(index:(index + numForThis-1) ,:) = [index_of_trajectory(i) * ones(length(reduced_points),1),reduced_points];
        index = index + numForThis;
    end
    
    latLong_new_representation(index:end,:) = [];
    latLong_using_prototypes_index(index:end,:) = [];
    
end