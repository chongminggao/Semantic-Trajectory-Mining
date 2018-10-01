param.visualStyle = 'weightedSP';
param.weight = FastSyncResult.weight;
visualization(SPs,param);

hold on;
% plot(keypoints(:,2),keypoints(:,1),'p','MarkerSize',25,'MarkerFaceColor','[.6 .6 .6]','Color',[0 0 0],'LineWidth',2);
a = gca;
axis(param.axisRange)
axis(gca,'square')
set(a,'XTick',[],'XTickLabel',[]);
set(a,'YTick',[],'YTickLabel',[]);
box on;
a.Position = [0 0 1 1];
a.LineWidth = 4;
f = gcf;
pos =  f.Position;
if pos(4) < pos(3)
    pos(3) = pos(4);
end
f.Position = pos;
hold off;