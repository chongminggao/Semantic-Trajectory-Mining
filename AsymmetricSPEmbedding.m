function [S, T] =  AsymmetricSPEmbedding(SP_pair_indeces, latLong_using_prototypes_index,type1Neighorhoods,type2Neighorhoods,type3Neighorhoods,type4Neighorhoods,type5Neighorhoods, param)

SP_pair_indeces = Direct2NonDirectGraph(SP_pair_indeces);
num = size(param.nodeCount,1);
dim = param.dim;

[S, T] = InitializeEmbedding(num,dim);
[S_Table,A_Table] = AliasTableCounstruction(SP_pair_indeces,num);


IterTime = param.IterTime;
NS = param.NegativeSamples;
learningRate = param.learningRate;
window = param.window;

[index_of_trajectory, pointer_start] = unique(latLong_using_prototypes_index(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);

% NeighborDegreeDistribution_similarMat = findKsimilardistribution(distanceMat,param.similarNum,nodeCount,param.degreeRate);


for Iter = 1:IterTime
    for i = 1:numberOfTrajectories
        if mod(i,200) == 0
            fprintf('Embedding round[%d], the [%d]/[%d] trajectory is processing...\n',Iter,i,numberOfTrajectories);
        end
        if i ~= numberOfTrajectories
            SPSequence = latLong_using_prototypes_index(pointer_start(i) : pointer_start(i+1)-1,2);
        else
            SPSequence = latLong_using_prototypes_index(pointer_start(i) : end,2);
        end
        len = length(SPSequence);
        if len < 2
            continue;
        end
        
        for idx = 1:len
            u = SPSequence(idx);
            
            T_old = T;
            
            left = idx - window;
            right = idx + window;
            if left < 1, left = 1; end;
            if right > len, right = len; end;
            Contexts = [SPSequence([left:idx - 1, idx + 1:right])', type1Neighorhoods(u,1:param.type1),type2Neighorhoods(u,1:param.type2),type3Neighorhoods(u,1:param.type3),type4Neighorhoods(u,1:param.type4),type5Neighorhoods(u,1:param.type5)];
            indece = NegativeSampling([u,Contexts], NS, S_Table,A_Table, num);
            for context = Contexts
%             for j = -window : window
%                 contextId = idx + j;
%                 if contextId < 1 || contextId > len || j == 0
%                     continue;
%                 end
%                 context = SPSequence(contextId);
                e = 0;
                for target = [u; indece]'
                    if target == u
                        I = 1;
                    else
                        I = 0;
                    end
                    sigma = mysigmf(dot(S(context,:),T(target,:)));
                    g = learningRate * (I - sigma);
                    e = e + g * T_old(target,:);
                    T(target,:) = T(target,:) + g * S(context,:);
                end
                S(context,:) = S(context,:) + e;
            end
        end
    end
end

end

function Neighbor_type1 = Type1Constructor(nodeCount,type1)
    count = nodeCount;
    countDist = dist(count,count');
    countDist = countDist/max(max(countDist));
    Neighbor_type1 = zeros(size(countDist,1),type1);
    for i = 1:length(countDist)
        [~, index] = sort(countDist(i,:));
        index(index == i) = [];
        Neighbor_type1(i,1:type1) = index(1:type1);
    end
end

function Neighbor_type2 = Type2Constructor(SourceNeighbor,numberOfPartition,weightedDegreeCount,transferCount,type2)
    [NeighborDegreeDistribution_new] = construct_NeighborDegreeDistribution(SourceNeighbor,numberOfPartition,weightedDegreeCount,transferCount);
    distanceMat = KL_matrixDivergence(NeighborDegreeDistribution_new);
    Neighbor_type2 = zeros(size(distanceMat,1),type2);
    for i = 1:length(distanceMat)
        [~, index] = sort(distanceMat(i,:));
        index(index == i) = [];
        Neighbor_type2(i,1:type2) = index(1:type2);
    end
end



% function SimilarNeighborDegreeDistributionNeighborhoods = findKsimilardistribution(distanceMat,k,nodeCount,rate)
%     count = nodeCount;
%     countDist = dist(count,count');
%     countDist = countDist/max(max(countDist));
%     distanceCombine = rate * distanceMat + (1-rate) * countDist;
%     SimilarNeighborDegreeDistributionNeighborhoods = zeros(size(distanceCombine,1),k);
%     for i = 1:length(distanceCombine)
%         [~, index] = sort(distanceCombine(i,:));
%         index(index == i) = [];
%         SimilarNeighborDegreeDistributionNeighborhoods(i,1:k) = index(1:k);
%     end
% end


function [NeighborDegreeDistribution_new] = construct_NeighborDegreeDistribution(SourceNeighbor, numberOfPartition,weightedDegreeCount,transferCount)
%     neighbornumbertable = zeros(length(SourceNeighbor),1);
    NeighborDegreeDistribution = zeros(length(SourceNeighbor),numberOfPartition);

%     for i = 1:length(neighbornumbertable)
%         neighbornumbertable(i) = length(SourceNeighbor{i});
%     end
    
    while numberOfPartition > (length(SourceNeighbor) - 1)/2
        numberOfPartition = floor(numberOfPartition/2);
    end
    if numberOfPartition < 1
        error('Please input the reasonable partition\n');
    end
    
%     threshold = floor(max(weightedDegreeCount) / numberOfPartition);
    threshold = (max(weightedDegreeCount) / numberOfPartition);
    
    
    for i = 1:length(SourceNeighbor)
        neighbors_i = SourceNeighbor{i};
        for j = 1:length(neighbors_i)
            index = weightedDegreeCount(neighbors_i(j));
%             
%             switch index
%                 case {1,2}
%                     NeighborDegreeDistribution(i,1) = NeighborDegreeDistribution(i,1) + 1;
%                 case{3,4,5}
%                     NeighborDegreeDistribution(i,2) = NeighborDegreeDistribution(i,2) + 1;
%                 case{6,7,8,9}
%                     NeighborDegreeDistribution(i,3) = NeighborDegreeDistribution(i,3) + 1;
%                 otherwise
%                     NeighborDegreeDistribution(i,4) = NeighborDegreeDistribution(i,4) + 1;
%             end
            
            bin = floor((index - 1)/threshold) + 1;
            if bin == numberOfPartition + 1
                bin = numberOfPartition;
            end
            NeighborDegreeDistribution(i,bin) = NeighborDegreeDistribution(i,bin) + transferCount(i,neighbors_i(j)) + transferCount(neighbors_i(j),i);
            
%             NeighborDegreeDistribution(i,index+1) = NeighborDegreeDistribution(i,index+1) + 1;
        end
    end
    
    colomsum = sum(NeighborDegreeDistribution,1);
    cumrate = cumsum(colomsum) / sum(colomsum);
    findresult = find(cumrate >= 0.9);
    NeighborDegreeDistribution_new = NeighborDegreeDistribution(:,1:findresult(1));
    NeighborDegreeDistribution_new(:,findresult(1)) = sum(NeighborDegreeDistribution(:,findresult(1):end),2);
    
end

function similarMat = findKsimilarIO(nodeCountIdx,similarNum)
    distMat = dist(nodeCountIdx,nodeCountIdx');
    similarMat = zeros(size(nodeCountIdx,1),similarNum);
    if similarNum > size(nodeCountIdx,1) - 1
        similarNum = size(nodeCountIdx,1) - 1;
    end
    for i = 1:size(distMat,1)
        [~,idx] = sort(distMat(i,:));
        idx(idx == i) = [];
        idx(similarNum+1:end) = [];
        similarMat(i,:) = idx;
    end
end


function [SourceNeighbor,weightedDegreeCount] = findNeighborsOfSourceSP(SP_pair_indeces,num,nodeCount)
    SourceNeighbor = cell(num,1);
    weightedDegreeCount = zeros(size(nodeCount));
    for i = 1:size(SP_pair_indeces,1)
        u = SP_pair_indeces(i,1);
        v = SP_pair_indeces(i,2);
        SourceNeighbor{u} = [SourceNeighbor{u};v];
    end
    
    for i = 1:num
        SourceNeighbor{i} = unique(SourceNeighbor{i});
    end
    
    for i = 1:num
        neighbors = SourceNeighbor{i};
        for j = 1:length(neighbors)
            weightedDegreeCount(i) = weightedDegreeCount(i) + nodeCount(neighbors(j));
        end
    end
end

%% Initial the parameters the same way as word2vec code.
function [S,T] = InitializeEmbedding(num,dim)
S = zeros(num,dim);
T = (rand(num,dim) - 0.5)/dim;
end

%% Negative Sampling
function indece = NegativeSampling(neighbors, K, S_Table,A_Table, num)
    indece = zeros(K,1);
    for i = 1:K
        while true
            randFloat = rand * num;
            randNum = floor(randFloat);
            randMod = randFloat - randNum;
            randNum = randNum + 1;
            index = SampleFromAliasTable(S_Table,A_Table, randNum,randMod);
            if ~ismember(index,neighbors)
                break;
            end
        end
        indece(i) = index;
    end
end



%% Alias Sampling table construction, method comes from Stergios Stergiou et al, AAA2017
function [S_Table,A_Table] = AliasTableCounstruction(SP_pair_indeces,num)

[nodeCount,summ] = InNodeCounting(SP_pair_indeces);

S_Table = nodeCount(:,2)/summ * num;
A_Table = nodeCount(:,1);

TL = find(S_Table < 1);
TH = find(S_Table > 1);

if isempty(TL)
    return;
end

index2 = TH(1);
while ~isempty(TL) && ~isempty(TH)
    index1 = TL(1);
    TL(1) = [];
    S_Table(index2) = S_Table(index2) - 1 + S_Table(index1);
    A_Table(index1) = index2;
    
    if S_Table(index2) < 1 - 1e-4
        TL = [TL;index2];
        TH(1) = [];
        if ~isempty(TH)
            index2 = TH(1);
        end
        
    elseif ~(S_Table(index2) > 1 + 1e-4)
        TH(1) = [];
        if ~isempty(TH)
            index2 = TH(1);
        end
    end
end

end

function index = SampleFromAliasTable(S_Table,A_Table, randNum,randMod)
if S_Table(randNum) > randMod
    index = randNum;
else
    index = A_Table(randNum);
end
end


%% 
function [nodeCount,summ] = InNodeCounting(SP_pair_indeces)
    InNode = SP_pair_indeces(:,2);
    nodes = unique(InNode(:));
        
    for i = 1:length(nodes)
        index = nodes(i) == InNode;
        count = sum(index.*SP_pair_indeces(:,3));
        nodeCount(nodes(i),:) = [nodes(i),count];
    end
    
    summ = sum(nodeCount(:,2));
end

function SP_pair_indeces = Direct2NonDirectGraph(SP_pair_indeces)
    a = SP_pair_indeces;
    b(:,[1,2,3]) = a(:,[2,1,3]);
    c = [a,b]';
    c = reshape(c, 3, 2*size(a,1));
    SP_pair_indeces = c';
end