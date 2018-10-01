function [Category,Rate] = LabelConstructor(SPs, inChina)

Category = {};
Rate = [];

batch = 1;
if inChina % batch request
    batch = 20;
end
    
for i = 1:batch:size(SPs,1)
    start = i;
    endd = min(i+batch-1,size(SPs,1));
    latitude = SPs(start:endd,2);
    longtide = SPs(start:endd,3);
    exitt = true;
    while exitt
        try
            [category,rate] = MapInfoRequest(latitude, longtide, inChina);
            exitt = false;
        catch
            fprintf('Timeout error! try again!\n');
        end
    end
    for j = 1:length(category)
        categoryOne = category{j};
        rateOne = rate{j};
        diffCategory = setdiff(categoryOne,Category,'stable');
        Category = [Category, diffCategory];
        Rate = padarray(Rate,[1,length(diffCategory)],'post');
        [~,ia,ib] = intersect(categoryOne,Category);
        Rate(end,ib) =  rateOne(ia);
        fprintf('The [%d/%d] GPS has labeled\n',start+j-1,size(SPs,1));
    end
end


Rate = bsxfun(@rdivide, Rate, sum(Rate,2));
Rate(isnan(Rate)) = 0;

end

%%
function [category,rate] = MapInfoRequest(latitude, longtide, inChina)

    if inChina % If in China, use Gaode API 
        latLong_str = '';
        for i = 1:size(latitude,1)
            latstr = num2str(latitude(i));
            longstr = num2str(longtide(i));
            latLong_str = strjoin({latLong_str,longstr,',',latstr,'|'},'');
        end
        [category,rate] =  GaodeAPI(latLong_str);
    else
        latstr = num2str(latitude);
        longstr = num2str(longtide);
        latLong_str = strjoin({longstr,latstr},',');
        [category,rate] =  MapboxAPI(latLong_str);
        category = {category};
        rate = {rate};
    end

    
end


function [category,rate] =  BaiduAPI(latLong_str)
    import matlab.net.*
    import matlab.net.http.*
    ak = 'sbPcs1Tv41thbeokjelsjVjYdB0dOdbl';
    r = RequestMessage;
    latLong_str = '39.985672,116.349822';
%     latLong_str = '41.147261,-8.608166';


%     nearby = '&radius=1000&scope=2';
%        url = strjoin({'http://api.map.baidu.com/place/v2/search?query=æ∆µÍ$ΩÃ”˝≈‡—µ&location=',...

        url = strjoin({'http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location=',...
        latLong_str,...
        '&pois=1&output=json&ak=',ak},'');

    uri = URI(url);
    resp = send(r,uri);
    % status = resp.StatusCode

    text = resp.Body.Data;
    text = char(text);

    expression = '\(.*\)';
    [start,endd] = regexp(text,expression);

    text = text(start+1:endd-1);
    json = jsondecode(text);
    
    pois = json.result.pois;
    if isempty(pois)
        category = {};
        rate = [];
        return;
    end
    
    tag_cell = [];
    for i = 1:length(pois)
%        tags = pois(i).tag;
       tags = pois(i).poiType;
       tag = strsplit(tags,';');
       tag = strip(tag);
       tag_cell = [tag_cell,tag];
    end
    [category,~,count] = unique(tag_cell);
    tabulateresult = tabulate(count);
    rate = tabulateresult(:,3);
end

%% 
function [category,rate] =  GaodeAPI(latLong_str)
    import matlab.net.*
    import matlab.net.http.*
    ak = '1f9f9506c1d37080f7a039787cae0c9b';
    r = RequestMessage;
%     latLong_str = '116.349822,39.985672';
    radius = '3000';
    
    url = strjoin({'http://restapi.amap.com/v3/geocode/regeo?output=json&location=',...
       latLong_str,'&batch=true','&key=', ak, '&radius=', radius, '&extensions=all'},'');

    uri = URI(url);
    resp = send(r,uri);
    % status = resp.StatusCode

    if isfield(resp.Body.Data,'regeocode')
        pois = resp.Body.Data.regeocode.pois;
        [category_one,rate_one] = getOneSetOfPOIsCategories(pois);
        category{1} = category_one;
        rate{1} = rate_one;
    elseif isfield(resp.Body.Data,'regeocodes')
        category = cell(length(resp.Body.Data.regeocodes),1);
        rate = cell(length(resp.Body.Data.regeocodes),1);
        for kk = 1:length(resp.Body.Data.regeocodes)
            pois = resp.Body.Data.regeocodes(kk).pois;
            [category_one,rate_one] = getOneSetOfPOIsCategories(pois);
            category{kk,:} = category_one;
            rate{kk,:} = rate_one;
        end
    else
        error('Non-exist field!');
    end
    
    function [category,rate] = getOneSetOfPOIsCategories(pois)
        tag_cell = [];
        for i = 1:length(pois)
    %        tags = pois(i).tag;
           tags = pois(i).type;
           tag = strsplit(tags,';');
           tag = strip(tag);
           tag = tag(1);
           tag_cell = [tag_cell,tag];
        end
        [category,~,count] = unique(tag_cell);
        tabulateresult = tabulate(count);
        rate = tabulateresult(:,3);
    end
    
end




%% If not In China, use Mapbox API
function [category,rate] =  MapboxAPI(latLong_str)
    import matlab.net.*
    import matlab.net.http.*
    ak_mapbox = 'pk.eyJ1IjoiZWFnZXJtaW5nIiwiYSI6ImNqYWR6bm00bDBxNG8zMnBiOWwzaHM3dHgifQ.QMCrf3Vq8a4jd7QVgY32ZQ';
    r = RequestMessage;
    % latLong_str = '116.349822,39.985672';
%     latLong_str = '-8.608166,41.147261';
    
    

    url = strjoin({'https://api.mapbox.com/geocoding/v5/mapbox.places/',...
        latLong_str, ...
        '.json?types=poi&limit=5&access_token=',ak_mapbox},'');

    uri = URI(url);
    resp = send(r,uri);
    % status = resp.StatusCode

    text = resp.Body.Data;
    text = char(text);

    json = jsondecode(text);
    
    feat = json.features;
    
    if isempty(feat)
        category = {};
        rate = [];
        return;
    end
    
    tag_cell = [];
    for i = 1:length(feat)
        cate = feat(i).properties.category;
        tag = strsplit(cate,',');
        tag = strip(tag);
        tag_cell = [tag_cell,tag];
    end
    [category,~,count] = unique(tag_cell);
    tabulateresult = tabulate(count);
    rate = tabulateresult(:,3);
    
end


