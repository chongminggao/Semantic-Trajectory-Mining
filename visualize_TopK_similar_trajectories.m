function visualize_TopK_similar_trajectories(latLong,param,idx,k,TopK_index,index_of_trajectory)


isRescale = false;
figure;
if isfield(param,'img') 
    img = imread(param.img);
    h = imshow(img);
    set(h,'AlphaData',0.5);
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



latLong_new = latLong(index_of_trajectory(idx) == latLong(:,1),:);
for i = 1:k
    latLong_new = [latLong_new; latLong(index_of_trajectory(TopK_index(i)) == latLong(:,1),:)];
end


latLong = latLong_new;

if isRescale    % Scale latLong to the map background image space. 
    minn = param.axisRange([1,3]);
    maxx = param.axisRange([2,4]);
    latLong(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong(:,[3,2]),minn),maxx-minn);
    latLong(:,[3,2]) = bsxfun(@times, latLong(:,[3,2]), [Xlim(2),Ylim(2)]);
    latLong(:,2) = Ylim(2) - latLong(:,2);
end



lineSet = unique(latLong(:,1),'stable');
if(length(lineSet) > 7)
    num = length(lineSet);
    colorMap_raw = summer(round(num * 2));
    colorMap_raw(1:round(num * 0.4),:) = [];
else
    color = lines(7);
    color([1,3],:) = color([3,1],:);
    colorMap_raw = color(1:length(lineSet),:);
    
end


for index = length(lineSet):-1:1
    
    oneLatLong = latLong(latLong(:,1)==lineSet(index),[2,3]);
    
    pp = plot(oneLatLong(:,2),oneLatLong(:,1),'-o');
    pp.LineWidth = 1;
    pp.Color = colorMap_raw(index,:);
    
    if index == 1
        pp.Color = [0 0 0];%[  0    0.4470    0.7410];
        pp.LineWidth = 2;
%         pp.MarkerSize = 10;
    end
    
end

% str = 'legend(''';
% str = strcat(str,num2str(idx),'''');
% for i = 1:k
%     str = strcat(str,sprintf(',''%d\''',TopK_index(i)));
% end
% str = strcat(str,')');
% eval(str);


% axis([ 100 1351   140        1201]);
% h = gcf;
% h.Position = [483 179 625 530];

end
