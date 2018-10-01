function  [ratio, aveError, aveError_SED] = invoke_Algorithm(Fun, latlong_meter, visitingTime, ErrorBound)
    [index_of_trajectory, pointer] = unique(latlong_meter(:,1),'stable');
    pointer = [pointer(:); size(latlong_meter,1) + 1];

    num = size(latlong_meter,1);
    Len = 0;
    cumError = 0;
    cumError_SED = 0;

    TotalTraj = length(index_of_trajectory);
    for i = 1:TotalTraj
        latLong_one = latlong_meter(pointer(i):pointer(i+1)-1,2:3);
        visitingTime_one = visitingTime(pointer(i):pointer(i+1)-1);

    %     [result, Index_com, result_SED, Index_com_SED] = Invoke_DouglasPeucker(latLong_one, visitingTime_one, ErrorBound);
        
        if mod(i, floor(TotalTraj/5)) == 0
            fprintf('====ErrorBound[%f]:  Algorithm[%s]: Trajectory[%d/%d]...=====\n',ErrorBound, func2str(Fun), i, TotalTraj);
        end
        
        [latLong_new, Index] = Fun(latLong_one, visitingTime_one, ErrorBound);

        [cumError_one, cumError_SED_one] = CalculateOneTrajError(latLong_one, visitingTime_one, Index);
        cumError = cumError + cumError_one;
        cumError_SED = cumError_SED + cumError_SED_one;
        Len = Len +  length(Index);

    end

    ratio = 1 - Len/num;
    aveError = cumError/num;
    aveError_SED = cumError_SED/num;

end




