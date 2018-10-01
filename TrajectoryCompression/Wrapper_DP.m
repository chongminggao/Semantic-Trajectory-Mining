function [result, Index] = Wrapper_DP(latLong, visitingTime, epsilon)

len = size(latLong,1);
Index = 1:len;
Index = Index(:);
[result, Index] = DouglasPeucker(latLong', Index, epsilon);

result = result';

end