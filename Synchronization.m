function [X, RC] = Synchronization(X,weights,Neighbors_IDX,isInEpsilonRange,...
    max_displacement,alpha)
%
% param.Knn : The number of nearest neighbors of each 2-dimension GPS point.
% param.epsilon : the interactive distance range of every point. Given a 
% GPS point, if the number of neighbors in this range is less than param.Knn
% , then this point will be seen as an anomaly and will not considered as a
% prototype point.

RC = [0]; % undo

Neighbors_weights = weights(Neighbors_IDX);
numberOfInRange = sum(Neighbors_weights .* isInEpsilonRange, 2);

while true
    isConverge = true;
    for i = 1:size(X,2)
        X_neighbors_i = reshape(X(Neighbors_IDX',i),size(Neighbors_IDX,2),size(Neighbors_IDX,1));
        X_neighbors_i = X_neighbors_i';
        change_matrix = sin(bsxfun(@minus, X_neighbors_i, X(:,i)) .* isInEpsilonRange);
        change_matrix = change_matrix .* Neighbors_weights;
        final_change_vector = alpha * sum(change_matrix,2)./(numberOfInRange + weights);
        final_change_vector(isnan(final_change_vector)) = 0;
        X(:,i) = X(:,i) + final_change_vector;
%         fprintf('%f\n',max(abs(final_change_vector)));
        if max(abs(final_change_vector)) > max_displacement
            isConverge = false;
        end
    end
    if isConverge
        break;
    end
end