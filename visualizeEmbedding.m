function decisionmap = visualizeEmbedding(X, SP_pairs, param)

K1 = length(unique(param.idx));
% K2 = length(unique(param.Tra_idx));

Color = 'parula';
colorMapSP = eval(strcat(Color, '(K1)'));
% colorMapTra = eval(strcat(Color, '(K2)'));
idx = param.idx;
% Tra_idx = param.Tra_idx; 
% 
% isRescale = false;
h = figure;
if isfield(param,'imgMap') 
    img = imread(param.imgMap);
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
hold on;
% 
if isRescale    % Scale latLong to the map background image space. 
    minn = param.axisRange([1,3]);
    maxx = param.axisRange([2,4]);
    X(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,X(:,[2,1]),minn),maxx-minn);
    X(:,[2,1]) = bsxfun(@times, X(:,[2,1]), [Xlim(2),Ylim(2)]);
    X(:,1) = Ylim(2) - X(:,1);
end
%%
decisionmap = [];
% 
% net = patternnet([30,30,30,30,30]);
% net.divideParam.trainRatio = 1;
% net.divideParam.valRatio = 0;
% net.divideParam.testRatio = 0;
% 
% num = size(X,1);
% labels = zeros(num,K1);
% for i = 1:num
%     labels(i,idx(i)) = 1;
% end
% 
% 
% 
% net = train(net,X(:,[2,1])',labels');
% 
% Vresol = 1000;
% [Vx,Vy]  = meshgrid(linspace(Xlim(1),Xlim(end),Vresol),linspace(Ylim(1),Ylim(end),Vresol));
% 
% wholePlanelabels = net([Vx(:),Vy(:)]');
% 
% wholePlanelabels = vec2ind(wholePlanelabels);
% image_size = size(Vx);
% decisionmap = reshape(wholePlanelabels, image_size);
% hold on;
% hi = imagesc(Xlim,Ylim,decisionmap);
% hi.AlphaData = 0.2;
% colormap(colorMapSP);

%%
% set(0, 'currentfigure', h); 

tab = tabulate(param.idx);
tab = sortrows(tab,2);
idx = [param.idx,zeros(size(param.idx,1),1)];
for i = 1:size(tab,1)
    idx(tab(i,1) == idx(:,1),2) = i;
end
param.idx = idx(:,2);

tabulate(param.idx)

param.isNodeColor = 1;
param.visualArrow = true;

heatMapVisualization(SP_pairs,param,isRescale);
hold off;










