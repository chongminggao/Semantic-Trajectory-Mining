function KmeansAndVisualization(T,param)

K = param.K;
idx = kmeans(T,K);

SPs = [ones(param.FastSyncResult.numberOfPrototypes,1),param.FastSyncResult.X];


