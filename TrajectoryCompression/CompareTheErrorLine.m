function [a,f] = CompareTheErrorLine(latLong,epsilon_meter,result_compare_list)    
    rawPoints = latLong(:,2:3);
    
    len = length(result_compare_list);
    
    symbols = {'o-','s-','^-','*-','p-'};
    
    figure;
    hold on;
    for i = 1:len
        result_multi = result_compare_list{i};
        Layer = length(result_multi);
        AllErrorDist = zeros(size(rawPoints,1),Layer);
        for l = 1:Layer
            ROI = result_multi{l}.X;
            CompressedPoints = ROI(result_multi{l}.Map_Original_To_Prototype,:);
            ErrorDist = max(abs(CompressedPoints-rawPoints)')';
            AllErrorDist(:,l) = ErrorDist;
        end
        means = mean(AllErrorDist);
        a = plot(epsilon_meter, means, symbols{i}, 'LineWidth',2,'MarkerSize',10);
    end
    hold off;

    set(gca,'FontSize',15);
    xlabel('Interaction Range $\epsilon$(m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    ylabel('Average Representative Error (m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    f = gcf;
    f.InnerPosition=[205 163 519 485];
    f.OuterPosition=[205 163 519 558];
    box on;
end