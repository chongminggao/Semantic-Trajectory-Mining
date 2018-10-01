function [minIdx,minDist] = findTopKSimilarSP(SPEmbeddedVector,k,idx,mode)

oneVector = SPEmbeddedVector(idx,:);


if isequal(mode,'C')
    matSimilar = MatCos(SPEmbeddedVector,oneVector);

    matDiffer = [(1:length(matSimilar))',matSimilar];

    result = sortrows(matDiffer,-2);
elseif isequal(mode,'E')
    
    matDiffer = dist ( SPEmbeddedVector,oneVector');

    matDiffer = [(1:length(matDiffer))',matDiffer];
 
    result = sortrows(matDiffer,2);
end

if k > size(SPEmbeddedVector,1)
    k =  size(SPEmbeddedVector,1) - 1;
end
minDist = result(1:k+1,2); 
minIdx = result(1:k+1,1);

minDist(minIdx == idx) = [];
minIdx(minIdx == idx) = [];



end