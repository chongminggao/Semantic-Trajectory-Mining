function [index, isInEpsilon] = searchNearestROI(param, result, Ps)

    [Distance_mean,D_upDown,D_leftRight] = CalculateapDistance(param);
    param.D_upDown = D_upDown;
    param.D_leftRight = D_leftRight;
    
    Ps_meter = latLong2meter(Ps, param);
    ROI_meter = latLong2meter(result.X, param);
    
    [index, distt]= knnsearch(ROI_meter, Ps_meter);
    isInEpsilon = distt <= param.epsilon_meter;
    
end



% function [idx, isInEpsilon] = findOneNearestROI(P, ROIs, epsilon_meter)
%     [idx, distt]= knnsearch(ROIs, Ps);
%     isInEpsilon = distt <= epsilon_meter;
% end



function latLong_meter = latLong2meter(latLong, param)

% ============================
    % (0,0) meter is the bottom left point of the map.
% ============================

    minn = param.axisRange([3,1]);
    maxx = param.axisRange([4,2]);
%     relativeP = (latLongOne - minn)./(maxx-minn);
    relativeP = bsxfun(@rdivide,bsxfun(@minus,latLong,minn),maxx-minn);
    
%     latLong_meter = relativeP .* [param.D_upDown,param.D_leftRight];
    latLong_meter = bsxfun(@times, relativeP, [param.D_upDown,param.D_leftRight]);

end