function KeyPointsIndex = SyntheticKeyPointSearcher(latLong_using_prototypes_index,numbofKeyPoints)

[~, index] = unique(latLong_using_prototypes_index(:,1),'stable');


KeyPointsIndex = zeros(numbofKeyPoints,1);
for i = 1:numbofKeyPoints
    ind = index(i);
    KeyPointsIndex(i) = latLong_using_prototypes_index(ind,2); 
end
