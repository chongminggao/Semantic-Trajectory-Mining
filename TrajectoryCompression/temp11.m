for iter = 1:numOfIter
    ErrorBound = (iter-1) * Step + Initiation;
    disp('=======2.DR Calculating...============');
    tic;
    TotalDP(iter) = performanceDP([latLong(:,1),latLong_Meter],ErrorBound);
%     TotalDR(iter) = performanceDR([latLong(:,1),latLong_Meter],ErrorBound);
    DRTime = toc;
end