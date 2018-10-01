function [latLong,numberOfEffectiveRecord,visitingTime] =  Chengdu_trajectory_reading(param)

fileName = param.inputFile;
fileID = fopen(fileName);
C = textscan(fileID,'%s %{yyyy/MM/dd hh:mm:ss}D %f %f %*d',10000000,'delimiter', ',');
fclose(fileID);
plate =C{1};
time = C{2};
long = C{3};
lat = C{4};
[~,pointer] = unique(plate,'stable');
pointer = [pointer;length(plate) + 1];
index = zeros(length(plate),1);
for i = 1:length(pointer) - 1
    index(pointer(i) : pointer(i+1)-1) = i;
end
latLong = [index,lat,long];
% time = cellfun(@datetime,strtime,'UniformOutput',false);
visitingTime = time;
numberOfEffectiveRecord = length(pointer) - 1;

