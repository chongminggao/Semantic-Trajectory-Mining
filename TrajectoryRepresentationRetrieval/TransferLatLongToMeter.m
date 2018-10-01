function latLong_Meter = TransferLatLongToMeter(param,latLong)
    lat1 = param.axisRange(3);
    long1 = param.axisRange(1);
    lat2 = param.axisRange(4);
    long2 = param.axisRange(2);
    latMedian = (lat1+lat2)/2;
    longMedian = (long1+long2)/2;
    D_upDown = distance(lat1,longMedian,lat2,longMedian);
    D_upDown = D_upDown*6371*1000*2*pi/360;
    D_leftRight = distance(latMedian,long1,latMedian,long2);
    D_leftRight = D_leftRight*6371*1000*2*pi/360;
    
    a = bsxfun(@minus,latLong,[lat1,long1]);
    
    lat_max = lat2-lat1;
    long_max = long2-long1;
    
    b = bsxfun(@rdivide,a,[lat_max,long_max]);
    latLong_Meter = bsxfun(@times,b,[D_upDown,D_leftRight]);
end