function drawMultiLines(CellX, CellY, legend_str, Xlabel, Ylabel)
    figure;
    hold on;
    len = length(CellX);
    symbols = {'o-','s-','^-','*-','p-','d-','+-'};
    
    for i = 1:len
        x = CellX{i};
        y = CellY{i};
        h = plot(x, y, symbols{i}, 'LineWidth',2,'MarkerSize',10);
        
    end
    hold off;
    
    ll = legend(legend_str,'FontName','Times New Roman');
    % set(ll,'FontName','Times New Roman');
    
    set(ll,'FontSize',22);
%     set(ll,'Interpreter', 'LaTeX');
    set(gca,'FontSize',19);
    xlabel(Xlabel,'fontsize',25,'fontname','Times New Roman','Interpreter', 'LaTeX');
    ylabel(Ylabel,'fontsize',25,'fontname','Times New Roman','Interpreter', 'LaTeX');

    a = gca;
    set(a,'FontName','Times New Roman');
    set(a,'Xlim',[x(1),x(end)]);
    box on;
    f = gcf;
    f.InnerPosition=[180 200 541 504];
    f.OuterPosition=[180 200 541 577];

end