function [latLong,numberOfEffectiveRecord,visitingTime] =  GeoLife_trajectory_reading(param)

    maindir = param.inputFile;

    if length(dir(maindir)) == 0
        error('Error, Please check your file path!');
    end

    maxline = param.readingNumOfTraj;


    [latLong,numberOfEffectiveRecord,~,visitingTime] = Dfs_dictory(maindir,0,maxline);

end

function [latLong,numberOfTrajectory,flag,visitingTime] = Dfs_dictory(maindir,tline,maxline)
    latLong = [];
    visitingTime = {};
    numberOfTrajectory = 0;
    subdir  = dir(maindir);
    flag = false;
    
    for i = 1 : length(subdir)
        if  isequal(subdir( i ).name,'.')|| isequal(subdir(i).name,'..')              % if file is a directory then pass
            continue;
        end
        
        fileName = fullfile(maindir, subdir(i).name);
        fprintf('Load path/file = %s\n',fileName);

        
        if subdir(i).isdir
            [latLong1,numberOfTrajectory1,flag] = Dfs_dictory(fileName,max(tline,numberOfTrajectory),maxline);
            latLong = [latLong;latLong1];
            numberOfTrajectory = numberOfTrajectory + numberOfTrajectory1;
            if flag
                return;
            end
            continue;
        end
        
        %% for a single file
        if ~isequal(fileName(end-3:end), '.plt') 
            if ~isequal(fileName(end-3:end), '.txt') 
                continue;
            end
        end
        
        
        fileID = fopen(fileName);
        textscan(fileID,'%s',6,'Delimiter','\n');
%         C = textscan(fileID,'%f %f %*s %*s %*f %{yyyy-MM-dd}D %{hh:mm:ss}D','Delimiter',',');
        C = textscan(fileID,'%f %f %*s %*s %*f %[^\n]','Delimiter',',');
        fclose(fileID);
        
%         latLong = [latLong;str2num(subdir(i).name(1:end-4)) * ones(length(C{1}),1),C{1},C{2}];
        latLong = [latLong;tline * ones(length(C{1}),1),C{1},C{2}];
        strtime = C{3};
        
        time = cellfun(@(x) textscan(x,'%{yyyy-MM-dd,HH:mm:ss}D','Delimiter',';'),strtime);
        visitingTime = [visitingTime; time];
        numberOfTrajectory = numberOfTrajectory + 1;
        
        if(tline >= maxline-1)
            flag = true;
            return;
        end
        
        tline = tline + 1;
    end
end