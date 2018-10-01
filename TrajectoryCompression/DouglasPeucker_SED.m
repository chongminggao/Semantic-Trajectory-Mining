function [result, Index] = DouglasPeucker_SED(Points, Times, Index, epsilon)
% The RamerDouglasPeucker algorithm (RDP) is an algorithm for reducing 
% the number of points in a curve that is approximated by a series of 
% points. The initial form of the algorithm was independently suggested 
% in 1972 by Urs Ramer and 1973 by David Douglas and Thomas Peucker and 
% several others in the following decade. This algorithm is also known 
% under the names DouglasPeucker algorithm, iterative end-point fit 
% algorithm and split-and-merge algorithm. [Source Wikipedia]
%
% Input:
%           Points: List of Points 2xN
%           epsilon: distance dimension, specifies the similarity between
%           the original curve and the approximated (smaller the epsilon,
%           the curves more similar)
% Output:
%           result: List of Points for the approximated curve 2xM (M<=N)    
%           
%
% -------------------------------------------------------
% Code: Reza Ahmadzadeh (2017) 
% -------------------------------------------------------
% -------------------------------------------------------
% Update: Chongming Gao(2018)
% -------------------------------------------------------
% The pendicular distance is replaced by SED distance, in which the 
% temporal information is taking into account



dmax = 0;
edx = size(Points,2);

if edx <= 2
    result = Points;
    return ;
end

for ii = 2:edx-1
    d = SED_Distance(Points(:,ii),Points(:,1),Points(:,edx), Times(ii),Times(1),Times(edx));
    if d > dmax
        idx = ii;
        dmax = d;
    end
end

if dmax > epsilon
    % recursive call
    [recResult1, Index1] = DouglasPeucker_SED(Points(:,1:idx), Times(1:idx), Index(1:idx), epsilon);
    [recResult2, Index2] = DouglasPeucker_SED(Points(:,idx:edx), Times(idx:edx), Index(idx:edx), epsilon);
    result = [recResult1(:,1:size(recResult1,2)-1) recResult2(:,1:size(recResult2,2))];
    Index = [Index1(1:size(recResult1,2)-1);Index2];
else
    result = [Points(:,1) Points(:,edx)];
    Index = [Index(1); Index(edx)];
end
% If max distance is greater than epsilon, recursively simplify
    function d = SED_Distance(Pp, P1, P2, Tp, T1, T2)
        Tp = transferFromcell2num(Tp);
        T1 = transferFromcell2num(T1);
        T2 = transferFromcell2num(T2);
        % find the SED distance between a Point Pp and a line segment between P1, P2.
        ratios = DerivetimeRatio(T1,T2,Tp);
        P_should = ObtainSEDPosition(P1,P2,ratios);
        d = distanceBetweenAB(Pp, P_should);
        
%         d = abs((P2(2,1)-P1(2,1))*Pp(1,1) - (P2(1,1)-P1(1,1))*Pp(2,1) + P2(1,1)*P1(2,1) - P2(2,1)*P1(1,1)) ...
%             / sqrt((P2(2,1)-P1(2,1))^2 + (P2(1,1)-P1(1,1))^2);
    end

    function a = transferFromcell2num(a)
        if iscell(a)
            a = a{1};
        end
    end

end