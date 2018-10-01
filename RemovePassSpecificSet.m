function TopK_index_new = RemovePassSpecificSet(latLong_using_prototypes_index, idx, TopK_index, rate)
[index_of_trajectory,pointer] = unique(latLong_using_prototypes_index(:,1),'stable');
pointer = [pointer(:); size(latLong_using_prototypes_index,1) + 1];

if idx > length(index_of_trajectory)
    error('idx is too large!');
end
tra = latLong_using_prototypes_index(pointer(idx):pointer(idx+1)-1,2);
tra = unique(tra);


jj = 0;

TopK_index_new = [];
for i=1:length(TopK_index)
%     if(jj == compareK)
%         break;
%     end
    indj = TopK_index(i);
    traj = latLong_using_prototypes_index(pointer(indj):pointer(indj+1)-1,2);
    traj = unique(traj);
    
    if length(intersect(traj,tra))/length(tra) <= rate
        TopK_index_new = [TopK_index_new, indj];
        jj = jj + 1;
    end
end
end