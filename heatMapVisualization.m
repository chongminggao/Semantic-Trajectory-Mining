function heatMapVisualization(SP_pairs,param,isRescale)

    if ~isfield(param,'SP_pair_indeces') || ~isfield(param,'nodeCount')
        error('Please pass SP_pair_indeces and nodeCount in param');
    end    
    
    nodeCount = param.nodeCount;
    nodeSize = nodeCount(:,end);
    
    if isRescale
        X = [SP_pairs(:,2),SP_pairs(:,1);SP_pairs(:,4),SP_pairs(:,3)];
        minn = param.axisRange([1,3]);
        maxx = param.axisRange([2,4]);
        Xlim = xlim;
        Ylim = ylim;
        X(:,[1,2]) = bsxfun(@rdivide,bsxfun(@minus,X(:,[1,2]),minn),maxx-minn);
        X(:,[1,2]) = bsxfun(@times, X(:,[1,2]), [Xlim(2),Ylim(2)]);
        X(:,2) = Ylim(2) - X(:,2); % turn upside down
        SP_pairs(:,1) = X(1:size(X,1)/2,2);
        SP_pairs(:,2) = X(1:size(X,1)/2,1);
        SP_pairs(:,3) = X(size(X,1)/2+1:end,2);
        SP_pairs(:,4) = X(size(X,1)/2+1:end,1);
        
        nodeCount(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,nodeCount(:,[2,1]),minn),maxx-minn);
        nodeCount(:,[2,1]) = bsxfun(@times, nodeCount(:,[2,1]), [Xlim(2),Ylim(2)]);
        nodeCount(:,1) = Ylim(2) - nodeCount(:,1);
        
    end
    
    isQuiver = false;

    if isfield(param,'visualArrow') && param.visualArrow == true
        draw = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),...
                y(2)-y(1),0, varargin{:});
        isQuiver = true;
    else
        SP_pairs = mergeTwoDirectionaryPair(SP_pairs);
        draw = @plot;
    end
    
    
    %% need some specific set
    colorMap = hot(64);
    colorMap_Node = bone(64);
    colorMap_Node = colorMap_Node(1:40,:);
    colorMap = colorMap(1:40,:);
    
%     minn = min(nodeSize);
%     maxx = max(nodeSize);
%     nodeSize = (nodeSize - minn)/(maxx - minn) * 2 + 1; % normalize the nodeSize range to[1,3], to make a log() effect.
%     nodeSize = log(nodeSize);
    nodeDegree = (nodeSize - min(nodeSize))/(max(nodeSize)-min(nodeSize));

    
    
    
    nodeColor = size(colorMap_Node,1) - floor(nodeDegree * (size(colorMap_Node,1)-1));
    nodeColor = colorMap_Node(nodeColor,:);
    
    
    SP_pairs = sortrows(SP_pairs,5);
    % ===================================================
%     SP_pairs(SP_pairs(:,5) < 2,:) = [];
    % ===================================================
    countAll = SP_pairs(:,5);
    countAll = log2(countAll+1);
    edgeColorDegree = (countAll - min(countAll))/(max(countAll)-min(countAll));%(0~1)
    edgeColorDegree2 = size(colorMap,1) - floor(edgeColorDegree * (size(colorMap,1)-1));
    edgeColor = colorMap(edgeColorDegree2,:);
    
    
    if isfield(param,'nodeSize_M') 
        nodeSize = param.nodeSize_M(1) + param.nodeSize_M(2) * nodeDegree;
    else
        nodeSize = 30 + 300 * nodeDegree;
    end
    
    if isfield(param,'edgeSize_M') 
        edgeWidth = param.edgeSize_M(1) + param.edgeSize_M(2) * edgeColorDegree;
    else
        edgeWidth = 2 + 8 * edgeColorDegree;
    end
    %%
    
    if ~param.number
        for i = 1:size(SP_pairs,1)
            one_pair = SP_pairs(i,1:4);
            count = SP_pairs(i,5);
            logHeat = edgeWidth(i);
            if(count >= param.visualthreshold)
                pp = draw(one_pair([2,4]),one_pair([1,3]),...
                    'LineWidth',logHeat,...
                    'Color',edgeColor(i,:),...
                    'MarkerFaceColor','auto');

                if isQuiver
%                     pp.MaxHeadSize = 0.3 + 0.5 * edgeColorDegree(i);%logHeat-1.8;
                    pp.MaxHeadSize = 2 + 4 * edgeColorDegree(i);%logHeat-1.8;
    %                 pp.AutoScale = 'off';
                    pp.AutoScaleFactor = 0.3;
                    pp.AlignVertexCenters = 'on';
                end
    %         else
    %             pp = draw(one_pair([2,4]),one_pair([1,3]),...
    %                 'o',...
    %                 'LineWidth',logHeat,...
    %                 'Color',edgeColor(i,:),...
    %                 'MarkerFaceColor','auto');
            end

    %         pp = plot(one_pair([2,4]),one_pair([1,3]),'o','MarkerSize',logHeat+2,'Color',color(i,:),'MarkerFaceColor',[0 0.4470 0.7410]);
        end
    end
    
    nodeCount(:,3) = nodeSize;
    
    
    if isfield(param,'isNodeColor') && param.isNodeColor == 1 && isfield(param,'idx')
        idx = param.idx;
        nodeCount(:,4) = idx;
        len = length(unique(idx));
        if len > 7
            colorMap = parula(length(unique(idx)));
        else
            colorMap = lines(7);
            colorMap([2:3,5:6],:) = colorMap([5:6,2:3],:);
            colorMap(length(unique(idx)),:) = [0.83 0.83 0.83];
        end
    end
    
    minusNumber = 0;
    if isfield(param,'isNodeColor') && param.isNodeColor==3  && isfield(param,'idx0') && isfield(param,'TopKIdx')
        
        minusNumber = length(param.TopKIdx);
        minn = min(nodeSize(param.TopKIdx));
        maxx = max(nodeSize);
        differ = maxx - minn + 1;
        nodeCount(param.TopKIdx,3) = nodeCount(param.TopKIdx,3) + differ;
        differ_boss = max(nodeCount(param.TopKIdx,3)) - nodeCount(param.idx0,3) + 1;
        nodeCount(param.idx0,3) = nodeCount(param.idx0,3) + differ_boss;
        
        TopKIdx = [param.TopKIdx,[1:size(param.TopKIdx,1)]'];
    end
    [nodeCount,sortIdx] = sortrows(nodeCount,3);
    
    if minusNumber > 0
        num = size(nodeCount,1);
        nodeCount(num - minusNumber :num-1,3) = nodeCount(num - minusNumber:num-1,3) - differ;
        nodeCount(num,3) = nodeCount(num,3) - differ_boss;
    end
    
    shape = {'o','p','s','+','>','x','h'};
    
    color = lines(7);
    blue = color(1,:);
    purple = color(4,:);
    black = [0.2 0.2 0.2];
    green = color(5,:);
    
    if param.isNodeColor==3
        nn = length(param.TopKIdx);
        colorMap = summer(round(nn * 1.6));
        colorMap(1:round(nn * 0.2),:) = [];
    end
    
    if isfield(param,'visualRoundabouts') && isequal(param.visualRoundabouts,true)
        numberOfRA = size(param.roundabouts,1);
    end
    

    for i = 1:size(nodeCount,1)
        faceColor = 'auto';
        nodeSize = nodeCount(i,3);
        shape = 'o';
        if isfield(param,'visualRoundabouts') && isequal(param.visualRoundabouts,true)
            if sortIdx(i) <= numberOfRA
                faceColor = [0.3010    0.7450    0.9330];%[0.5660    0.7740    0.2880];
                shape = '^';
            end
%             nodeSize = 50;
        end
        
        
        if isfield(param,'node_visual_count') && param.node_visual_count(sortIdx(i)) < param.visualthreshold
            continue;
        end
            
        hi = scatter(nodeCount(i,2),nodeCount(i,1),nodeSize,shape,...
            'MarkerFaceColor',faceColor,...
            'MarkerEdgeColor', [0 0 0],...%nodeColor(i,:),... %[0 0.4470 0.7410],...
            'LineWidth',1);

        
        if isfield(param,'NodelineWidth')
            set(hi,'LineWidth',param.NodelineWidth);
        end

        if isfield(param,'number') && param.number
            str = strcat('\leftarrow', num2str(sortIdx(i)));
            text(nodeCount(i,2),nodeCount(i,1),str);
        end
        
        
        if isfield(param,'isNodeColor') && param.isNodeColor==1  && isfield(param,'idx')
            hi.MarkerFaceColor = colorMap(nodeCount(i,4),:);
%             hi.MarkerFaceAlpha = 0.8;
%             hi.MarkerEdgeAlpha = 0.5;
%             hi.Marker = shape{nodeCount(i,4)};
        end
        
        if isfield(param,'isNodeColor') && param.isNodeColor==2  && isfield(param,'color')
            hi.MarkerFaceColor = param.color(i,:);
%             hi.MarkerFaceAlpha = 0.8;
            hi.MarkerEdgeAlpha = 0.5;
            
        end
        
        if isfield(param,'isNodeColor') && param.isNodeColor==3  && isfield(param,'idx0') && isfield(param,'TopKIdx')
            
            
            % comment for synthesis!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if isRescale
                if i == num - length(param.TopKIdx) -1 
                    pp = patch([0 Xlim(2) Xlim(2) 0],[0 0 Ylim(2) Ylim(2)],[1 1 1]);
                    pp.FaceAlpha = 0.65;
                    pp.LineStyle = 'none';
                end
            end
            
            if sortIdx(i) == param.idx0
                hi.MarkerFaceColor = blue;
%                 hi.Marker = 'p';
%                 hi.SizeData = hi.SizeData * 3;
                
            elseif ismember(sortIdx(i),param.TopKIdx)
                numstr = TopKIdx(TopKIdx(:,1) == sortIdx(i),2);
%                 str = strcat(num2str(numstr));
%                 text(nodeCount(i,2),nodeCount(i,1),str,'FontSize',30);
                hi.MarkerFaceColor = colorMap(numstr,:);
            else
                hi.MarkerFaceColor = 'auto';
            end
                
%             hi.MarkerFaceAlpha = 0.8;
%             hi.MarkerEdgeAlpha = 0.5;
            
        end
    end

    
%     hold off;
    
    
%     if isfield(param,'axisRange')
%         axis(param.axisRange);
%     end
end

function SP_pairs = mergeTwoDirectionaryPair(SP_pairs)
    temp = [];
    while size(SP_pairs,1) > 0
        onePair = SP_pairs(1,1:4);
        onePairExchange = [onePair(3:4),onePair(1:2)];
        count = SP_pairs(1,5);
        
        index = sum(bsxfun(@eq,SP_pairs(:,1:4),onePairExchange),2);
        index = (index==4);
        index(1) = false; % avoid onePair = (x,x);
        
        if sum(index) % There is a onePairExchange contained in SP_paris.
            count = count + SP_pairs(index,5);
            SP_pairs(index,:) = [];
        end
        
        SP_pairs(1,:)=[];
        temp = [temp;onePair,count];
        
    end
    SP_pairs = temp;
end