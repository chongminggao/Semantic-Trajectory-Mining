function [SP_pairs,SP_pair_indeces,nodeCount] = removeJumpUsingSPNetwork(SP_pairs,SP_pair_indeces,nodeCount,threshold);
    
    
    abslatDiff = abs(SP_pairs(:,1) - SP_pairs(:,3));
    abslongDiff = abs(SP_pairs(:,2) - SP_pairs(:,4));
    
    roughDisDiff = abslatDiff + abslongDiff;
    roughDisDiffMean = mean(roughDisDiff);
    
    index = roughDisDiff > threshold * roughDisDiffMean;
    
    
    Doubleindex = [index,index];
    
    temp = SP_pair_indeces(:,[1,2]);
    subindex = SP_pair_indeces(Doubleindex);
    subindexA = subindex(1:length(subindex)/2);
    subindexB = subindex(length(subindex)/2 + 1:end);
    
    sub = SP_pair_indeces(index,3);
    
    for i = 1:length(sub)
        nodeCount(subindexA(i),3) = nodeCount(subindexA(i),3) - sub(i);
        nodeCount(subindexB(i),3) = nodeCount(subindexB(i),3) - sub(i);
    end
    
    fprintf('=======Removed SP_pairs are=======\n');
    disp(SP_pair_indeces(index,:))
    fprintf('==================================\n');
    
    SP_pairs(index,:) = [];
    SP_pair_indeces(index,:) = [];