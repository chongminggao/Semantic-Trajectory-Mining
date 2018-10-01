function  [ratio, cumError_DR, cumError_SED_DR] = invokeDR_ALL(latlong_meter, visitingTime, ErrorBound)

[index_of_trajectory, pointer] = unique(latlong_meter(:,1),'stable');
pointer = [pointer(:); size(latlong_meter,1) + 1];


num = size(latlong_meter,1);
DRLen = 0;
cumError_DR = 0;
cumError_SED_DR = 0;


for i = 1:length(index_of_trajectory)
    latLong_one = latlong_meter(pointer(i):pointer(i+1)-1,2:3);
    visitingTime_one = visitingTime(pointer(i):pointer(i+1)-1);
    
    
%     [result, Index_com, result_SED, Index_com_SED] = Invoke_DouglasPeucker(latLong_one, visitingTime_one, ErrorBound);
    [latLong_new, Index] = DeadReckoning(latLong_one, visitingTime_one, ErrorBound);
    
    [cumError_DR_one, cumError_SED_DR_one] = CalculateOneTrajError(latLong_one, visitingTime_one, Index);
    cumError_DR = cumError_DR + cumError_DR_one;
    cumError_SED_DR = cumError_SED_DR + cumError_SED_DR_one;
    DRLen = DRLen +  length(Index);
end

ratio = 1 - DRLen/num;
cumError_DR = cumError_DR/num;
cumError_SED_DR = cumError_SED_DR/num;

end


