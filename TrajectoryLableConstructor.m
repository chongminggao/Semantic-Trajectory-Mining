function TrajRate = TrajectoryLableConstructor(latLong_using_prototypes_index,Rate)
[index_of_trajectory,pointer] = unique(latLong_using_prototypes_index(:,1),'stable');
pointer = [pointer(:); size(latLong_using_prototypes_index,1) + 1];
num = length(index_of_trajectory);

TrajRate = zeros(num,size(Rate,2));
for i = 1:num
    for ind = latLong_using_prototypes_index(pointer(i):pointer(i+1)-1,2)'
        TrajRate(i,:) = TrajRate(i,:) + Rate(ind,:);
    end
%     TrajRate(i,:) = TrajRate(i,:)/sum(TrajRate(i,:));
end
TrajRate(isnan(TrajRate)) = 0;
end