function  result = TraEDR(x1,x2,tol,SPdistMat)
cnd = zeros(length(x1),length(x2));

for i = 1:length(x1)
    for j = 1:length(x2)
        cnd(i,j) = abs(SPdistMat(x1(i),x2(j))) > tol;
    end
end
D = zeros(length(x1)+1,length(x2)+1);
D(1,2:end) = 1:length(x2);
D(2:end,1) = 1:length(x1);

for h = 2:length(x1)+1
    for k = 2:length(x2)+1
        D(h,k) = min([D(h-1,k)+1 ...
            D(h,k-1)+1 ...
            D(h-1,k-1)+cnd(h-1,k-1)]);
    end
end

result = D(end,end);