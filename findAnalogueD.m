function [idxd,minDist]= findAnalogueD(X,idxa,idxb,idxc,k)
% output d = c + (a-b)
a = X(idxa,:);
b = X(idxb,:);
c = X(idxc,:);

differVector = (c - (a - b))';
matDiffer = dist(X, differVector);
matDiffer = [(1:length(matDiffer))',matDiffer];

result = sortrows(matDiffer,2);

idxd = result(1:k,1);
minDist = result(1:k,2); 


end