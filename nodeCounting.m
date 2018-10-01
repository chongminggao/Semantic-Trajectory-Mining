function [nodeCount,nodeCountIdx,node_visual_count] = nodeCounting(SP_pairs,SP_pair_indeces)
    nodepairs = SP_pair_indeces(:,1:2);
    nodes = unique(nodepairs(:));
    Xall = SP_pairs(:,[1,3]);
    Yall = SP_pairs(:,[2,4]);
    nodeCount = zeros(length(nodes),3);
    nodeCountIdx = zeros(length(nodes),1);
    
    for i = 1:length(nodes)
        index2 = nodes(i) == nodepairs;
%         index = [index(:,1),index(:,2),index(:,2),index(:,1)];
        index = sum(index2,2);
        count = sum(index.*SP_pairs(:,5));
        
        node_visual_count(nodes(i)) = max(index.*SP_pairs(:,5));
        
        x = unique(Xall(index2));
        y = unique(Yall(index2));
        if length(x)~=1 || length(y)~= 1
            error('error,please check');
        end
        nodeCount(nodes(i),:) = [x,y,count];
        nodeCountIdx(nodes(i)) = count;
    end
end


function nodeCount = InNodeCounting(SP_pair_indeces)
    InNode = SP_pair_indeces(:,2);
    nodes = unique(InNode(:));
        
    for i = 1:length(nodes)
        index = nodes(i) == InNode;
        count = sum(index.*SP_pair_indeces(:,3));
        nodeCount(nodes(i),:) = [nodes(i),count];
    end
end