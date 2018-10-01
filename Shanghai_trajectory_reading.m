function [latLong,numberOfEffectiveRecord,visitingTime] =  Shanghai_trajectory_reading(param)
latLong=[];
visitingTime = {};
numberOfEffectiveRecord = 0;


maindir = param.inputFile;
subdir  = dir(maindir);

if length( subdir ) == 0
    error('Error, Please check your file path!');
    return;
end

tline = 1;
for i = 1 : length( subdir )
    if( length(subdir(i).name) <= 4 || ~isequal( subdir(i).name(1:5), 'Taxi_' ))               % if file is a directory then pass
        continue;
    end
    fileName = fullfile(maindir, subdir(i).name);
    
    fileID = fopen(fileName);
    C = textscan(fileID,'%d %D %f %f %*d %*d %*d','delimiter', ',');
    fclose(fileID);
    
    index = C{1};
    time = C{2};
    long = C{3};
    lat = C{4};
    
    
    if length(index) < 1
        continue;
    end
    
%     time = cellfun(@datetime,strtime,'UniformOutput',false);
    visitingTime = [visitingTime; time];
    latLong = [latLong;[index,lat,long]];
    if(tline >= param.readingNumOfTraj)
        break;
    end
    tline = tline + 1;
end
if tline == 1
    error('Error, No trajectory has been loaded. Please check your file path!');
end

numberOfEffectiveRecord = min(param.readingNumOfTraj,length(subdir));