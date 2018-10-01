function [h,g] = drawNDCG(NDCGK,NDCGK_DTW,NDCGK_Frechet,NDCGK_LCS,NDCGK_EDR,visualK)
figure
hold on;

color = lines(5);

NDCGK = NDCGK(:,1:visualK);
NDCGK_DTW = NDCGK_DTW(:,1:visualK);
NDCGK_Frechet = NDCGK_Frechet(:,1:visualK);
NDCGK_LCS = NDCGK_LCS(:,1:visualK);
NDCGK_EDR = NDCGK_EDR(:,1:visualK);

h = {};
g = {};

[h{1},g{1}] = drawConfidentialInterval((NDCGK),color(1,:),'o');
[h{2},g{2}] = drawConfidentialInterval((NDCGK_DTW),color(2,:),'p');
[h{3},g{3}] = drawConfidentialInterval((NDCGK_Frechet),color(3,:),'s');
[h{4},g{4}] = drawConfidentialInterval((NDCGK_LCS),color(4,:),'*');
[h{5},g{5}] = drawConfidentialInterval((NDCGK_EDR),color(5,:),'d');

a = gca;
aa = xlim;
aa(1) = 1;
aa(2) = visualK;
set(a,'Xlim',aa);
set(a,'Ylim',[0,1]);
hold off;

set(gca,'FontSize',15);
xlabel('$K$','fontsize',20,'fontname','Times New Roman','Interpreter', 'LaTeX');
ylabel('$NDCG@K$','fontsize',20,'fontname','Times New Roman','Interpreter', 'LaTeX');

box on;

ll = legend([h{1} h{2} h{3} h{4} h{5}],{'Semantic Retrieval','DTW','Frechet','LCS','EDR'},'FontSize',18,'FontName','Times New Roman');
% ll = legend({'Number of SPs','MSE'},'FontSize',23);

end



function [h,g] =  drawConfidentialInterval(NDCGK,color,marker)
meanv = mean(NDCGK);
stdd = std(NDCGK) * 0.7;
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