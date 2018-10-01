function Mapping_son_to_parent =  Map_to_Parent(numberOfROIs_SonLayer, Mapping_to_son)
    Mapping_son_to_parent = zeros(numberOfROIs_SonLayer,1);
    values = Mapping_to_son.values;
    for i = 1:length(values)
        thisvalue = values{i};
        Mapping_son_to_parent(thisvalue) = i;
    end
end