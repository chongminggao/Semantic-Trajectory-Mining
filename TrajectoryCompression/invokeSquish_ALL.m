function  [ratio, cumError_Squish, cumError_SED_Squish] = invokeSquish_ALL(latlong_meter, visitingTime, ErrorBound)

[index_of_trajectory, pointer] = unique(latlong_meter(:,1),'stable');
pointer = [pointer(:); size(latlong_meter,1) + 1];


num = size(latlong_meter,1);
LenSquish = 0;
cumError_Squish = 0;
cumError_SED_Squish = 0;

for i = 1:length(index_of_trajectory)
    latLong_one = latlong_meter(pointer(i):pointer(i+1)-1,2:3);
    visitingTime_one = visitingTime(pointer(i):pointer(i+1)-1);
    
    
%     [result, Index_com, result_SED, Index_com_SED] = Invoke_DouglasPeucker(latLong_one, visitingTime_one, ErrorBound);
    [latLong_new, Index] = Squish(latLong_one, visitingTime_one, ErrorBound);
    
    [cumError_Squish_one, cumError_SED_Squish_one] = CalculateOneTrajError(latLong_one, visitingTime_one, Index);
    cumError_Squish = cumError_Squish + cumError_Squish_one;
    cumError_SED_Squish = cumError_SED_Squish + cumError_SED_Squish_one;
    LenSquish = LenSquish +  length(Index);
end

ratio = 1 - LenSquish/num;
cumError_Squish = cumError_Squish/num;
cumError_SED_Squish = cumError_SED_Squish/num;

end


