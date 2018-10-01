function [TraEmbeddedVector,index_of_trajectory] = TrajectoryEmbedding(SPEmbeddedVector, latLong_using_prototypes_index, mode)

[index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);
dim = size(SPEmbeddedVector,2);

TraEmbeddedVector = zeros(numberOfTrajectories,dim);

for i = 1:numberOfTrajectories

        if i ~= numberOfTrajectories
            SPSequence = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
        else
            SPSequence = latLong_using_prototypes_index(pointer_start(i) : end,2);
        end
        
        if isequal(mode,'sum')
            TraEmbeddedVector(i,:) = sum(SPEmbeddedVector(SPSequence,:));
        elseif isequal(mode,'mean')
            TraEmbeddedVector(i,:) = mean(SPEmbeddedVector(SPSequence,:));
        end

end