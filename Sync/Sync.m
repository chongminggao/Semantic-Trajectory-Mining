function [ X,rc_record ] = Sync(X, epsilon)
rc_previous = 0;
rc_record = [];
dimension = size(X,2);
while (1)
    if(dimension == 1)              %������Ŀ������ΪXΪһ����ʱ�����ŵĵľ�������һά���ݣ���X�ĵڶ�άΪʱ�䣬��Ϊ��ά���ݣ������ĵ���άX(:,:,i)Ϊʱ��i-1������
        nowX = X(:,end);            %�õ�����ʱ���һά����
    else
        nowX = X(:,:,end);          %�õ�����ʱ��Ķ�ά����ά��������
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

function [idx,distance] = getinx(X,epsilon)%�õ���һ��cell���飬��idx(i)=[3 4 5]��ʾ��i���ڵ�epsilon�����ڵĵ���3 4 5��
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