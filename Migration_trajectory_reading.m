function [latLong,numberOfEffectiveRecord,visitingTime] =  Migration_trajectory_reading(param)

fileName =  param.inputFile;

fileID = fopen(fileName);

% d = textscan(fileID,'%[^\n]',1,'Delimiter','\n');
C = textscan(fileID,'%*s %*s %{yyyy-MM-dd HH:mm:ss.000}D %f %f %*[^\n]','Delimiter',',','HeaderLines',1);
fclose(fileID);

visitingTime = C{1};
% durations = [0;days(diff(time))];
longs = C{2}; 
lats = C{3};

numberOfEffectiveRecord = length(longs);
latLong = [ones(length(longs),1),lats,longs];