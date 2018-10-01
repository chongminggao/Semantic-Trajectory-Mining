function visualTrajectoryEmbedding(latLong,param,numPercluster)
K2 = length(unique(param.Tra_idx));

Color = 'parula';
if K2 <= 7
    colorMapTra = lines(7);
    colorMapTra([1,2],:) = colorMapTra([2,1],:);
    colorMapTra([3,5],:) = colorMapTra([5,3],:);
%     colorMapTra([4,6],:) = colorMapTra([6,4],:);
end
% colorMapTra = eval(strcat(Color, '(K2)'));

Tra_idx = param.Tra_idx;

h = figure;
if isfield(param,'imgMap') 
    img = imread(param.imgMap);
    hi = imshow(img);
    set(hi,'AlphaData',0.5);
    Xlim = xlim;
    Ylim = ylim;
    Xlim = [0,Xlim(2)+0.5];
    Ylim = [0,Ylim(2)+0.5];
    isRescale = true;
    axis([Xlim,Ylim]);
    
    if ~isfield(param,'axisRange')
        error('Please specify the axisRange');
    end
    
end
hold on;

if isRescale    % Scale latLong to the map background image space. 
    minn = param.axisRange([1,3]);
    maxx = param.axisRange([2,4]);

    
    latLong(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong(:,[3,2]),minn),maxx-minn);
    latLong(:,[3,2]) = bsxfun(@times, latLong(:,[3,2]), [Xlim(2),Ylim(2)]);
    latLong(:,2) = Ylim(2) - latLong(:,2);
end

% if ~isempty(decisionmap)
%     hi = imagesc(Xlim,Ylim,decisionmap);
%     hi.AlphaData = 0.3;
%     colormap(colorMapSP);
% end

numberOfTrajectories = 0;
numberOfVisualization = 3000;
if isfield(param,'numberOfVisualization') 
    numberOfVisualization = param.numberOfVisualization;
end


%% sort and make the cluster with large number of traj. plot first.
lineSet = unique(latLong(:,1),'stable');
tab = tabulate(Tra_idx);


lineSet = [lineSet, Tra_idx, zeros(size(lineSet,1) ,1)];

for i = 1 : size(tab,1)
    lineSet(tab(i,1) == lineSet(:,2),3) = tab(i,2);
end
lineSet = sortrows(lineSet,-3);


[~,ind] = unique(lineSet(:,2),'stable');
for i = 1:length(ind)
    lineSet(ind(i):end,2) = i;
end

%% 
ind(length(ind) + 1) = length(lineSet) + 1;
reduce_set = [];
for i = 1:length(ind)-1
    reduce_set = [reduce_set,(ind(i) + numPercluster) : ind(i+1) - 1];
end
lineSet(reduce_set,:) = [];


%% resort the showing time manually
%++++++===============================================
showtime = [4 2 3 1];
%++++++===============================================

[~,ind] = unique(lineSet(:,2),'stable');
for i = 1:length(ind)
    lineSet(ind(i):end,2) = showtime(i);
end
lineSet = sortrows(lineSet,2);
[~,ind] = unique(lineSet(:,2),'stable');
for i = 1:length(ind)
    lineSet(ind(i):end,2) = i;
end

percentage = sort(tab(:,3),'descend');
percentage(showtime) = percentage;

%%

tabulate(lineSet(:,2))

pauseflag = false;
for index = 1:length(lineSet)                            %for every element in lineSet
    if numberOfTrajectories >= numberOfVisualization
        break;
    end
    oneLatLong = latLong(latLong(:,1)==lineSet(index),[2,3]);
    
    if index ~= 1 && lineSet(index,2) ~= lineSet(index-1,2)
        pauseflag = true;
    end
    pauseflag = false;
    pp = plot(oneLatLong(:,2),oneLatLong(:,1),'o-',...
              'Color', [colorMapTra(lineSet(index,2),:), .3]);
          
    pp.MarkerSize = 1;
    pp.LineWidth = 1;

    numberOfTrajectories = numberOfTrajectories + 1;
end
hold off;

axis([ 100 1351   140        1201]);
h = gcf;
h.Position = [483 179 625 530];

end