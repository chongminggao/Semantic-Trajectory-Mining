function mat = Tra_distance_matrix_using_dtw_index(latLong_using_prototypes_index, SP)
[index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);

mat = zeros(numberOfTrajectories);

SPdistMat = dist(SP,SP');

for i = 1:numberOfTrajectories
    if i ~= numberOfTrajectories
        a = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
    else
        a = latLong_using_prototypes_index(pointer_start(i) : end,2);
    end
    
    for j = 1: i - 1
        
        if j ~= numberOfTrajectories
            b = latLong_using_prototypes_index(pointer_start(j) : pointer_start(j+1)-1,2);
        else
            b = latLong_using_prototypes_index(pointer_start(j) : end,2);
        end
        
        mat(i,j) = Tra_index_dtw(a,b,SPdistMat);
        mat(j,i) = mat(i,j);
    end
end


end