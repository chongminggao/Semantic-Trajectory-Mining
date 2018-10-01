function X = Denormalization(X,numberOfPartition,Xkeys,param)
maxX = max(X);
minX = min(X);

if isfield(param,'axisRange')
    if maxX <= param.axisRange([4,2])
        maxX = param.axisRange([4,2]);
    end
    if minX >= param.axisRange([3,1])
        minX = param.axisRange([3,1]);
    end
end

X = minX + (maxX-minX)/numberOfPartition .* Xkeys;
end
