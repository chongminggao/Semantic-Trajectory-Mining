function LabelSimilarityMat = LabelMatConstructor(Rate, numOfRankLevel)

Rate = bsxfun(@rdivide, Rate, sum(Rate,2));
Rate(isnan(Rate)) = 0;

[num,dim] = size(Rate);
LabelSimilarityMat = zeros(num,num);

for i = 1:num
    objectLine = Rate(i,:);
    diff = bsxfun(@max, 0, bsxfun(@minus, objectLine, Rate));
    simVector = 1 - sum(diff,2);
    LabelSimilarityMat(i,:) = simVector';
end

if numOfRankLevel && numOfRankLevel > 0
    newMat = LabelSimilarityMat;
    for i = 0:numOfRankLevel-1
        left = i/numOfRankLevel;
        left = quantile(LabelSimilarityMat(:),left);
        right = (i+1)/numOfRankLevel;
        right = quantile(LabelSimilarityMat(:),right);
        newMat(left <= LabelSimilarityMat & LabelSimilarityMat < right) = i+1;
    end
    newMat(LabelSimilarityMat == 1) = numOfRankLevel;
    LabelSimilarityMat = newMat;
end


end