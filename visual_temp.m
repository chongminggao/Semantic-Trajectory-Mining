Xlim = xlim;
Ylim = ylim;


X = [ones(FastSyncResult.numberOfPrototypes,1),FastSyncResult.X];

hold on;

isRescale = true;
if isRescale
    minn = param.axisRange([1,3]);
    maxx = param.axisRange([2,4]);
    X(:,[3,2]) = bsxfun(@rdivide,bsxfun(@minus,X(:,[3,2]),minn),maxx-minn);
    X(:,[3,2]) = bsxfun(@times, X(:,[3,2]), [Xlim(2),Ylim(2)]);
    X(:,2) = Ylim(2) - X(:,2);
end


XX =  X(:,[2,3]);
weights = param.weight;
nodeSize = (weights+1);
nodeSize = 50 + 1000*(nodeSize - min(nodeSize))/(max(nodeSize)-min(nodeSize));
XX(:,3) = nodeSize;
XX = sortrows(XX,3);
for i = 1:size(XX,1)
    scatter(XX(i,2),XX(i,1),XX(i,3),...
        'MarkerFaceColor','auto',...
        'MarkerEdgeColor',[0 0 0],...%[0 0.4470 0.7410],...
        'LineWidth',2);
end

hold off;