function visualEverySinglePoint(latLong, param, FastSyncResult, SPidx)
isRescale = false;
figure;
if isfield(param,'imgMap') 
    img = imread(param.imgMap);
    h = imshow(img);
    set(h,'AlphaData',0.3);
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


Color = lines(7);
Color(2:4,:) = Color([5:6,2],:);


labels = SPidx(FastSyncResult.Map_Original_To_Prototype);

tab = tabulate(SPidx);
for i = size(tab,1):-1:1
    cluster = latLong(labels == tab(i,1),:);
    pp = plot(cluster(:,3),cluster(:,2),'.',...
              'Color', [Color(i,:), .8]);
    pp.MarkerSize = 5;
end



% for i = 1:size(latLong,1)
%     cluster = SPidx(FastSyncResult.Map_Original_To_Prototype(i));
%     pp = plot(latLong(i,3),latLong(i,2),'.',...
%               'Color', [Color(cluster,:), .8]);
%     pp.MarkerSize = 5;
% end
hold off;


end