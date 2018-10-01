function [latLong,numberOfEffectiveRecords,visitingTime] = Foursquare_trajectory_reading(param)

visitingTime = {};
file = fopen(param.inputFile);
a = textscan(file,'%f %[^{] {%[^}]} {%[^,],%[^,],%[^}]} {%[^}]}',param.readingNumOfTraj,'HeaderLines',1);
fclose(file);
% userid = textscan(file, '%d');
% geoinfo = textscan(file,1)


lat = cell2mat(cellfun(@(t) str2double(t), a{1,4}, 'UniformOutput',false));
long = cell2mat(cellfun(@(t) str2double(t), a{1,5}, 'UniformOutput',false));
latLong = [a{1},lat,long];
numberOfEffectiveRecords = length(lat);
category = cellfun(@(t) t{1} ,cellfun(@(t) textscan(t,'%[^,]','Delimiter',','), a{1,7}, 'UniformOutput',false),'UniformOutput',false);

% 
% categoryMap = containers.Map();
% 
% for i = 1:length(category)
%     for j = 1:length(category{i})
%         if categoryMap.isKey(category{i}{j})
%             
%         end
%     end
% end


end