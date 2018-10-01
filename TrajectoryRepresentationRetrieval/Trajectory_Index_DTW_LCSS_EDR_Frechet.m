function [DTW_Similar_Mat, LCSS_Similar_Mat, EDR_Similar_Mat, Frechet_Similar_Mat] = Trajectory_Index_DTW_LCSS_EDR_Frechet(latLong_using_prototypes_index, SP,param)
[index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);


DTW_Distance = zeros(numberOfTrajectories);
LCSS_Similarity = zeros(numberOfTrajectories);
EDR_Distance = zeros(numberOfTrajectories);
Frechet_Distance = zeros(numberOfTrajectories);

DTW_Similar_Mat = zeros(numberOfTrajectories,numberOfTrajectories-1);
LCSS_Similar_Mat = zeros(numberOfTrajectories,numberOfTrajectories-1);
EDR_Similar_Mat = zeros(numberOfTrajectories,numberOfTrajectories-1);
Frechet_Similar_Mat = zeros(numberOfTrajectories,numberOfTrajectories-1);

SPdistMat = dist(SP,SP');
dfcn = @(a,b) SPdistMat(a,b);
tol = max(param.axisRange(2) - param.axisRange(1), param.axisRange(4) - param.axisRange(3))/10;

for i = 1:numberOfTrajectories
    if mod(i,20) == 0
        fprintf('Trajectory similarity counting, the [%d]/[%d] trajectory is processing...\n',i,numberOfTrajectories);
    end
    if i ~= numberOfTrajectories
        a = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
    else
        a = latLong_using_prototypes_index(pointer_start(i) : end,2);
    end
    
    DTW_Distance(i,1:i-1) = DTW_Distance(1:i-1,i);
    LCSS_Similarity(i,1:i-1) = LCSS_Similarity(1:i-1,i);
    EDR_Distance(i,1:i-1) = EDR_Distance(1:i-1,i);
    Frechet_Distance(i,1:i-1) = Frechet_Distance(i,1:i-1);
    
    for j = i+1: numberOfTrajectories
        if j ~= numberOfTrajectories
            b = latLong_using_prototypes_index(pointer_start(j) : pointer_start(j+1)-1,2);
        else
            b = latLong_using_prototypes_index(pointer_start(j) : end,2);
        end
        DTW_Distance(i,j) = Tra_index_dtw(a,b,SPdistMat);
        DTW_Distance(i,j) = min(Tra_index_dtw(a,b(end:-1:1),SPdistMat), DTW_Distance(i,j));
        LCSS_Similarity(i,j) = LCS(a,b);
        LCSS_Similarity(i,j) = max(LCS(a,b(end:-1:1)), LCSS_Similarity(i,j));
        EDR_Distance(i,j) = TraEDR(a,b,tol,SPdistMat);
        EDR_Distance(i,j) = min(TraEDR(a,b(end:-1:1),tol,SPdistMat), EDR_Distance(i,j));
        Frechet_Distance(i,j) = DiscreteFrechetDist(a,b, dfcn, SPdistMat);
        Frechet_Distance(i,j) = min(DiscreteFrechetDist(a,b(end:-1:1), dfcn, SPdistMat), Frechet_Distance(i,j));
    end
    
    [~, DTW_index] = sort(DTW_Distance(i,:)); % without 'descend'!
    [~, LCSS_index] = sort(LCSS_Similarity(i,:),'descend'); % with 'descend'!!!!!!!!
    [~, EDR_index] = sort(EDR_Distance(i,:)); % without 'descend'!!!!!!!!
    [~, Frechet_index] = sort(Frechet_Distance(i,:)); % without 'descend'!
    
    DTW_index(DTW_index == i) = [];
    DTW_Similar_Mat(i,:) = DTW_index;
    LCSS_index(LCSS_index == i) = [];
    LCSS_Similar_Mat(i,:) =LCSS_index;
    EDR_index(EDR_index == i) = [];
    EDR_Similar_Mat(i,:) = EDR_index;
    Frechet_index(Frechet_index == i) = [];
    Frechet_Similar_Mat(i,:) = Frechet_index;
end


end