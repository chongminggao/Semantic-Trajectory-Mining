function drawErrorAgaistUpdateNumber(error_merge, error_truncate)

    color = lines(5);
    
    h = {};
    g = {};

    figure
    hold on;
    
    [h{1},g{1}] = drawConfidentialInterval((error_merge),color(1,:),'o');
    [h{2},g{2}] = drawConfidentialInterval((error_truncate),color(2,:),'s');
    
    hold off;

    set(gca,'FontSize',16);
    set(gca,'FontName','Times New Roman');
    xlabel('Number of Updated Trajectories', 'fontsize',23,'fontname','Times New Roman', 'Interpreter', 'LaTeX');
    ylabel('Representative Error (m)','fontsize',23,'fontname','Times New Roman','Interpreter', 'LaTeX');
    
    a = gca;
    aa = xlim;
    aa(1) = 1;
    aa(2) = min(length(error_merge),length(error_truncate)) - 1;
    set(a,'Xlim',aa);
    

    box on;
    ll = legend([h{1} h{2}],{'Trajectory Merge','Trajectory Split'},'FontSize',18,'FontName','Times New Roman');

end




function [h,g] =  drawConfidentialInterval(errorCell,color,marker)
% meanv = mean(errorCell);

len = length(errorCell);
ratio = 0.7;

stdd = zeros(1,len);
meanv = zeros(1,len);

for i = 1:len
    vector = errorCell{i};
    stdd(i) = std(vector);
    meanv(i) = mean(errorCell{i});
end

lower =  meanv - stdd;
upper =  meanv + stdd;

len = length(meanv);

% 
% if nargin < 4 % for debug
%     lower = - rand(1, len) * 0.1;
%     upper = rand(1, len) * 0.1;
%     lower = max(0, meanv + lower);
%     upper = min(1, meanv + upper);
% end

x = 1:len;
h = plot(x,meanv,'LineWidth',2,'Color',color,'Marker',marker,'MarkerSize',8);
g = fill([x fliplr(x)],[upper fliplr(lower)],color,'FaceAlpha',0.15);
% errorbar(x,NDCGK,upper)
% errorbar(x,NDCGK,0.1*ones(size(NDCGK)))


end