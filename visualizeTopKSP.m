function visualizeTopKSP(X, SP_pairs, param, idx, TopKIdx)

isRescale = false;
h = figure;
if isfield(param,'imgMap') 
    img = imread(param.imgMap);
    hi = imshow(img);
    set(hi,'AlphaData',1);
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
    X(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,X(:,[2,1]),minn),maxx-minn);
    X(:,[2,1]) = bsxfun(@times, X(:,[2,1]), [Xlim(2),Ylim(2)]);
    X(:,1) = Ylim(2) - X(:,1);
end
%%

param.isNodeColor = 3;
param.visualArrow = true; %!!!!!!!!!!!!!!!!!!!
param.idx0 = idx;
param.TopKIdx = TopKIdx;

heatMapVisualization(SP_pairs,param,isRescale);
hold off;




end