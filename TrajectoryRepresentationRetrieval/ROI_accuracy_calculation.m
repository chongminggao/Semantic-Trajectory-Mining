function [means,stds] = ROI_accuracy_calculation(SPEmbeddedVector,LabelSimilarityMat,Num, random)
    len = size(SPEmbeddedVector,1)-1;
    accuracy_vector = zeros(Num,3);

    if random
        for i = 1 : Num
            ii = ceil(rand() * size(SPEmbeddedVector,1));
            TopKIdx = randperm(size(SPEmbeddedVector,1));
            TopKIdx(ii == TopKIdx) = [];
    %         TopKIdx = TopKIdx(1:len);
            accuracy = NDCGatK((1:len)', LabelSimilarityMat(ii,TopKIdx));
        %         fprintf('round[%d]: Point[%d] accuracy:  %f\n',i,ii,accuracy);
            accuracy = accuracy([3,5,10]);
            accuracy_vector(i,:) =  accuracy;
        end
    else
        for i = 1 : Num
            ii = ceil(rand() * size(SPEmbeddedVector,1));
            [TopKIdx,~] = findTopKSimilarSP(SPEmbeddedVector,len,ii,'E');
            accuracy = NDCGatK((1:len)', LabelSimilarityMat(ii,TopKIdx));
            accuracy = accuracy([3,5,10]);
            accuracy_vector(i,:) =  accuracy;
        end
    end
    means = mean(accuracy_vector);
    stds = std(accuracy_vector);
end
