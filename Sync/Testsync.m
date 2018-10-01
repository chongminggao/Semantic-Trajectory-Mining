clear all; clc;
X1 = [2+randn(100,1);5+randn(100,1);8+randn(100,1)]; % Generate 1-dimensional data
X = X1;                                      % 1-d data
X = normalization(X);                        % normalizate X to [0,pi/2]
epsilon = 0.05 * pi/2;                       % set epsilon to set the scope of the number of the neighbors
[X_record,rc_record] = Sync(X,epsilon);      % Sync algorithm
visulization(X_record,1);                    % visulization the figure showed the position verse time 


%%
load('data_2d.mat');                         % 1-d data
X = normalization(X);                        % normalizate X to [0,pi/2]
visulization(X,2);
epsilon = 0.05 * pi/2;                       % set epsilon to set the scope of the number of the neighbors
[X_record,rc_record] = Sync(X,epsilon);      % Sync algorithm
visulization(X_record,2);                    % visulization the procedure of the transformation of position over time evolution

