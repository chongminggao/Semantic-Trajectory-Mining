function X = normalization(X,param)


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

X = bsxfun(@minus,X,minX);
X = bsxfun(@rdivide,X,maxX-minX);
X = X/2*pi;
