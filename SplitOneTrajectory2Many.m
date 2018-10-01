function latLong_new  = SplitOneTrajectory2Many(latLong,Kstep)
latLong_new = zeros(size(latLong,1) * 2, 3);

[index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
numberOfTrajectories = length(index_of_trajectory);

index = 1;
cont = 1;

for k = 1:numberOfTrajectories
    
    if k ~= numberOfTrajectories
        Sequence = latLong(pointer_start(k) : pointer_start(k+1)-1,2:3);
    else
        Sequence = latLong(pointer_start(k) : end,2:3);
    end
    
    num = size(Sequence,1);
    for i = 1:(Kstep-1):num
        if i + (Kstep-1) <= num
            latLong_new(index:index + (Kstep-1),:) = [cont * ones(Kstep,1), Sequence(i:i+(Kstep-1),:)];
        else
            if i == 1
                latLong_new(index:index + num -1 ,:) = [cont * ones(num,1), Sequence];
                cont = cont + 1;
                index = index + num;
                break;
            end
            latLong_new(index:index + (Kstep-1),:) = [cont * ones(Kstep,1), Sequence(num - Kstep+1: num,:)];
            
        end
        index = index + Kstep;
        cont = cont + 1;
    end
end

latLong_new(index:end,:) = [];

end