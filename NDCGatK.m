function [NDCGK] = NDCGatK(pos, ranky)
%pos: predicted y vector's order:
%ranky: true ranky vector: the higher ranky, the more relevant, the better

pos = pos(:)';
ranky = ranky(:)';
sortedRank = sort(ranky,'descend');

predictedRanky = ranky(pos);

nominator = (2 .^ predictedRanky - 1)./ log((1:length(ranky)) + 1);
denominator =  (2 .^ sortedRank - 1) ./ log((1:length(ranky)) + 1);

NDCGK = cumsum(nominator) ./ cumsum(denominator);


% 
% value_record = zeros(length(ranky),1);
% for i = length(ranky):-1:1
%     nominator(pos > i) = [];
%     denominator(pos > i) = [];%strictly, this pos should be (1:length(ranky))'
%     pos(pos>i) = [];
%     value_record(i) = sum(nominator()) / sum(denominator);
% end
% figure
% plot(1:length(ranky),value_record);
% hold off;
% value = value_record(k);

end