function Neighbor_type2 = Type2Constructor(SourceNeighbor,numberOfPartition,weightedDegreeCount,transferCount,type2)
    [NeighborDegreeDistribution_new] = construct_NeighborDegreeDistribution(SourceNeighbor,numberOfPartition,weightedDegreeCount,transferCount);
    distanceMat = KL_matrixDivergence(NeighborDegreeDistribution_new);
    Neighbor_type2 = zeros(size(distanceMat,1),type2);
    for i = 1:length(distanceMat)
        [~, index] = sort(distanceMat(i,:));
        index(index == i) = [];
        Neighbor_type2(i,1:type2) = index(1:type2);
    end
end


function [NeighborDegreeDistribution_new] = construct_NeighborDegreeDistribution(SourceNeighbor, numberOfPartition,weightedDegreeCount,transferCount)
%     neighbornumbertable = zeros(length(SourceNeighbor),1);
    NeighborDegreeDistribution = zeros(length(SourceNeighbor),numberOfPartition);

%     for i = 1:length(neighbornumbertable)
%         neighbornumbertable(i) = length(SourceNeighbor{i});
%     end
    
    while numberOfPartition > (length(SourceNeighbor) - 1)/2
        numberOfPartition = floor(numberOfPartition/2);
    end
    if numberOfPartition < 1
        error('Please input the reasonable partition\n');
    end
    
%     threshold = floor(max(weightedDegreeCount) / numberOfPartition);
    threshold = (max(weightedDegreeCount) / numberOfPartition);
    
    
    for i = 1:length(SourceNeighbor)
        neighbors_i = SourceNeighbor{i};
        for j = 1:length(neighbors_i)
            index = weightedDegreeCount(neighbors_i(j));
%             
%             switch index
%                 case {1,2}
%                     NeighborDegreeDistribution(i,1) = NeighborDegreeDistribution(i,1) + 1;
%                 case{3,4,5}
%                     NeighborDegreeDistribution(i,2) = NeighborDegreeDistribution(i,2) + 1;
%                 case{6,7,8,9}
%                     NeighborDegreeDistribution(i,3) = NeighborDegreeDistribution(i,3) + 1;
%                 otherwise
%                     NeighborDegreeDistribution(i,4) = NeighborDegreeDistribution(i,4) + 1;
%             end
            
            bin = floor((index - 1)/threshold) + 1;
            if bin == numberOfPartition + 1
                bin = numberOfPartition;
            end
            NeighborDegreeDistribution(i,bin) = NeighborDegreeDistribution(i,bin) + transferCount(i,neighbors_i(j)) + transferCount(neighbors_i(j),i);
            
%             NeighborDegreeDistribution(i,index+1) = NeighborDegreeDistribution(i,index+1) + 1;
        end
    end
    
    colomsum = sum(NeighborDegreeDistribution,1);
    cumrate = cumsum(colomsum) / sum(colomsum);
    findresult = find(cumrate >= 0.9);
    NeighborDegreeDistribution_new = NeighborDegreeDistribution(:,1:findresult(1));
    NeighborDegreeDistribution_new(:,findresult(1)) = sum(NeighborDegreeDistribution(:,findresult(1):end),2);
    
end