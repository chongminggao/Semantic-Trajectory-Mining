function  [idxc, minDist]= findAnalogueC(X,idxa,idxb,idxd,k)
% output c = d + (a-b)
a = X(idxa,:);
b = X(idxb,:);
d = X(idxd,:);

differVector = (d + (a - b))';
matDiffer = dist(X, differVector);
matDiffer = [(1:length(matDiffer))',matDiffer];

result = sortrows(matDiffer,2);

idxc = result(1:k,1);
minDist = result(1:k,2); 


end