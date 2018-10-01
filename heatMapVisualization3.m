function heatMapVisualization3(SP_pairs,param,zvalue,isRescale,edgeSize_M,nodeSize_M,isMapping)

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
    
    
    if isMapping
        lastNodeCount = param.lastNodeCount;
        Mapping_to_son = param.Mapping_to_son;
        if isRescale
            lastNodeCount(:,[2,1]) = bsxfun(@rdivide,bsxfun(@minus,lastNodeCount(:,[2,1]),minn),maxx-minn);
            lastNodeCount(:,[2,1]) = bsxfun(@times, lastNodeCount(:,[2,1]), [Xlim(2),Ylim(2)]);
            lastNodeCount(:,1) = Ylim(2) - lastNodeCount(:,1);
        end
        lastZvalue = param.lastZvalue;
        for i = 1: size(nodeCount,1)
            x = nodeCount(i,2);
            y = nodeCount(i,1);
            lists = Mapping_to_son(i);
            for j = 1: length(lists)
                x_last = lastNodeCount(lists(j),2);
                y_last = lastNodeCount(lists(j),1);
                plot3([x,x_last],[y,y_last],[zvalue, lastZvalue],'-.','Color',[0.6111,0.7205,0.7361],'LineWidth',0.5);
            end
        end
    end
    
    
    isQuiver = false;

    if isfield(param,'visualArrow') && param.visualArrow == true
%         draw = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),...
%                 y(2)-y(1),0, varargin{:});
            
        draw = @(x,y,z,varargin) quiver3(x(1),y(1),z(1),x(2)-x(1),...
            y(2)-y(1),z(2)-z(1),0,varargin{:});
        isQuiver = true;        
    else
        SP_pairs = mergeTwoDirectionaryPair(SP_pairs);
        draw = @plot3;
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
    nodeSize = nodeSize_M(1) + nodeSize_M(2) * nodeDegree;
    nodeColor = size(colorMap_Node,1) - floor(nodeDegree * (size(colorMap_Node,1)-1));
    nodeColor = colorMap_Node(nodeColor,:);
    
    
    SP_pairs = sortrows(SP_pairs,5);
    % ===================================================
%     SP_pairs(SP_pairs(:,5) < 2,:) = [];
    % ===================================================
    countAll = SP_pairs(:,5);
    countAll = log2(countAll+1);
    edgeColorDegree = (countAll - min(countAll))/(max(countAll)-min(countAll));%(0~1)
    edgeWidth = edgeSize_M(1) + edgeSize_M(2) * edgeColorDegree;
    edgeColorDegree2 = size(colorMap,1) - floor(edgeColorDegree * (size(colorMap,1)-1));
    edgeColor = colorMap(edgeColorDegree2,:);
    %%
    
    if ~param.number
        for i = 1:size(SP_pairs,1)
            one_pair = SP_pairs(i,1:4);
            count = SP_pairs(i,5);
            logHeat = edgeWidth(i);
            if(count >= param.visualthreshold)
                pp = draw(one_pair([2,4]),one_pair([1,3]),zvalue * ones(1,2),...
                    'LineWidth',logHeat,...
                    'Color',edgeColor(i,:),...
                    'MarkerFaceColor','auto');
%                 pp = draw(one_pair([2,4]),one_pair([1,3]),level * ones(1,2),...
%                     'Color',edgeColor(i,:));

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

        end
    end
    
    nodeCount(:,3) = nodeSize;
    
    
    
    color = lines(7);
    blue = color(1,:);
    purple = color(4,:);
    black = [0.2 0.2 0.2];
    green = color(5,:);
    
    
    if isfield(param,'visualRoundabouts') && isequal(param.visualRoundabouts,true)
        numberOfRA = size(param.roundabouts,1);
    end

    for i = 1:size(nodeCount,1)
        faceColor = 'auto';
        nodeSize = nodeCount(i,3);
        shape = 'o';

        if isfield(param,'visualRoundabouts') && isequal(param.visualRoundabouts,true)
            if i <= numberOfRA
                faceColor = [0.3010    0.7450    0.9330];%[0.5660    0.7740    0.2880];
                shape = '^';
            end
%             nodeSize = 50;
        end
        
        hi = scatter3(nodeCount(i,2),nodeCount(i,1), zvalue,nodeSize,shape,...
            'MarkerFaceColor',faceColor,...
            'MarkerEdgeColor', [0 0 0],...%nodeColor(i,:),... %[0 0.4470 0.7410],...
            'LineWidth',1);

        if isfield(param,'number') && param.number
            str = strcat('\leftarrow', num2str(sortIdx(i)));
            text(nodeCount(i,2),nodeCount(i,1),str);
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