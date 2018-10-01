pure = latLong(:,[2 3]);
[index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');

summ = 0;
zong = [];

yuzhi = 0.005;

for i = 1:length(index_of_trajectory)
    if i ~= length(index_of_trajectory)
        particular_trajectory = pure(pointer_start(i) : pointer_start(i+1)-1,:);
        if pointer_start(i+1)- pointer_start(i) < 5
            fprintf('length(%d) = %d\n', index_of_trajectory(i), pointer_start(i+1)- pointer_start(i));
        end

        if pointer_start(i+1)- pointer_start(i) == 1
            continue;
        end
    else
        particular_trajectory = pure(pointer_start(i) : end,:);
        if size(pure,1)+1- pointer_start(i) < 5
            fprintf('length(%d) = %d\n', index_of_trajectory(i), size(pure,1)+1- pointer_start(i));
        end

        if size(pure,1)+1- pointer_start(i) == 1
            continue;
        end
        
    end
    
    
    
    difference = diff(particular_trajectory);
    zong = [zong;difference(:)];
    


    
    
%     
    pause = true;
    if abs(difference(:)) < yuzhi
        pause = false;
    else
%         disp('====================');
%         [[1:size(difference,1)]',difference]
%         fprintf('i = %d\n',i);
%         
          figure(10)
          plot(particular_trajectory(:,1),particular_trajectory(:,2));
        
        for ii = 1:size(particular_trajectory,1)
            text(particular_trajectory(ii,1),particular_trajectory(ii,2),num2str(ii),'Color','r')
        end
% 
%         a = [1:size(difference,1)]';
%         a = a(:,[1 1]);
%         a(abs(difference) >=yuzhi)

        
        
        summ = summ +1;
    end
end

figure;
histogram(abs(zong));

prctile(abs(zong),[0 98]);
summ