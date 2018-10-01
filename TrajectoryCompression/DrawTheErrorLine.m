function a = DrawTheErrorLine(latLong,result_multi,epsilon_meter)
    Layer = length(result_multi);
    rawPoints = latLong(:,2:3);

    AllErrorDist = zeros(size(rawPoints,1),Layer);

    for l = 1:Layer
        ROI = result_multi{l}.X;
        CompressedPoints = ROI(result_multi{l}.Map_Original_To_Prototype,:);
        ErrorDist = max(abs(CompressedPoints-rawPoints)')';
        AllErrorDist(:,l) = ErrorDist;
    end

    figure
    a = myboxplot(AllErrorDist,epsilon_meter,'OutlierSize',.1);

    set(gca,'FontSize',15);
    xlabel('Interaction Range $\epsilon$(m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    ylabel('Representative Error (m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    f = gcf;
    f.InnerPosition=[205 163 519 485];
    f.OuterPosition=[205 163 519 558];
    box on;
end