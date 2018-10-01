function [ X,rc_record ] = Sync(X, epsilon)
rc_previous = 0;
rc_record = [];
dimension = size(X,2);
while (1)
    if(dimension == 1)              %这样的目的是因为X为一个随时间流逝的的矩阵，若是一维数据，则X的第二维为时间，若为高维数据，则矩阵的第三维X(:,:,i)为时间i-1的数据
        nowX = X(:,end);            %得到最新时间的一维数据
    else
        nowX = X(:,:,end);          %得到最新时间的二维及二维以上数据
    end
    [idx,distance] = getinx(nowX, epsilon);
    X_new =nowX;
    rc = 0;
    for i = 1:size(nowX,1)
        idxnow = idx{i};
        for j = 1:length(idxnow)
            for k = 1:size(nowX,2)
                X_new(i,k) = X_new(i,k) + sin(nowX(idxnow(j),k) - nowX(i,k))/length(idxnow);
            end
            rc = rc + exp(-distance(i,idxnow(j)))/length(idxnow);
        end
    end
    rc = rc/size(nowX,1);

    if(rc - rc_previous <= 0.0001)
        break;
    end
    rc_record = [rc_record ,rc];
    rc_previous = rc;
    if(dimension == 1)
        X = [X X_new];
    else
        X(:,:,end+1) = X_new;
    end
end
end

function [idx,distance] = getinx(X,epsilon)%得到与一个cell数组，如idx(i)=[3 4 5]表示第i个节点epsilon领域内的点有3 4 5。
    if(size(X,2) == 1)
        X = [X,zeros(size(X))];
    end
    X = X';
    distance = dist(X);
    idx = cell(size(distance,1),1);
    for i =1:size(distance,1)
        for j = 1:size(distance,2)
            if(i ~=j && distance(i,j)<= epsilon )
                idx(i) = {[idx{i},j]};
            end
        end
    end
end