function [result, Index] = Wrapper_DPSED(latLong, visitingTime, epsilon)

len = size(latLong,1);
Index = 1:len;
Index = Index(:);
[result, Index] = DouglasPeucker_SED(latLong', visitingTime, Index, epsilon);

result = result';

end