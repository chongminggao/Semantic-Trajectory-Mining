function last_layer_indeces = Tracing_particular_point_from_prototype_to_original(map_record,prototype_index,Xoriginal, numberOfPartition,isdisplay,param)

tab = ' ';

last_layer_indeces = dfs_OutPutTree(map_record,prototype_index,1,[],Xoriginal,numberOfPartition,tab,isdisplay,param);


end

%% dfs Traversing
function index_set = dfs_OutPutTree(map_record,index,depth,outputControl,Xoriginal,numberOfPartition, tab,isdisplay,param)
    
    layer = length(map_record);

    keys = map_record{end}.keys;
    values = map_record{end}.values;
    
    index_set = [];
    for now_index = index
        now_key = map1dto2d(keys{now_index},numberOfPartition);
        now_point = Denormalization(Xoriginal,numberOfPartition,now_key,param);
        indeces = values{now_index};

        % tree structure printing:
        if isdisplay
            
            for i = 1:(depth-1)
                if outputControl(i) == true
                    fprintf('©¦%s',tab);
                else
                    fprintf(' %s',tab);
                end
            end

            if now_index ~= index(end)
                fprintf('©À©¤');
                outputControl(depth) = true;
            else
                fprintf('©¸©¤');
                outputControl(depth) = false;
            end

            fprintf('%d:%s\n',now_index,mat2str(now_point));
        end
        
        if layer == 1
            index_set = [index_set, indeces];
            if isdisplay
                outputLastLayer(indeces, depth+1, outputControl, Xoriginal, tab);
            end
        else
            index_set = [index_set, dfs_OutPutTree(map_record(1:end-1), indeces, depth+1, outputControl, Xoriginal, numberOfPartition, tab,isdisplay,param)];
        end
    end
end

function outputLastLayer(index,depth,outputControl,Xoriginal,tab)
    
    for now_index = index
        % tree structure printing:
        for i = 1:(depth-1)
            if outputControl(i) == true
                fprintf('©¦%s',tab);
            else
                fprintf(' %s',tab);
            end
        end
        
        if now_index ~= index(end)
            fprintf('©À©¤');
            outputControl(depth) = true;
        else
            fprintf('©¸©¤');
            outputControl(depth) = false;
        end
        
        now_point = Xoriginal(now_index,:);
        fprintf('%d:%s\n',now_index,mat2str(now_point));
    end
end

function x = map1dto2d(a,numberOfPartition)
    x = fix(a/numberOfPartition);
    y = mod(a,numberOfPartition);
    x = double([x,y]);
end