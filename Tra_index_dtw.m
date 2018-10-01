function distance = Tra_index_dtw(a,b,SPdistMat)

n = size(a,1);
m = size(b,1);
dis = zeros(n,m);

for i = 1:n
    for j = 1:m
        cost = SPdistMat(a(i),b(j));
        
        if i == 1
            down = inf;
            downleft = inf;
        else
            down = dis(i-1,j);
        end
        
        if j == 1
            left = inf;
            downleft = inf;
            if i == 1
                downleft = 0;
            end
        else
            left = dis(i,j-1);
            if i ~= 1
                downleft = dis(i-1,j-1);
            end
        end
        
        dis(i,j) = cost + min([left, down, downleft]);
    end
end
    
distance = dis(n,m);

end