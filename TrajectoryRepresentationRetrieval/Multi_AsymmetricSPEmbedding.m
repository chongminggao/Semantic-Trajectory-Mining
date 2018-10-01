function [S, T] =  Multi_AsymmetricSPEmbedding(cell_SP_pair_indeces, cell_latLong_using_prototypes_index, Mapping_son_to_parent, param, type1Neighorhoods,type2Neighorhoods, type3Neighorhoods,type4Neighorhoods,type5Neighorhoods)
layer = length(cell_SP_pair_indeces);
dim = param.dim;
for i = 1:layer
    cell_SP_pair_indeces{i} = Direct2NonDirectGraph(cell_SP_pair_indeces{i});
    nodeCount{i} = eval(strjoin({'param.nodeCount_',num2str(i-1)},''));
    num(i) = size(nodeCount{i},1);
    [S{i}, T{i}] = InitializeEmbedding(num(i),dim);
    [S_Table{i},A_Table{i}] = AliasTableCounstruction(cell_SP_pair_indeces{i},num(i));
    [index_of_trajectory{i}, pointer_start{i}] = unique(cell_latLong_using_prototypes_index{i}(:,1),'stable');
    numberOfTrajectories(i) = length(index_of_trajectory{i});
end

tradeoff = param.tradeoff;
IterTime = param.IterTime;
NS = param.NegativeSamples;
learningRate = param.learningRate;
window = param.window;


% NeighborDegreeDistribution_similarMat = findKsimilardistribution(distanceMat,param.similarNum,nodeCount,param.degreeRate);


for Iter = 1:IterTime
    for l = 1:layer
        for i = 1:numberOfTrajectories(l)
            if mod(i,200) == 0
                fprintf('Embedding round[%d], Layer [%d], the [%d]/[%d] trajectory is processing...\n',Iter,l,i,numberOfTrajectories(l));
            end
            if i ~= numberOfTrajectories(l)
                SPSequence = cell_latLong_using_prototypes_index{l}(pointer_start{l}(i) : pointer_start{l}(i+1)-1,2);
            else
                SPSequence = cell_latLong_using_prototypes_index{l}(pointer_start{l}(i) : end,2);
            end
            len = length(SPSequence);
            if len < 2
                continue;
            end

            for idx = 1:len
                u = SPSequence(idx);

                T_old = T{l};

                left = idx - window;
                right = idx + window;
                if left < 1, left = 1; end;
                if right > len, right = len; end;
                Contexts = [SPSequence([left:idx - 1, idx + 1:right])', type1Neighorhoods{l}(u,1:param.type1),type2Neighorhoods{l}(u,1:param.type2),type3Neighorhoods{l}(u,1:param.type3),type4Neighorhoods{l}(u,1:param.type4),type5Neighorhoods{l}(u,1:param.type5)];
                indece = NegativeSampling([u,Contexts], NS, S_Table{l},A_Table{l}, num(l));
                for context = Contexts
                    e = 0;
                    for target = [u; indece]'
                        if target == u
                            I = 1;
                        else
                            I = 0;
                        end
                        sigma = mysigmf(dot(S{l}(context,:),T{l}(target,:)));
                        g = learningRate * (I - sigma);
                        e = e + g * T_old(target,:);
                        T{l}(target,:) = T{l}(target,:) + g * S{l}(context,:);
                        
                        if l < layer
                            parent = Mapping_son_to_parent{l}(target);
                            T{l}(target,:) = T{l}(target,:) + tradeoff * learningRate * (T{l+1}(parent,:) - T{l}(target,:));
                            T{l+1}(parent,:) = T{l+1}(parent,:) + tradeoff * learningRate * (T{l}(target,:) - T{l+1}(parent,:));
                        end
                    end
                    S{l}(context,:) = S{l}(context,:) + e;
                    if l < layer
                        parent = Mapping_son_to_parent{l}(context);
                        S{l}(context,:) = S{l}(context,:) + tradeoff * learningRate * (S{l+1}(parent,:) - S{l}(context,:));
                        S{l+1}(parent,:) = S{l+1}(parent,:) + tradeoff * learningRate * (S{l}(context,:) - S{l+1}(parent,:));
                    end
                end
            end
        end
    end
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