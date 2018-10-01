function visualization3_multi(param_multi)
    nVarrays = length(param_multi);
    
    fff = figure; 
    isRescale = false;
    param = param_multi{1};
    
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

    % ================================================
    Max_edgeSize_M = [2, 5];
    Max_nodeSize_M = [30 1000];
    height = param.Distance_mean/100;
    
    
%     % ==============DMKD visualization parameters ===================
%     edgeSize_M_test = [0.5, 1;
%                0.5, 2;
%                0.7, 4;
%                1, 5];
%            
%     nodeSize_M_test = [5 200;
%                   10 500;
%                   20 800;
%                   30 1000];
%     height = 300;
%    % ==============DMKD visualization parameters ===================
   
    hold on;
    for i = 1:nVarrays
        
        edgeSize_M = Max_edgeSize_M./nVarrays * i;
        nodeSize_M = Max_nodeSize_M./nVarrays * i;
        
%         % ==============DMKD visualization parameters ===================
%         edgeSize_M = edgeSize_M_test(i,:);
%         nodeSize_M = nodeSize_M_test(i,:);
%         % ==============DMKD visualization parameters ===================
        
        
        param = param_multi{i};
        SP_pairs = param.SP_pairs;
        param.visualArrow = false;
        zvalue = (i-1) * height;
        if i > 1
            isMapping = true;
            param.lastZvalue = (i-2) * height;
        else
            isMapping = false;
        end
        heatMapVisualization3(SP_pairs,param,zvalue,isRescale,edgeSize_M,nodeSize_M,isMapping);
    end
    hold off;
    view(-33.4000,13.8000)
%     view(-31.8000,17.2000)
    set(fff, 'PaperType', 'A2');



end