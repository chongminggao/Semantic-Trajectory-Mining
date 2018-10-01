function result = Fast_Hierarchical_Synchronization(X,param)
% param.Knn : The number of nearest neighbors of each 2-dimension GPS point.
% param.epsilon : the interactive distance range of every point. Given a 
% GPS point, if the number of neighbors in this range is less than param.Knn
% , then this point will be seen as an anomaly and will not considered as a
% prototype point.

% normalize data into range of [0,pi/2];
if size(X,1)==0
    error('there is no data input');
end

X_original = X;
if isfield(param,'syncRoundabouts') && isequal(param.syncRoundabouts,true)
    roundabouts = param.roundabouts;
    errorTolerance = param.errorTolerance;
    errorTolerance = errorTolerance/(pi/2) * (param.axisRange(4) - param.axisRange(3) + param.axisRange(2) - param.axisRange(1))/2;
    [indeces, d] = knnsearch(roundabouts,X,'k',1);
    nonMatchInd = find(d > errorTolerance);
    MatchInd = find(d <= errorTolerance);
    matchToRAInd = indeces(d <= errorTolerance);
%     NoMatchRA = setdiff(1:length(roundabouts),matchToRAInd);
%     roundaboutsReducedIndex = 1:length(roundabouts);
%     roundaboutsReducedIndex(NoMatchRA) = [];
%     roundabouts(NoMatchRA) = [];
%     for i = 1:length(roundaboutsReducedIndex)
%         matchToRAInd(matchToRAInd == roundaboutsReducedIndex(i))=i;
%     end
    X = X(nonMatchInd,:);
end



X_norm = normalization(X,param);



numberOfPartitions = round(pi/2/param.max_displacement);


numberOfIterations = 1;
map_record = {};



newX = X_norm;
weights = ones(size(newX,1),1);
fprintf('original print number is %d \n',size(newX,1));

while true
%% replace key type from cell to int32
    map = containers.Map('KeyType','int32','ValueType','any');
    
    keys = fix(newX / param.max_displacement);       % keys are interger numbers indicating the index of grid_dimension_i.
    key_strs = keys(:,1) * pi/2/param.max_displacement + keys(:,2);
    
% % Old version 3
    [b,c] = sort(key_strs);
    [key_uni,pointer] = unique(b);
    pointer = [pointer;length(b)+1];
    for i = 1:length(pointer)-1
        key_str = key_uni(i);
        indeces = c(pointer(i):pointer(i+1)-1);
        map(key_str) = indeces';
    end
    
% % Old version 2
%     key_uni = unique(key_strs,'stable'); 
%     for index = 1:length(key_uni)
%         key_str = key_uni(index);
%         indeces = find(key_strs == key_str);
%         map(key_str) = indeces;
%     end
    
% % Old version 1
%     for index = 1:size(keys,1)
% %         key_str = map2dto1d(keys(index,:),pi/2/param.max_displacement); 
%         key_str = key_strs(index,:);
%         if isKey(map,key_str)
%             value = map(key_str);
%             map(key_str) = [value, index];
%         else
%             map(key_str) = index;
%         end
%     end
    
    %%
    keys_cell = map.keys;
    values_cell = map.values;
    
    weights_old = weights;
    X_grid = zeros(map.Count, size(X,2));
    weights = ones(map.Count, 1);

    %% replace key type from cell to int32
    
    for i = 1:length(keys_cell)
        key = map1dto2d(keys_cell{i},pi/2/param.max_displacement);
        X_grid(i,:) = key * param.max_displacement;  % Transfer the grid index to point coordinates.
        weights(i) = sum(weights_old(values_cell{i}));
    end
    
    %%
    fprintf('In the [%d] time iteration, number of new point generated is [%d]\n',...
        numberOfIterations,map.Count);
    
    map_record{numberOfIterations} = map;
    % Attention: we record map before break.
    
    if numberOfIterations > 1
        if map.Count == map_record{numberOfIterations-1}.Count
            break;
        end
    end
    
 
    %% control the number of iteration
    
    if isfield(param,'maxLayer')
        if numberOfIterations >= param.maxLayer
            break;
        end
    end
    
    
    %%
    
    [Neighbors_IDX,Distance] = knnsearch(X_grid,X_grid,'K',param.Knn+1);
    if length(Neighbors_IDX) > 0
        Neighbors_IDX(:,1) = [];
        Distance(:,1) = [];
    end
    isInEpsilonRange = Distance <= param.epsilon;
%     Neighbors_weights = weights(Neighbors_IDX);
    
    if isfield(param,'alpha')
        alpha = param.alpha;
    else
        alpha = 1;
    end

    
    [newX, RC] = Synchronization(X_grid,weights,Neighbors_IDX,isInEpsilonRange,...
        param.max_displacement, alpha);
    
    numberOfIterations = numberOfIterations + 1;
  
end


keys_str = map_record{end}.keys;
keys = zeros(length(keys_str),size(X,2));
for i = 1:length(keys_str)
    %% replace key type from cell to key
    key = map1dto2d(keys_str{i},pi/2/param.max_displacement);
    %%
    keys(i,:) = key;
end


%%
% result.normalizedSP = X_grid;
result.X = Denormalization(X ,numberOfPartitions, keys,param);
result.Map_Prototype_To_Original = Index_Tracing(size(X_grid,1),map_record);
result.Map_Original_To_Prototype = zeros(size(X,1),1);

if isfield(param,'syncRoundabouts') && isequal(param.syncRoundabouts,true)
    offset = length(roundabouts);
    result.X = [roundabouts;result.X];
    for i = length(result.Map_Prototype_To_Original.keys):-1:1
        result.Map_Prototype_To_Original(i + offset) = nonMatchInd(result.Map_Prototype_To_Original(i));
    end
    
    weights_roundabouts = zeros(offset,1);
    for i = 1:offset
        result.Map_Prototype_To_Original(i) = MatchInd(find(matchToRAInd == i));
        weights_roundabouts(i) = length(result.Map_Prototype_To_Original(i));
    end
    weights = [weights_roundabouts;weights];
    result.Map_Original_To_Prototype = zeros(length(X_original),1);
end

result.map_record = map_record;
numberOfPrototypes = length(result.Map_Prototype_To_Original.keys);
result.numberOfPrototypes = numberOfPrototypes;
result.numberOfPartitions = numberOfPartitions;
result.numberOfIterations = numberOfIterations;
result.weight = weights;


for i = 1:numberOfPrototypes
    index = result.Map_Prototype_To_Original(i);
    result.Map_Original_To_Prototype(index) = i;
end


% ===============Calculate MSE, if indicate===============
if isfield(param,'isMSE') && isequal(param.isMSE,true)
    MSE = zeros(numberOfPrototypes,1);
    for i = 1:numberOfPrototypes
        index = result.Map_Prototype_To_Original(i);
        if isempty(index)
            MSE(i) = 0;
            continue;
        end
        correspondingX = param.originallatLong(index,2:3);
        MSE(i) = mean(transfer_latLongPair_to_meter(result.X(i,:),correspondingX));
    end
    result.totalMSE = sum(MSE .* weights) / sum(weights);
end

end



function a = map2dto1d(x,maxx)
a = x(1) * maxx + x(2);
end

function x = map1dto2d(a,maxx)
x = fix(a/maxx);
y = mod(a,maxx);
x = double([x,y]);
end