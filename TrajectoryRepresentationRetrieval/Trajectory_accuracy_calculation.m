function [means,stds] = Trajectory_accuracy_calculation(latLong_using_prototypes_index,TrajEmbeddedVector,LabelSimilarityMat,Num,rate,random)

    len = size(TrajEmbeddedVector,1)-1;
    accuracy_vector = zeros(Num,3);

    if random
        for i = 1 : Num
            ii = ceil(rand() * size(TrajEmbeddedVector,1));
            TopKIdx = randperm(size(TrajEmbeddedVector,1));
            TopKIdx(ii == TopKIdx) = [];
    %         TopKIdx = TopKIdx(1:TOPK);

            TopK_index = RemovePassSpecificSet(latLong_using_prototypes_index, ii, TopKIdx, rate);

            accuracy = NDCGatK((1:length(TopK_index))', LabelSimilarityMat(ii,TopK_index));
        %         fprintf('round[%d]: Point[%d] accuracy:  %f\n',i,ii,accuracy);
            accuracy = accuracy([3,5,10]);
            accuracy_vector(i,:) = accuracy;
        end
    else

        for i = 1 : Num
            ii = ceil(rand() * size(TrajEmbeddedVector,1));
            [TopKIdx,~] = findTopKSimilarSP(TrajEmbeddedVector,size(TrajEmbeddedVector,1)-1,ii,'E');
            TopK_index = RemovePassSpecificSet(latLong_using_prototypes_index, ii, TopKIdx, rate);

            accuracy = NDCGatK((1:1:length(TopK_index))', LabelSimilarityMat(ii,TopK_index));
        %         fprintf('round[%d]: Point[%d] accuracy:  %f\n',i,ii,accuracy);
            accuracy = accuracy([3,5,10]);
            accuracy_vector(i,:) = accuracy;
        end
    end
    means = mean(accuracy_vector);
    stds = std(accuracy_vector);
    
end