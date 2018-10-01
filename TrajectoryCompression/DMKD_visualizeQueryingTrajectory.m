function f = DMKD_visualizeQueryingTrajectory(latLong,param,TrajInd)

f = figure;
if isfield(param,'img') 
    img = imread(param.img);
    hi = imshow(img);
    set(hi,'AlphaData',0.8);
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
%     
%     latLong_new_representation(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong_new_representation(:,[3,2]),minn),maxx-minn);
%     latLong_new_representation(:,[3,2]) = bsxfun(@times, latLong_new_representation(:,[3,2]), [Xlim(2),Ylim(2)]);
%     latLong_new_representation(:,2) = Ylim(2) - latLong_new_representation(:,2);
%     
end


[index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');

numberOfTrajectories = length(index_of_trajectory);
pointer_start = [pointer_start; size(latLong,1)+1];

hold on

for i = 1:length(TrajInd)
    
%         oneTraj1_ori = latLong(pointer_start(i) : pointer_start(i+1)-1,[2,3]);
    oneTraj1_ori = latLong(latLong(:,1) == TrajInd(i),2:3);
    
    if isRescale
        clear oneTraj1;
        oneTraj1(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori(:,[2,1]),minn),maxx-minn);
        oneTraj1(:,[2,1]) = bsxfun(@times, oneTraj1(:,[2,1]), [Xlim(2),Ylim(2)]);
        oneTraj1(:,1) = Ylim(2) - oneTraj1(:,1); 
    end
    h1 = plot(oneTraj1(:,2),oneTraj1(:,1),'o-','LineWidth',1.5);
%     h1.MarkerSize = 15;
end

hold off;
