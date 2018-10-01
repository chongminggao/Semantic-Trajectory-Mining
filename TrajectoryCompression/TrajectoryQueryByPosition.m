layer = 4;
param = param_multi_offline{layer};
FastSyncResult = param_multi_offline{layer};


figure;
if isfield(param,'img') 
    img = imread(param.img);
    hi = imshow(img);
    set(hi,'AlphaData',0.7);
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

%%
ginput(1)


%%
Xlim = xlim; Ylim = ylim;
hold on;
pp = patch([0 Xlim(2) Xlim(2) 0],[0 0 Ylim(2) Ylim(2)],[1 1 1]);
pp.FaceAlpha = 0.65;
pp.LineStyle = 'none';


%%

keyIndex = [81,92];
keypoints = FastSyncResult.X(keyIndex,:);

param.visualQuaryPoints = true;
visualQuary(latLong,param,keypoints);

% scatter(keypoints(:,2),keypoints(:,1),100,'o','MarkerFaceColor','[0.4660    0.6740    0.1880]','MarkerEdgeColor',[0 0 0],'LineWidth',2);


%%


keyIndex = [259,162];
keyIndex = [243,229,150]; 
keyIndex = [138,161];
keyIndex = [109,195,171];
keyIndex = [81,92];
param.X = FastSyncResult.X;
visualizeQueryingTrajectory(latLong,latLong_new_representation,latLong_using_prototypes_index,param,1,keyIndex);

% 
% % %% 
% a = gca;
% set(a,'Xlim',[250   750]);
% set(a,'Ylim',[100   600]);
% f = gcf;
% f.OuterPosition = f.InnerPosition;
% % a.Ylim = [100   700];