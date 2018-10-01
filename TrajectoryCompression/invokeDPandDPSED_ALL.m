function  [ratio, ratio_DPSED, cumError_DP, cumError_SED_DP, cumError_DPSED, cumError_SED_DPSED] = invokeDPandDPSED_ALL(latlong_meter, visitingTime, ErrorBound)

[index_of_trajectory, pointer] = unique(latlong_meter(:,1),'stable');
pointer = [pointer(:); size(latlong_meter,1) + 1];

num = size(latlong_meter,1);

DPLen = 0;
DPLen_DPSED = 0;

cumError_DP = 0;
cumError_SED_DP = 0;
cumError_DPSED = 0;
cumError_SED_DPSED = 0;

for i = 1:length(index_of_trajectory)
    latLong_one = latlong_meter(pointer(i):pointer(i+1)-1,2:3);
    visitingTime_one = visitingTime(pointer(i):pointer(i+1)-1);
    [result, Index, result_SED, Index_DPSED] = Invoke_DouglasPeucker(latLong_one, visitingTime_one, ErrorBound);
    
    [cumError_DP_one, cumError_SED_DP_one] = CalculateOneTrajError(latLong_one, visitingTime_one, Index);
    [cumError_DPSED_one, cumError_SED_DPSED_one] = CalculateOneTrajError(latLong_one, visitingTime_one, Index_DPSED);
    cumError_DP = cumError_DP + cumError_DP_one;
    cumError_SED_DP = cumError_SED_DP + cumError_SED_DP_one;
    cumError_DPSED = cumError_DPSED + cumError_DPSED_one;
    cumError_SED_DPSED = cumError_SED_DPSED + cumError_SED_DPSED_one;
    
    DPLen = DPLen +  length(Index);
    DPLen_DPSED = DPLen_DPSED + length(Index_DPSED);
end

ratio = 1 - DPLen/num;
ratio_DPSED = 1 - DPLen_DPSED/num;
cumError_DP = cumError_DP/num;
cumError_SED_DP = cumError_SED_DP/num;
cumError_DPSED = cumError_DPSED/num;
cumError_SED_DPSED = cumError_SED_DPSED/num;

end


