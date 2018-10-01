function  [minDist,minIdx]= findSimilarVectors(X,k,idxa, mode)

a = X(idxa,:);


if isequal(mode,'Euclidean')
    matDiffer = dist(X, a');
    [minDist,minIdx] = sort(matDiffer);
elseif isequal(mode,'cosine')
    matDiffer = MatCos(X, a);
    [minDist,minIdx] = sort(matDiffer,'descend');
else
    error('pay attention to the mode !')
end

if k > size(X,1)
    k =  size(X,1) - 1;
end




minDist(minIdx == idxa) = [];
minIdx(minIdx == idxa) = [];

minDist = minDist(1:k);
minIdx = minIdx(1:k);


end