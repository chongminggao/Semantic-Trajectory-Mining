%% Embedding Neighborhood Setting:

fileName = strjoin({'Result_', datasetName,'_',datestr(now)},'');

sigir_fileID = fopen(fileName,'a');
fprintf(sigir_fileID, '\n=============================================\n');
fprintf(sigir_fileID, '==================Time [%s]==================\n',datestr(now));

%%
param.window = 2;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end


%%
param.window = 1;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 3; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 3; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 3; % number of similar degree neighborhoods
param.type2 = 3; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 2;
param.type1 = 3; % number of similar degree neighborhoods
param.type2 = 3; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 3; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 3; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 3; % number of similar visiting time distribution similar neighborhoods
param.type4 = 3; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 2;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 3; % number of similar visiting time distribution similar neighborhoods
param.type4 = 3; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end


%%
param.window = 0;
param.type1 = 2; % number of similar degree neighborhoods
param.type2 = 2; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 2; % number of similar visiting time distribution similar neighborhoods
param.type4 = 2; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 2;
param.type1 = 2; % number of similar degree neighborhoods
param.type2 = 2; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 2; % number of similar visiting time distribution similar neighborhoods
param.type4 = 2; % number of similar staying time distribution similar neighborhoods
param.type5 = 0; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 0;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 3; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 2;
param.type1 = 0; % number of similar degree neighborhoods
param.type2 = 0; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 0; % number of similar visiting time distribution similar neighborhoods
param.type4 = 0; % number of similar staying time distribution similar neighborhoods
param.type5 = 3; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
param.window = 1;
param.type1 = 1; % number of similar degree neighborhoods
param.type2 = 1; % number of similar neighbors' degree distribution neighborhoods
param.type3 = 1; % number of similar visiting time distribution similar neighborhoods
param.type4 = 1; % number of similar staying time distribution similar neighborhoods
param.type5 = 3; % number of Semantic neighborhoods
param.bin = 5;
fprintf(sigir_fileID, 'window = %d;\ntype1 = %d;\ntype2 = %d;\ntype3 = %d;\ntype4 = %d;\ntype5 = %d;\nbin = %d;\n',param.window, param.type1, param.type2, param.type3, param.type4, param.type5, param.bin);


sigir_embedding_with_different_neighbors;

round = 3;
for iter = 1:round
    fprintf(sigir_fileID, '\n==================Round [%d]==================\n',iter);
    sigir_evaluation;
end

%%
fclose(sigir_fileID);

