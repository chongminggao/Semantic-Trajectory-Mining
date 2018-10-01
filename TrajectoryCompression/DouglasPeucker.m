function [result, Index] = DouglasPeucker(Points,Index,epsilon)
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



dmax = 0;
edx = size(Points,2);

if edx <= 2
    result = Points;
    return ;
end


for ii = 2:edx-1
    d = penDistance(Points(:,ii),Points(:,1),Points(:,edx));
    if d > dmax
        idx = ii;
        dmax = d;
    end
end

if dmax > epsilon
    % recursive call
    [recResult1, Index1] = DouglasPeucker(Points(:,1:idx), Index(1:idx), epsilon);
    [recResult2, Index2] = DouglasPeucker(Points(:,idx:edx), Index(idx:edx), epsilon);
    result = [recResult1(:,1:size(recResult1,2)-1) recResult2(:,1:size(recResult2,2))];
    Index = [Index1(1:size(recResult1,2)-1);Index2];
else
    result = [Points(:,1) Points(:,edx)];
    Index = [Index(1); Index(edx)];
end
% If max distance is greater than epsilon, recursively simplify
    function d = penDistance(Pp, P1, P2)
        % find the distance between a Point Pp and a line segment between P1, P2.
        d = abs((P2(2,1)-P1(2,1))*Pp(1,1) - (P2(1,1)-P1(1,1))*Pp(2,1) + P2(1,1)*P1(2,1) - P2(2,1)*P1(1,1)) ...
            / sqrt((P2(2,1)-P1(2,1))^2 + (P2(1,1)-P1(1,1))^2);
    end
end