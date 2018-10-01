function SyntheticCompressedVisualization(SP_pairs,param,Set)
    
    figure;
    hold on;
    if ~isfield(param,'SP_pair_indeces') || ~isfield(param,'nodeCount')
        error('Please pass SP_pair_indeces and nodeCount in param');
    end    
    
    nodeCount = param.nodeCount;
    nodeSize = nodeCount(:,end);
    
    
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
    nodeSize = 30 + 500 * nodeDegree;
    nodeColor = size(colorMap_Node,1) - floor(nodeDegree * (size(colorMap_Node,1)-1));
    nodeColor = colorMap_Node(nodeColor,:);
    
    
    SP_pairs = sortrows(SP_pairs,5);
    % ===================================================
%     SP_pairs(SP_pairs(:,5) < 2,:) = [];
    % ===================================================
    countAll = SP_pairs(:,5);
    countAll = log2(countAll+1);
    edgeColorDegree = (countAll - min(countAll))/(max(countAll)-min(countAll));%(0~1)
    edgeWidth = 2 + 8 * edgeColorDegree;
    edgeColorDegree2 = size(colorMap,1) - floor(edgeColorDegree * (size(colorMap,1)-1));
    edgeColor = colorMap(edgeColorDegree2,:);
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
                    pp.MaxHeadSize = 10 + 50 * edgeColorDegree(i);%logHeat-1.8;
    %                 pp.AutoScale = 'off';
                    pp.AutoScaleFactor = 0.9;
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
    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        minusNumber = length(Set);
        minn = min(nodeSize(Set));
        maxx = max(nodeSize);
        differ = maxx - minn + 1;
        nodeCount(Set,3) = nodeCount(Set,3) + differ;
        differ_boss = max(nodeCount(Set,3)) - nodeCount(param.idx0,3) + 1;
        nodeCount(param.idx0,3) = nodeCount(param.idx0,3) + differ_boss;
        
        TopKIdx = [Set,[1:size(Set,1)]'];
    
    [nodeCount,sortIdx] = sortrows(nodeCount,3);
    
    if minusNumber > 0
        num = size(nodeCount,1);
        nodeCount(num - minusNumber :num-1,3) = nodeCount(num - minusNumber:num-1,3) - differ;
        nodeCount(num,3) = nodeCount(num,3) - differ_boss;
    end
    
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    shape = {'o','p','s','+','>','x','h'};
    
    color = lines(7);
    blue = color(1,:);
    purple = color(4,:);
    black = [0.2 0.2 0.2];
    green = color(5,:);
    
    colorMap = lines(6);
    colorMap = colorMap(6,:);
  

    for i = 1:size(nodeCount,1)
        hi = scatter(nodeCount(i,2),nodeCount(i,1),nodeCount(i,3),...
            'MarkerFaceColor','auto',...
            'MarkerEdgeColor', [0 0 0],...%nodeColor(i,:),... %[0 0.4470 0.7410],...
            'LineWidth',1.5);

        
        %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            % comment for synthesis!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            
            if sortIdx(i) == param.idx0 || ismember(sortIdx(i),Set)
                hi.MarkerFaceColor = colorMap;
%                 hi.MarkerFaceColor = [0.5660    0.7740    0.2880];
                hi.Marker = '^';
%                 hi.SizeData = 200;
                hi.LineWidth = 2;
            else
                hi.MarkerFaceColor = 'auto';
            end
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++            
    %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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