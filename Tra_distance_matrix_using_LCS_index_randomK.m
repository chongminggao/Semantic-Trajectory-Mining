function [distance_Mat,index_Mat] = Tra_distance_matrix_using_LCS_index_randomK(latLong_using_prototypes_index, SP, randnum, num)
[index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);

distance = zeros(1,numberOfTrajectories);
distance_Mat = zeros(num,numberOfTrajectories - 1);
index_Mat = zeros(num,numberOfTrajectories - 1);


for indxxx = 1:num
    i = randnum(indxxx);
    if i ~= numberOfTrajectories
        a = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
    else
        a = latLong_using_prototypes_index(pointer_start(i) : end,2);
    end
    
    for j = 1: numberOfTrajectories
        
        if j ~= numberOfTrajectories
            b = latLong_using_prototypes_index(pointer_start(j) : pointer_start(j+1)-1,2);
        else
            b = latLong_using_prototypes_index(pointer_start(j) : end,2);
        end
        
        distance(j) = LCS(a,b);
        distance(j) = max(LCS(a,b(end:-1:1)), distance(j));
        
    end
    
    [distance, index] = sort(distance,'descend'); % with 'descend'!!!!!!!!
    
    distance(index == i) = [];
    index(index == i) = [];
    distance_Mat(indxxx,:) =distance;
    index_Mat(indxxx,:) =index;
    
end


end