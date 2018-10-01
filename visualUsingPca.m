function visualUsingPca(SPEmbeddedVector,SP_pairs, param)
coeff = pca(SPEmbeddedVector);
mainComponents = coeff(:,1:3);

newrepresentation = SPEmbeddedVector * mainComponents;

minn = min(newrepresentation);
maxx = max(newrepresentation);

color = bsxfun(@rdivide,bsxfun(@minus,newrepresentation,minn),maxx - minn);

h = figure;
if isfield(param,'img') 
    img = imread(param.img);
    hi = imshow(img);
    isRescale = true;
    set(hi,'AlphaData',0.3);
end
hold on;

param.isNodeColor = 2;
param.color = color;

heatMapVisualization(SP_pairs,param,isRescale);
hold off;
end