function visualizeQueryingTrajectory(latLong,latLong_new_representation,latLong_using_prototypes_index,param,idx,passedIdx)
%% visualOneTrajectory

figure;
if isfield(param,'img') 
    img = imread(param.img);
    hi = imshow(img);
    set(hi,'AlphaData',0.3);
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


[index_of_trajectory, pointer_start1] = unique(latLong(:,1),'stable');
[index_of_trajectory, pointer_start2] = unique(latLong_new_representation(:,1),'stable');

numberOfTrajectories = length(index_of_trajectory);

% h1 = plot([1],[1]);
% h2 = plot([2],[2]);

hold on

count = 1;
for i = idx:numberOfTrajectories
    if i ~= numberOfTrajectories
        oneTraj1_ori = latLong(pointer_start1(i) : pointer_start1(i+1)-1,[2,3]);
        oneTraj2_ori = latLong_new_representation(pointer_start2(i) : pointer_start2(i+1)-1,2:3);
        SPsequence = latLong_using_prototypes_index(pointer_start2(i) : pointer_start2(i+1)-1,2);
    else
        oneTraj1_ori = latLong(pointer_start1(i) : end,2:3);
        oneTraj2_ori = latLong_new_representation(pointer_start2(i) : end,2:3);
        SPsequence = latLong_using_prototypes_index(pointer_start2(i) : end,2);
    end
    
    if isRescale
        clear oneTraj1 oneTraj2;
        oneTraj1(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj1_ori(:,[2,1]),minn),maxx-minn);
        oneTraj1(:,[2,1]) = bsxfun(@times, oneTraj1(:,[2,1]), [Xlim(2),Ylim(2)]);
        oneTraj1(:,1) = Ylim(2) - oneTraj1(:,1);
        oneTraj2(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,oneTraj2_ori(:,[2,1]),minn),maxx-minn);
        oneTraj2(:,[2,1]) = bsxfun(@times, oneTraj2(:,[2,1]), [Xlim(2),Ylim(2)]);
        oneTraj2(:,1) = Ylim(2) - oneTraj2(:,1);  
    end

    
%     if sum(latLong(pointer_start1(i),1) == latLong(:,1)) ~= pointer_start1(i+1) - pointer_start1(i)
%        fprintf('============Warning!!!!===============Warning!!!!============\n');
%     end
    
    flag = false;


    if isempty(passedIdx)
        flag = true;
    else
        if ismember(passedIdx,SPsequence)
            flag = true;
        else
            continue;
        end
    end
%     
%     %+++++++++++++++++++++++++++++
%     removeSet = [];
%     removeSet = [2519,9342,4081];
%     if ismember(i,removeSet)
%         continue;
%     end
%     %+++++++++++++++++++++++++++++
    
    
    
%     delete(h1);
%     delete(h2);
%     h1 = plot(oneTraj1(:,2),oneTraj1(:,1),'LineWidth',2.5);
%     h2 = plot(oneTraj2(:,2),oneTraj2(:,1),'LineWidth',2,'Color','r');
    
%     h1.Marker='o';
%     h1.MarkerSize = 4;
%     h2.MarkerSize = 15;
%     h2.Marker='pentagram';
    
%     leg = sprintf('#[%d]: [%d]\n',i,index_of_trajectory(i));
%     legend(leg);
    
    fprintf('#[%d]:index: [%d]\n',i,index_of_trajectory(i));
    
%% two kinds of pause;
%     pause;

    if flag
        a = 1;
        count = count + 1;
%         pause;
    end
    
    
end
% hold off;
fprintf('#######[%d]\n',count);
% 
% QuarylatLong  = param.X(passedIdx,:);
% 
% if isRescale    % Scale latLong to the map background image space. 
%     minn = param.axisRange([1,3]);
%     maxx = param.axisRange([2,4]);
% %     latLong(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong(:,[3,2]),minn),maxx-minn);
% %     latLong(:,[3,2]) = bsxfun(@times, latLong(:,[3,2]), [Xlim(2),Ylim(2)]);
% %     latLong(:,2) = Ylim(2) - latLong(:,2);
%     QuarylatLong(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,QuarylatLong(:,[2,1]),minn),maxx-minn);
%     QuarylatLong(:,[2,1]) = bsxfun(@times, QuarylatLong(:,[2,1]), [Xlim(2),Ylim(2)]);
%     QuarylatLong(:,1) = Ylim(2) - QuarylatLong(:,1);
% %     if isfield(param,'visualRoundabouts') && isequal(param.visualRoundabouts,true)
% %         roundabouts = param.roundabouts;
% %         roundabouts(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,roundabouts(:,[2,1]),minn),maxx-minn);
% %         roundabouts(:,[2,1]) = bsxfun(@times, roundabouts(:,[2,1]), [Xlim(2),Ylim(2)]);
% %         roundabouts(:,1) = Ylim(2) - roundabouts(:,1);
% %     end
% end
% 
% 
% if isfield(param,'visualQuaryPoints') && isequal(param.visualQuaryPoints,true)
%     scatter(QuarylatLong(:,2),QuarylatLong(:,1),1000,'p','MarkerFaceColor','[0.5873    0.7937    0.4000]','MarkerEdgeColor',[0 0 0],'LineWidth',3);
% end
% 
% 


