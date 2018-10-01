function [numOfTrajectory,index_of_trajectory_new,latLong_using_prototypes_index] = GetNumberOfTrajectory(latLong_using_prototypes_index, atleastN)
    [index_of_trajectory, pointer] = unique(latLong_using_prototypes_index(:,1),'stable');
    pointer = [pointer(:); size(latLong_using_prototypes_index,1) + 1];
    numOfTrajectory = 0;
    index_of_trajectory_new = [];
    removeSet = [];
    for i = 1:length(index_of_trajectory)
        tralen = pointer(i+1) - pointer(i);
        if tralen >= atleastN
            numOfTrajectory = numOfTrajectory + 1;
            index_of_trajectory_new = [index_of_trajectory_new;index_of_trajectory(i)];
        else
            removeSet = [removeSet, pointer(i) : (pointer(i+1)-1)];
        end
    end
    latLong_using_prototypes_index(removeSet,:) = [];
end




