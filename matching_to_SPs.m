function [latLong_new_representation,latLong_using_prototypes_index,SP_pairs, SP_pairs_index,transferCount] = matching_to_SPs(latLong,FastSyncResult)
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
    
%     while size(SP_statistic,1) > 0
%         one_SP_pair = SP_statistic(1,:);
%         indeces = bsxfun(@eq,SP_statistic,one_SP_pair);
%         indeces = sum(indeces,2);
%         indeces = (indeces == 2);
%         
%         count = sum(indeces);
%         SP_pairs_index = [SP_pairs_index;one_SP_pair,count];
%         SP_pairs = [SP_pairs;FastSyncResult.X(one_SP_pair(1),:),...
%             FastSyncResult.X(one_SP_pair(2),:),count];
%         SP_statistic(indeces,:) = [];
%         
%     end
    

    SP_pairs = zeros(numberOfPrototypes * numberOfPrototypes,5);
    SP_pairs_index = zeros(numberOfPrototypes * numberOfPrototypes,3);
    
    reduced_set = false(numberOfPrototypes*numberOfPrototypes,1);
    for i = 1:numberOfPrototypes
        for j = 1:numberOfPrototypes
            rowIndex = numberOfPrototypes * (i - 1) + j;
            SP_pairs_index(rowIndex, : ) = [i,j,transferCount(i,j)];
            SP_pairs(rowIndex, : ) = [FastSyncResult.X(i,:),FastSyncResult.X(j,:),transferCount(i,j)];
            if transferCount(i,j) == 0
                reduced_set(rowIndex) = true;
            end
        end
    end
    
    SP_pairs_index(reduced_set,:) = [];
    SP_pairs(reduced_set,:) = [];
    

end




