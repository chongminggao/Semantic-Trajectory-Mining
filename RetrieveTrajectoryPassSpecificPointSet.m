function [TraIndSet, allRate] = RetrieveTrajectoryPassSpecificPointSet( latLong_using_prototypes_index ,pointSet , rate)
[index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);


TraIndSet = [];
allRate = zeros(numberOfTrajectories,1);

for i = 1:numberOfTrajectories

        if i ~= numberOfTrajectories
            SPSequence = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
        else
            SPSequence = latLong_using_prototypes_index(pointer_start(i) : end,2);
        end
        
        allRate(i) = length(intersect(SPSequence,pointSet));
        if length(intersect(SPSequence,pointSet))/length(pointSet) >= rate
            TraIndSet = [TraIndSet;index_of_trajectory(i)];
        end
end
    
end