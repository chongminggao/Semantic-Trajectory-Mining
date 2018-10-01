function [SourceNeighbor,weightedDegreeCount] = findNeighborsOfSourceSP(SP_pair_indeces,num,nodeCount)
    SP_pair_indeces = Direct2NonDirectGraph(SP_pair_indeces);
    SourceNeighbor = cell(num,1);
    weightedDegreeCount = zeros(size(nodeCount));
    for i = 1:size(SP_pair_indeces,1)
        u = SP_pair_indeces(i,1);
        v = SP_pair_indeces(i,2);
        SourceNeighbor{u} = [SourceNeighbor{u};v];
    end
    
    for i = 1:num
        SourceNeighbor{i} = unique(SourceNeighbor{i});
    end
    
    for i = 1:num
        neighbors = SourceNeighbor{i};
        for j = 1:length(neighbors)
            weightedDegreeCount(i) = weightedDegreeCount(i) + nodeCount(neighbors(j));
        end
    end
end

function SP_pair_indeces = Direct2NonDirectGraph(SP_pair_indeces)
    a = SP_pair_indeces;
    b(:,[1,2,3]) = a(:,[2,1,3]);
    c = [a,b]';
    c = reshape(c, 3, 2*size(a,1));
    SP_pair_indeces = c';
end