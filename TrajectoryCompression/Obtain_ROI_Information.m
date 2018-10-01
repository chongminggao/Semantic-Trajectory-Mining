function result_multi = Obtain_ROI_Information(result_multi,latLong,times)

    Layer = length(result_multi);
    for l = 1 : Layer
        result = result_multi{l};
        [latLong_ROI,latLong_ROI_index,times_ROI] = matching_to_ROIs(latLong, times, result);
        result.ROI_information = getROIInformation(result,latLong_ROI_index,times_ROI);
        result_multi{l} = result;
    end
end


function ROI_information = getROIInformation(result,latLong_ROI_index,times_ROI)
    num = size(result.X,1);
    ROI_information = cell(num,1);
    for i = 1:num
        ROI_information{i} = [];
    end
    for i = 1:size(latLong_ROI_index,1)
        ind = latLong_ROI_index(i,2);
        trajInd = latLong_ROI_index(i,1);
        ROI_information{ind} = [ROI_information{ind};[trajInd,datenum(times_ROI(i,:))]];
    end

end



function [latLong_ROI,latLong_ROI_index,times_ROI] = matching_to_ROIs(latLong, times, FastSyncResult)
% ===================================================================
% Associate the every single node in the trajectories to the SP found in
% last procedure. then derive a statistic result of the edge weight of SP network.

    
    matching = FastSyncResult.Map_Original_To_Prototype;
    [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');

    numberOfPrototypes = FastSyncResult.numberOfPrototypes;
    numberOfTrajectories = length(index_of_trajectory);

%     % The columns of assocation_mat are trajectories, rows are prototypes.
%     transferCount = zeros(numberOfPrototypes);
    
    latLong_ROI = zeros(size(latLong));
    latLong_ROI_index = zeros(size(latLong,1),2);
    
    index = 1;
    
    times = [times,times];
    times_ROI = times;
    
    

    for i = 1:numberOfTrajectories
% reduce and simplify the series [1,2,2,2,3,3,4,4] into [1,2,3,4]
        if i ~= numberOfTrajectories
            reduced_points = matching(pointer_start(i) : pointer_start(i+1)-1);
            oneTime = times(pointer_start(i) : pointer_start(i+1)-1,:);
        else
            reduced_points = matching(pointer_start(i) : end);
            oneTime = times(pointer_start(i) : end,:);
        end
                
        if length(reduced_points) > 1 % only contains one SP, can't become a SP pair.
            reduced_index_set = false(length(reduced_points),1);
            repeatItem = 0;
            lastNeedUpdateInd = 1;
            for j = 2: length(reduced_points)
                if(reduced_points(j) == reduced_points(j-1))
                    reduced_index_set(j) = true;
                    repeatItem = repeatItem + 1;
                    oneTime(lastNeedUpdateInd,2) = oneTime(j,2);
                else
                    lastNeedUpdateInd = j;
                end
            end

            reduced_points(reduced_index_set)=[];
            oneTime(reduced_index_set,:)=[];
        end
        
        
        
        new_representation_for_this_trajectory = [index_of_trajectory(i) * ones(length(reduced_points),1), FastSyncResult.X(reduced_points,:)];
        numForThis = size(new_representation_for_this_trajectory,1);
        latLong_ROI(index:(index + numForThis-1) ,:) = new_representation_for_this_trajectory;
        latLong_ROI_index(index:(index + numForThis-1) ,:) = [index_of_trajectory(i) * ones(length(reduced_points),1),reduced_points];
        times_ROI(index:(index + numForThis-1) ,:) = oneTime;
        index = index + numForThis;
    end
    
    latLong_ROI(index:end,:) = [];
    latLong_ROI_index(index:end,:) = [];
    times_ROI(index:end,:) = [];
end