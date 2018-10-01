% function accuracy_vector = Trajectory_accuracy_calculation(latLong_using_prototypes_index,TrajEmbeddedVector,LabelSimilarityMat,Num,TOPK,rate,random)
function [accuracy_DTW_vector,accuracy_LCSS_vector,accuracy_EDR_vector,accuracy_Frechet_vector] = Trajectory_accuracy_Comparison(latLong_using_prototypes_index,DTW_Similar_Mat, LCSS_Similar_Mat, EDR_Similar_Mat, Frechet_Similar_Mat,TrajSimMat,Num,rate)



    accuracy_DTW_vector = zeros(Num,3);
    accuracy_LCSS_vector = zeros(Num,3);
    accuracy_EDR_vector = zeros(Num,3);
    accuracy_Frechet_vector = zeros(Num,3);

    for i = 1 : Num
        ii = ceil(rand() * size(TrajSimMat,1));
        TopK_DTW = DTW_Similar_Mat(ii,:);
        TopK_LCSS = LCSS_Similar_Mat(ii,:);
        TopK_EDR = EDR_Similar_Mat(ii,:);
        TopK_Frechet = Frechet_Similar_Mat(ii,:);
        
        TopK_DTW = RemovePassSpecificSet(latLong_using_prototypes_index, ii, TopK_DTW, rate);
        TopK_LCSS = RemovePassSpecificSet(latLong_using_prototypes_index, ii, TopK_LCSS, rate);
        TopK_EDR = RemovePassSpecificSet(latLong_using_prototypes_index, ii, TopK_EDR, rate);
        TopK_Frechet = RemovePassSpecificSet(latLong_using_prototypes_index, ii, TopK_Frechet, rate);

        accuracy_DTW = NDCGatK((1:length(TopK_DTW))', TrajSimMat(ii,TopK_DTW));
        accuracy_LCSS = NDCGatK((1:length(TopK_LCSS))', TrajSimMat(ii,TopK_LCSS));
        accuracy_EDR = NDCGatK((1:length(TopK_EDR))', TrajSimMat(ii,TopK_EDR));
        accuracy_Frechet = NDCGatK((1:length(TopK_Frechet))', TrajSimMat(ii,TopK_Frechet));
        
        accuracy_DTW = accuracy_DTW([3,5,10]);
        accuracy_LCSS = accuracy_LCSS([3,5,10]);
        accuracy_EDR = accuracy_EDR([3,5,10]);
        accuracy_Frechet = accuracy_Frechet([3,5,10]);
        
        accuracy_DTW_vector(i,:) =  accuracy_DTW;
        accuracy_LCSS_vector(i,:) =  accuracy_LCSS;
        accuracy_EDR_vector(i,:) =  accuracy_EDR;
        accuracy_Frechet_vector(i,:) =  accuracy_Frechet;
    end

end