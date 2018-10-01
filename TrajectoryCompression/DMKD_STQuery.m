%%

figure;
if isfield(param,'img') 
    img = imread(param.img);
    hi = imshow(img);
    set(hi,'AlphaData',0.7);
    Xlim = xlim;
    Ylim = ylim;
    Xlim = [0,Xlim(2)+0.5];
    Ylim = [0,Ylim(2)+0.5];
    isRescale = true;
    axis([Xlim,Ylim]);

    if ~isfield(param,'axisRange')
        error('Please specify the axisRange');
    end
end
aa = gca;


%% 
for l = 1:Layer
    param = param_multi{l};
    param.epsilon_meter = epsilon_meter(l); 
    param_multi{l} = param;
end

result_multi = Obtain_ROI_Information(result_multi,latLong,visitingTime);



%%

K = 2;

QueryP = zeros(K,2);
for k = 1:K
    p = ginput(1);
    QueryP(k,:) = Pixel2latLong(p, param, aa);
end

QueryT = [0 100000000;0 10000000];

DMKD_Get_STQuery_Result(latLong, visitingTime, param_multi, result_multi, QueryP, QueryT);

%% 

QueryT = [733500 734100;
    0 10000000;
    0 10000000];


QueryP = [39.910969,116.433682; % Beijing Railway Station
    39.914034,116.403984;   % Tiananmen Square
    40.002266,116.397047];  % National Stadium

QueryP = [39.914104,116.40415; % Tiantan Park
    39.929573,116.402996;% Forbidden City
    39.931413,116.395558] % Beihai Park 


QueryP = [39.980337,116.329601; % Zhongguancun
    39.974627,116.438418; % Guangximen
    39.914312,116.442184]; % Jianguomen

QueryT = [733818 733852;
    0 10000000];

QueryP = [39.997363,116.316984; % Peking University
    39.92118,116.365734];  %  Jinrong Street

QueryP = [39.914076,116.417948; %Wangfujing
    39.900941,116.32784]; % Beijing West Railway Stationc


%%


%%
isVisual = true;
[cell_Traj_Index,cell_ROI_Time,cell_ROI_Index] = DMKD_Get_STQuery_Result(latLong, visitingTime, param_multi, result_multi, QueryP, QueryT,isVisual);
%%