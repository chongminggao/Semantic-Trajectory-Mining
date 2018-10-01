function X = normalization(X)
maxX = max(X);
minX = min(X);
X = bsxfun(@minus,X,minX);
X = bsxfun(@rdivide,X,maxX-minX);
X = X/2*pi;

