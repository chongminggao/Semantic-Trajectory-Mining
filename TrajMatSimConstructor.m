function LabelSimilarityMat = TrajMatSimConstructor(TrajRate, TraLevel)

TrajRate = bsxfun(@rdivide, TrajRate, sum(TrajRate,2));
TrajRate(isnan(TrajRate)) = 0;


[num,dim] = size(TrajRate);
LabelSimilarityMat = zeros(num);

for i = 1:num
    objectLine = TrajRate(i,:);
    diff = bsxfun(@max, 0, bsxfun(@minus, objectLine, TrajRate));
    simVector = 1 - sum(diff,2);
    LabelSimilarityMat(i,:) = simVector';
end

if TraLevel && TraLevel > 0
    newMat = LabelSimilarityMat;
    for i = 0:TraLevel-1
        left = i/TraLevel;
        right = (i+1)/TraLevel;
        left = quantile(LabelSimilarityMat(:),left);
        right = quantile(LabelSimilarityMat(:),right);
        newMat(left <= LabelSimilarityMat & LabelSimilarityMat < right) = i+1;
    end
    newMat(LabelSimilarityMat == 1) = TraLevel-1;
    LabelSimilarityMat = newMat;
end




end



