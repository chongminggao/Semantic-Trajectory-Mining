function visualizeIntroduction2(latLong,latLong_new_representation,latLong_using_prototypes_index,param,idx)
%% visualOneTrajectory
idx1 = 5263;
idx2 = 5181;
idx3 = 8186;
idx4 = 8029;

start = [1083 2237 1 826];
endd = [2416 4168 1 1230];


figure;
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
    
    latLong_new_representation(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,latLong_new_representation(:,[3,2]),minn),maxx-minn);
    latLong_new_representation(:,[3,2]) = bsxfun(@times, latLong_new_representation(:,[3,2]), [Xlim(2),Ylim(2)]);
    latLong_new_representation(:,2) = Ylim(2) - latLong_new_representation(:,2);
    
end


[index_of_trajectory, pointer_start1] = unique(latLong(:,1),'stable');
[index_of_trajectory, pointer_start2] = unique(latLong_new_representation(:,1),'stable');


oneTraj1 = latLong(pointer_start1(idx1) : pointer_start1(idx1+1)-1,[2,3]);
oneTraj2 = latLong(pointer_start1(idx2) : pointer_start1(idx2+1)-1,[2,3]);
oneTraj3 = latLong(pointer_start1(idx3) : pointer_start1(idx3+1)-1,[2,3]);
oneTraj4 = latLong(pointer_start1(idx4) : pointer_start1(idx4+1)-1,[2,3]);

oneTraj1 = oneTraj1(start(1):endd(1),:);
oneTraj2 = oneTraj2(start(2):endd(2),:);
oneTraj3 = oneTraj3(start(3):end,:);
oneTraj4 = oneTraj4(start(4):endd(4),:);

h1 = plot(oneTraj1(:,2),oneTraj1(:,1),'LineWidth',8);
h2 = plot(oneTraj2(:,2),oneTraj2(:,1),'LineWidth',8);
h3 = plot(oneTraj3(:,2),oneTraj3(:,1),'LineWidth',8);
h4 = plot(oneTraj4(:,2),oneTraj4(:,1),'LineWidth',8);;


a = lines;
h4.Color = a(5,:);

hold off;

leg = legend('$T_1$','$T_2$','$T_3$','$T_4$');
leg.FontSize = 36;
leg.Interpreter = 'latex';
leg.Orientation = 'horizontal';





