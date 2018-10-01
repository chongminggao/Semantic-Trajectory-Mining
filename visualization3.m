function visualization3(varargin)
nVarrays = length(varargin);

if nVarrays < 3
    visualization(varargin{1},param)
    return;
end

if nVarrays / 2 ~= round(nVarrays / 2)
    error('The number of parameter should be even number!');
end

% if ~(isfield(param,'visualStyle') && isequal(param.visualStyle,'heatmap'))
%     error('More functions haven''t been implemented!');
% end


fff = figure; 
isRescale = false;
param = varargin{2};
if isfield(param,'imgMap') 
    img = imread(param.imgMap);
    img = flipud(img);
    [sizey,sizex,~] = size(img);
    background = -30 * ones(sizey,sizex);
    h = surface(background,img,'FaceColor','texturemap','EdgeColor','none','CDataMapping','direct');
    axis equal;
    axis off;
%     h = imshow(img);
%     set(h,'AlphaData',0.9);
    Xlim = [1, sizex];
    Ylim = [1, sizey];
    Xlim = [0,Xlim(2)+0.5];
    Ylim = [0,Ylim(2)+0.5];
    isRescale = true;
    axis([Xlim,Ylim]);
    if ~isfield(param,'axisRange')
        error('Please specify the axisRange');
    end
end

edgeSize_M = [0.5, 1;
               0.5, 2;
               0.7, 4;
               1, 5];
           
nodeSize_M = [5 200;
              10 500;
              20 800;
              30 1000];

height = 300;
          
hold on;
for i = 1:nVarrays/2
    SP_pairs = varargin{i * 2 - 1};
    param = varargin{i * 2};
    param.visualArrow = false;
    zvalue = (i-1) * height;
    if i > 1
        isMapping = true;
        param.lastZvalue = (i-2) * height;
    else
        isMapping = false;
    end
    heatMapVisualization3(SP_pairs,param,zvalue,isRescale,edgeSize_M(i,:),nodeSize_M(i,:),isMapping);
end
hold off;
view(-32.2000,22)
set(fff, 'PaperType', 'A2');



end