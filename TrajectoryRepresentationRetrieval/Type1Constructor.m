function Neighbor_type1 = Type1Constructor(nodeCount,type1)
    count = nodeCount;
    countDist = dist(count,count');
    countDist = countDist/max(max(countDist));
    Neighbor_type1 = zeros(size(countDist,1),type1);
    for i = 1:length(countDist)
        [~, index] = sort(countDist(i,:));
        index(index == i) = [];
        Neighbor_type1(i,1:type1) = index(1:type1);
    end
end
