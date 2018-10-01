function mat = Tra_distance_matrix_using_dtw(latLong)
[index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);

mat = zeros(numberOfTrajectories);

for i = 1:numberOfTrajectories
    if i ~= numberOfTrajectories
        a = latLong(pointer_start(i) : pointer_start(i+1)-1,2:3);
    else
        a = latLong(pointer_start(i) : end,2:3);
    end
    
    for j = 1: i - 1
        
        if j ~= numberOfTrajectories
            b = latLong(pointer_start(j) : pointer_start(j+1)-1,2:3);
        else
            b = latLong(pointer_start(j) : end,2:3);
        end
        
        mat(i,j) = Tra_dtw(a,b);
        mat(j,i) = mat(i,j);
    end
end


end