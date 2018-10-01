function [result, Index_com, result_SED, Index_com_SED] = Invoke_DouglasPeucker(latLong, visitingTime,epsilon)
    len = size(latLong,1);
    Index = 1:len;
    Index = Index(:);
    [result, Index_com] = DouglasPeucker(latLong', Index, epsilon);
    [result_SED, Index_com_SED] = DouglasPeucker_SED(latLong', visitingTime, Index, epsilon);
    result = result';
    result_SED = result_SED';
end