% a = SPs(FastSyncResult.Map_Original_To_Prototype,:);
% dist = latLong(:,2:3) - a(:,2:3);
% % maxx = max(abs(dist));
% 
% 
% lat1 = param.axisRange(3);
% long1 = param.axisRange(1);
% lat2 = param.axisRange(4);
% long2 = param.axisRange(2);
% latMedian = (lat1+lat2)/2;
% longMedian = (long1+long2)/2;
% D_upDown = distance(lat1,longMedian,lat2,longMedian);
% D_upDown = D_upDown*6371*1000*2*pi/360;
% D_leftRight = distance(latMedian,long1,latMedian,long2);
% D_leftRight = D_leftRight*6371*1000*2*pi/360;
% D_mean = (D_upDown + D_leftRight)/2;
% 
% lat_median = (param.axisRange(3) + param.axisRange(4))/2;
% long_median = (param.axisRange(1) + param.axisRange(2))/2;
% delta_lat = param.epsilon / (pi/2) * (param.axisRange(4) - param.axisRange(3));
% delta_long = param.epsilon / (pi/2) * (param.axisRange(2) - param.axisRange(1));
% D1 = distance(lat_median,long_median,lat_median,long_median+delta_long);
% D2 = distance(lat_median,long_median,lat_median+delta_lat,long_median);
% byMeter1 = D1*6371*1000*2*pi/360;
% byMeter2 = D2*6371*1000*2*pi/360;
% byMeter = mean([byMeter1,byMeter2]);
% 
% 
% eps_real = param.epsilon * [param.axisRange(4)-param.axisRange(3), param.axisRange(2)-param.axisRange(1)]
% 
% b = abs(dist);
% length(find(sum(b <= eps_real * 2,2) == 2))/size(b,1)
% 
% 
% 




%% Test DouglasPeucker algorithm 
% The RamerDouglasPeucker algorithm (RDP) is an algorithm for reducing 
% the number of points in a curve that is approximated by a series of 
% points. The initial form of the algorithm was independently suggested 
% in 1972 by Urs Ramer and 1973 by David Douglas and Thomas Peucker and 
% several others in the following decade. This algorithm is also known 
% under the names DouglasPeucker algorithm, iterative end-point fit 
% algorithm and split-and-merge algorithm. [Source Wikipedia]
%
%
% -------------------------------------------------------
% Code: Reza Ahmadzadeh (2017) 
% -------------------------------------------------------

Points = [1 2 3 4 5 6 7 8;
 3 2.3 1 2.1 2.2 2 1.5 3.2];

figure;
ii = 1;
subplot(2,3,ii);hold on
plot(Points(1,:),Points(2,:),'-or');
title('initial points');
grid on;box on;axis([1 8 0.5 3.5]);

for ErrorBound = [0.1 0.5 1.0 .8 .7]
    res = DouglasPeucker(Points,ErrorBound);
    res = DeadReckoning(Points',ErrorBound)';
    ii = ii + 1;
    subplot(2,3,ii);hold on
    plot(Points(1,:),Points(2,:),'--or');
    plot(res(1,:),res(2,:),'-xb');
    title(['ErrorBound = ' num2str(ErrorBound)]);
    grid on;box on;axis([1 8 0.5 3.5]);
    legend('original','approximated')
end
