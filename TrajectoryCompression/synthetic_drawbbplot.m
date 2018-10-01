function synthetic_drawbbplot(epsilon_meter, result_multi, latLong)
    
    rawPoints = latLong(:,2:3);
    
    Layer = length(result_multi);
    AllErrorDist = zeros(size(rawPoints,1),Layer);
    for l = 1:Layer
        ROI = result_multi{l}.X;
        CompressedPoints = ROI(result_multi{l}.Map_Original_To_Prototype,:);
        ErrorDist = max(abs(CompressedPoints-rawPoints)')';
        AllErrorDist(:,l) = ErrorDist;
    end
    
    
    x = epsilon_meter;
%     Mean = mean(AllErrorDist);
%     Quantile = quantile(AllErrorDist,0.99);
%     % Quantile2 = quantile(AllErrorDist,0.98); 
%     % rate = 0.5;
%     AllErrorDist2 = AllErrorDist;
%     for i = 1:numOfIter
%         x(i) = (i-1) * Step + Initiation;
%         AllErrorDist2(AllErrorDist(:,i) > Quantile(i),i) = Mean(i);
%     %     ind = find(AllErrorDist2(:,i) > Quantile2(i));
%     %     randInd = randperm(length(ind));
%     %     randInd = randInd(1:ceil(length(ind) * rate));
%     %     AllErrorDist2(randInd,i) = Mean(i);
%     end

%     figure
%     a = myboxplot(AllErrorDist2(1:5000000,:),x,'OutlierSize',.1);

    figure
    a = myboxplot(AllErrorDist,x,'OutlierSize',.1);


    set(gca,'FontSize',15);
    xlabel('Interaction Range $\epsilon$(m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    ylabel('Representative Error (m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    f = gcf;
    f.InnerPosition=[205 163 519 485];
    f.OuterPosition=[205 163 519 558];
    box on;
    
end