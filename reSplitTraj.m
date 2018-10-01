function latLong = reSplitTraj(latLong,visitingTime)

sec  = seconds(diff(visitingTime));

index = find(sec < 0);
for i = 1:length(index)
    latLong(index(i) + 1 : end, 1) = latLong(index(i) + 1 : end, 1) + 1;
end

end