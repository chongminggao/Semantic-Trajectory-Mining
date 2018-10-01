function idx = spectral_clustering(W, k)
    D = diag(sum(W));
    L = D-W;
 
    opt = struct('issym', true, 'isreal', true);
    [V,~] = eigs(L, D, k, 'SM', opt);
 
    idx = kmeans(V, k);
end