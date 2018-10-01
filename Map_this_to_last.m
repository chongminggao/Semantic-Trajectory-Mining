function Mapping_this_last  = Map_this_to_last(this_Map_Prototype_To_Original,last_Map_Original_To_Prototype)
Mapping_this_last = containers.Map('KeyType','int32','ValueType','any');
for i = 1:length(this_Map_Prototype_To_Original)
    Mapping_this_last(i) = unique(last_Map_Original_To_Prototype(this_Map_Prototype_To_Original(i)));
end

end