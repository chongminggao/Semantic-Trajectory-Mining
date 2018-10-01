function roundabouts = getRoundabouts(intersects_threshold,connectivity_matrix,intersection_nodes,intersection_node_indices)
    subMat = connectivity_matrix(:,intersection_node_indices);
    count = sum(subMat);
%     tabulate(count)
    roundabouts_indices = find(count>=intersects_threshold);
%     subMat = connectivity_matrix(:,roundabouts_indices);
%     count = sum(subMat);
%     tabulate(count)
    roundabouts_indices = 1:length(roundabouts_indices);    
    roundabouts = intersection_nodes.xys(:,roundabouts_indices)';
end