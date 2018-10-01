function type5Neighborhoods = Type5Constructor(LabelSimilarityMat,type5)
    num = size(LabelSimilarityMat,1);
    type5Neighborhoods = zeros(num,type5);
    for i = 1:num
        temp = LabelSimilarityMat(i,:);
        [temp,c] = sort(temp,'descend');
        threshold = temp(type5);
        indeces = c(temp >= threshold);
        numberOfN = length(indeces);
        index= randperm(numberOfN);
        type5Neighborhoods(i,:) = indeces(index(1:type5));
    end
end