function [latLong,numberOfEffectiveRecord,visitingTime] = kaggle_trajectory_reading(param)
% ====================================================
% Read file from kaggle trajectory dataset,
% the data format description can be found at:  
% https://www.kaggle.com/c/pkdd-15-predict-taxi-service-trajectory-i/data
% ====================================================


%% Reading file from raw file
numberOfEffectiveRecord = 0;
fileName = param.inputFile;
% 
% fidin=fopen(fileName,'r');
% % disp('Please check the file name and file path:[param.inputFile]');
% nline=1;										% line number corresponding to raw file.
% while ~feof(fidin) && nline<=param.readingNumOfTraj 	% contral the number of lines.
%     tline=fgetl(fidin); 						% read one line.
%     if nline > 0
%         tline=strjoin({'[',tline,']'});
%         oneTrajectory = jsondecode(tline);
%         try
%             oneLatLong = jsondecode(oneTrajectory{9});
%         catch
%             continue;
%         end
%         if(size(oneLatLong,1)<=0)
%         	numberOfMissingRecord = numberOfMissingRecord+1;
%             fprintf('missing data: %d\n', nline);
%             continue;
%         end
%         latLong = [latLong;[ones(size(oneLatLong,1),1)*nline,oneLatLong]];
%     end
%     nline=nline+1;
% end
% fclose(fidin);
% latLong(:,[2,3]) = latLong(:,[3,2]);
% numberOfEffectiveRecord = param.readingNumOfTraj - numberOfMissingRecord;

% Now the trajectories are saved as GPS sequence


fileID = fopen(fileName);
textscan(fileID,'%s',1,'Delimiter','\n');
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s "%[^\n]', param.readingNumOfTraj ,'Delimiter',',');
fclose(fileID);

line = 0;
latLong = zeros(50000000,3);
index = 1;
for i = 1:length(C{1})
    str = C{1}{i};
    str(end) = [];
    line = line + 1;
    try
        oneLatLong = jsondecode(str);
    catch
        continue;
    end
    if length(oneLatLong) <= 0
        continue;
    end
    numberOfEffectiveRecord = numberOfEffectiveRecord +1;
    downindex = index+size(oneLatLong,1)-1;
    if downindex > size(latLong,1)
        latLong = [latLong;zeros(50000000,3)];
    end
    latLong(index:downindex, :) = [line * ones(size(oneLatLong,1),1),oneLatLong(:,2),oneLatLong(:,1)];
    index = downindex + 1;
end
latLong(index:end,:) = [];