function Total = performanceDP(latlong,ErrorBound)

[index_of_trajectory, pointer] = unique(latlong(:,1),'stable');
pointer = [pointer(:); size(latlong,1) + 1];


Total = 0;
for i = 1:length(index_of_trajectory)
    latLong_one = latlong(pointer(i):pointer(i+1)-1,2:3);
    res = DouglasPeucker(latLong_one',ErrorBound)';
    nowlen = size(res,1);
    Total = Total + nowlen;
end

end
