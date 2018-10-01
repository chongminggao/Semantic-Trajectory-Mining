function visualQuary(latLong,param,QuarylatLong)
isRescale = false;
% figure;
hold on;
if isfield(param,'imgMap') 
%     img = imread(param.imgMap);
%     h = imshow(img);
%     set(h,'AlphaData',0.5);
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
%     latLong(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong(:,[3,2]),minn),maxx-minn);
%     latLong(:,[3,2]) = bsxfun(@times, latLong(:,[3,2]), [Xlim(2),Ylim(2)]);
%     latLong(:,2) = Ylim(2) - latLong(:,2);
    QuarylatLong(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,QuarylatLong(:,[2,1]),minn),maxx-minn);
    QuarylatLong(:,[2,1]) = bsxfun(@times, QuarylatLong(:,[2,1]), [Xlim(2),Ylim(2)]);
    QuarylatLong(:,1) = Ylim(2) - QuarylatLong(:,1);
%     if isfield(param,'visualRoundabouts') && isequal(param.visualRoundabouts,true)
%         roundabouts = param.roundabouts;
%         roundabouts(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,roundabouts(:,[2,1]),minn),maxx-minn);
%         roundabouts(:,[2,1]) = bsxfun(@times, roundabouts(:,[2,1]), [Xlim(2),Ylim(2)]);
%         roundabouts(:,1) = Ylim(2) - roundabouts(:,1);
%     end
end


% ===============DMKD===================
pp = patch([0 Xlim(2) Xlim(2) 0],[0 0 Ylim(2) Ylim(2)],[1 1 1]);
pp.FaceAlpha = 0.35;
pp.LineStyle = 'none';
% =================DMKD=================

if isfield(param,'visualQuaryPoints') && isequal(param.visualQuaryPoints,true)
    x = QuarylatLong(:,2);
    y = QuarylatLong(:,1);
    epsilon_meter = param.epsilon_meter;
    
    epsilon_pixel = epsilon_meter/param.Distance_mean * ((Xlim(2) + Ylim(2))/2 -1);
    
    for i = 1:length(x)
%         pos = [x(i) - epsilon_pixel, y(i) - epsilon_pixel, 2 * epsilon_pixel, 2 * epsilon_pixel];
%         h = rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[1.00  0.6 0.60],'LineStyle',':')
        h = filledCircle([x(i),y(i)],epsilon_pixel,1000,'r');
        h.FaceAlpha = 0.9;
        h.FaceColor = [0.6078, 0.6078, 0.6078];
        h.LineWidth = 1.5;
    end
    
%     h = viscircles([x,y],epsilon_pixel,'LineStyle',':');
    scatter(x,y,800,'p','MarkerFaceColor','[0.6078, 0.6078, 0.6078]','MarkerEdgeColor',[0 0 0],'LineWidth',1);
    
end

% 
% numberOfTrajectories = 0;
% numberOfVisualization = 3000;
% if isfield(param,'numberOfVisualization') 
%     numberOfVisualization = param.numberOfVisualization;
% end
% 
% if isfield(param,'visualStyle')
%     if isequal(param.visualStyle,'TrakmeansPlot')
%         idx = param.Tra_idx;
%         colorMap = lines(length(unique(idx)));
%     elseif isequal(param.visualStyle,'kmeansPlot')
%         K = param.K;
%         colorMap = parula(K);
%         idx = param.idx;
%     end
% end
% 
% 
% lineSet = unique(latLong(:,1),'stable');
% if(length(lineSet) > 7)
%     colorMap_raw = parula(length(lineSet));
% else
%     colorMap_raw = lines(length(lineSet));
% end
% 
% for index = 1:length(lineSet)                         %for every element in lineSet
%     if numberOfTrajectories >= numberOfVisualization
%         break;
%     end
%     oneLatLong = latLong(latLong(:,1)==lineSet(index),[2,3]);
%     
%     if isfield(param,'visualStyle')
%         switch param.visualStyle
%             case 'plot'
%                 pp = plot(oneLatLong(:,2),oneLatLong(:,1),'-o');
%                 pp.LineWidth = 1;
% %                 pp.Color = colorMap_raw(index,:);
%                 
%             case 'weightedSP'
%                 weights = param.weight;
%                 nodeSize = (weights+1);
%                 nodeSize = 60 + 400*(nodeSize - min(nodeSize))/(max(nodeSize)-min(nodeSize));
%                 oneLatLong(:,3) = nodeSize;
% %                 oneLatLong = sortrows(oneLatLong,3);    %Attention: After this step, the order are not remained!
%                 for i = 31:size(oneLatLong,1)
%                     scatter(oneLatLong(i,2),oneLatLong(i,1),oneLatLong(i,3),...
%                         'MarkerFaceColor','auto',...
%                         'MarkerEdgeColor',[0 0 0],...%[0 0.4470 0.7410],...
%                         'LineWidth',1.5);
%                 end
%                 
% %                 pp = plot(oneLatLong(:,2),oneLatLong(:,1),'o','LineWidth',3);
% %                 pp.MarkerFaceColor = 'auto';%[0 0.6470 0.5410];
%                 
% %                 pp.MarkerSize = 6;
%                 
%             case 'kmeansPlot'
%                 
%                 weights = param.weight;
%                 nodeSize = (weights+1);
%                 nodeSize = 30 + 1000*(nodeSize - min(nodeSize))/(max(nodeSize)-min(nodeSize));
%                 oneLatLong(:,3) = nodeSize;
% %                 oneLatLong = sortrows(oneLatLong,3);
%                 for i = 1:size(oneLatLong,1)
%                     scatter(oneLatLong(i,2),oneLatLong(i,1),oneLatLong(i,3),...
%                         'MarkerFaceColor',colorMap(idx(i),:),...
%                         'MarkerEdgeColor',[0 0 0],...%[0 0.4470 0.7410],...
%                         'LineWidth',2);
%                     str = strcat('\leftarrow', num2str(i));
%                     text(oneLatLong(i,2),oneLatLong(i,1),str);
%                 end
%                 
%             case 'TrakmeansPlot'
%                 
%                 pp = plot(oneLatLong(:,2),oneLatLong(:,1),'-o',...
%                     'Color', colorMap(idx(index),:),...
%                     'LineWidth',2);
%                 
%             otherwise 
%                 pp = scatter(oneLatLong(:,2),oneLatLong(:,1),20,'LineWidth',2);
%             
%         end
%     else
%         pp = scatter(oneLatLong(:,2),oneLatLong(:,1),2);
%     end
%     
%     numberOfTrajectories = numberOfTrajectories + 1;
% end
% 
% 
% 
% % hold off;
% fprintf('visualization number of trajectories: %d .\n',numberOfTrajectories);

end




