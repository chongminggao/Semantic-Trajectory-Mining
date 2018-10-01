function distance = KL_matrixDivergence(NeighborDegreeDistribution)

NeighborDegreeDistribution = NeighborDegreeDistribution + 0.1;
distance = zeros(size(NeighborDegreeDistribution,1));

normMat = repmat(sum(NeighborDegreeDistribution,2),1,size(NeighborDegreeDistribution,2));
% normMat = repmat(max(sum(NeighborDegreeDistribution,2)),size(NeighborDegreeDistribution));

NeighborDegreeDistribution = NeighborDegreeDistribution./normMat;
for i = 1:size(NeighborDegreeDistribution,1)
    P = NeighborDegreeDistribution(i,:);
    P = repmat(P,size(NeighborDegreeDistribution,1),1);
    temp = log(P./NeighborDegreeDistribution);
    temp(isnan(temp)) = 0;
    distance(i,:) = sum(P .* (temp), 2)';
end

end