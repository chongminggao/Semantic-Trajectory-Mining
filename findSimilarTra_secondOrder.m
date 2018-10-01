function  [maxSimilarity,maxIdx]= findSimilarTra_secondOrder(SP,latLong_using_prototypes_index,latLong2SP,num,k,randnum, mode)

SPdistMat = MatCos(SP,SP);

if isequal(mode,'binary')
    [index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
    numberOfTrajectories = length(index_of_trajectory);
    TraSp = zeros(numberOfTrajectories,size(SP,1));
    for i = 1:numberOfTrajectories
        if i ~= numberOfTrajectories
            a = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
        else
            a = latLong_using_prototypes_index(pointer_start(i) : end,2);
        end
        
        for j = 1:length(a)
            indexSP = a(j);
            TraSp(i,indexSP) = 1;
        end        
    end
    TraTra = TraSp * SPdistMat * TraSp';
    
elseif isequal(mode,'multi')
    [index_of_trajectory, pointer_start] = unique(latLong2SP(:,1),'stable');
    numberOfTrajectories = length(index_of_trajectory);
    TraSp = zeros(numberOfTrajectories,size(SP,1));
    for i = 1:numberOfTrajectories
        if i ~= numberOfTrajectories
            a = latLong2SP(pointer_start(i) : pointer_start(i+1)-1,2);
        else
            a = latLong2SP(pointer_start(i) : end,2);
        end
        
        for j = 1:length(a)
            indexSP = a(j);
            TraSp(i,indexSP) = TraSp(i,indexSP) + 1;
        end        
    end
    TraTra = TraSp * SPdistMat * TraSp';
else
    error('pay attention to the mode !')
end

maxSimilarity = zeros(num,numberOfTrajectories - 1);
maxIdx = zeros(num,numberOfTrajectories - 1);


for indxxx = 1:num
    i = randnum(indxxx);
    similarity = TraTra(i,:);
    [similarity, index] = sort(similarity, 'descend');
    
    similarity(index == i) = [];
    index(index == i) = [];
    
    maxSimilarity(indxxx,:) = similarity;
    maxIdx(indxxx,:) = index;
    
    if k >= numberOfTrajectories
        k =  numberOfTrajectories - 1;
    end
    
    maxSimilarity(:,k+1:end) = [];
    maxIdx(:,k+1:end) = [];
    
end

    
end


