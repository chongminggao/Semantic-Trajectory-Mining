function syncMap = Index_Tracing(numberOfPrototypePoint,map_record)

% for i = 1:numberOfPrototypePoint
%     syncMap(i) = dfs(map_record,i)
% end
   
syncMap = bfs(map_record,numberOfPrototypePoint);

end

%% dfs Traversing
function index_set = dfs(map_record,index)
    indices = [];
    values = map_record{end}.values;
    for i = index
        indices = [indices, values{i}];
    end
    
    layer = length(map_record);
    if layer == 1
        index_set = indices;
    else
        index_set = dfs(map_record(1:end-1),indices);
    end
    
end

%% bfs Traversing
function syncMap = bfs(map_record,numberOfPrototypePoint)
    syncMap = containers.Map('KeyType','int32','ValueType','any');
    pointSet = cell(numberOfPrototypePoint,1);
    for j = 1:numberOfPrototypePoint
        pointSet{j} = j;
    end
  
    
    for i = length(map_record):-1:1
        map = map_record{i};
        values = map.values;
        for j = 1:numberOfPrototypePoint
            pointSet{j} = [values{pointSet{j}}];
        end
    end
    
    for j = 1:numberOfPrototypePoint
        syncMap(j) = pointSet{j};
    end
end


