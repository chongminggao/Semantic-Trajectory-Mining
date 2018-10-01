function [AveError,ErrorDist] = DMDK_calculate_error(latLong_base, result)

    k = 5;
    
    ROI = result{k}.X;
    CompressedPoints = ROI(result{k}.Map_Original_To_Prototype,:);
    
    len = size(CompressedPoints,1);
    rawPoints = latLong_base(1:len,2:3);
    
    ErrorDist = max(abs(CompressedPoints-rawPoints)')';    
    AveError = mean(ErrorDist);

end