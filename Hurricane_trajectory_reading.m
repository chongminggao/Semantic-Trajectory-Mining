function [latLong,numberOfEffectiveRecord,visitingTime] =  Hurricane_trajectory_reading(param)

fileName =  param.inputFile;
latLong = [];
visitingTime = [];
numberOfEffectiveRecord = 0;
fileID = fopen(fileName);
exitflag = false;


count = 1;
while true
    line = textscan(fileID,'%*s %*s %d',1,'Delimiter',',');
    line = line{1};
    if isempty(line) 
        break;
    end
    
    
    if param.readingNumOfTraj <= numberOfEffectiveRecord + line
        endread = param.readingNumOfTraj - numberOfEffectiveRecord;
        line = endread;
        exitflag = true;
    end
    
    C = textscan(fileID,'%s %s %*s %*s %s %s %*[^\n]',line,'Delimiter',',');
    yyMMdd = C{1};
    HHmm = C{2};
    latcell = C{3};
    longcell = C{4}; 
    time = cellfun(@(x,y) textscan(strjoin({x,y},''),'%{yyyyMMddHHmm}D'),yyMMdd,HHmm);
    visitingTime = [visitingTime;time];
    for i = 1: length(yyMMdd)
        lat = latcell{i};
        long = longcell{i};
        NS = lat(end);
        WE = long(end);
        lat = str2double(lat(1:end-1));
        long = str2double(long(1:end-1));
        
        if NS == 'S'
            lat = -lat;
        end
        if WE == 'W'
            long = -long;
        end
        latLong = [latLong;count,lat,long];
        disp('');
    end
    
    

    numberOfEffectiveRecord = numberOfEffectiveRecord + 1;
    count = count + 1;

    if exitflag
        break;
    end
    
end
fclose(fileID);

