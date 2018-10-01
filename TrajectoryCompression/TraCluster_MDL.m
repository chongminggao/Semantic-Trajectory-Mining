function  [latLong_new, Index] = TraCluster_MDL(latLong,time,bound)
    num = size(latLong,1);
    Index = 1:num;
    Index = Index(:);
    latLong_new = latLong;
    if num <= 2
        return;
    end
    
    
    a = latLong(1,:);
    b = latLong(2,:);
    cumlen = distanceBetweenAB(a, b);
    
    c1 = latLong(1,:);
    c1_index = 1;
    latLong_new = c1;
    Index = 1;
    
    for i = 3:num
        a_index = i-1;
        a = latLong(a_index,:);
        b = latLong(i,:);
        newlen = distanceBetweenAB(a, b);
        cumlen = cumlen + newlen;
        
        c2 = b;
        cum_err = 0;
        
        for j = c1_index+1:i
            o1 = latLong(j-1,:);
            o2 = latLong(j,:);
            distt = Dist_perpendicular(o1, o2, c1, c2) + Dist_angle(o1, o2, c1, c2);
            cum_err = cum_err + distt;
        end
        
        if cum_err >= cumlen
            c1 = a;
            c1_index = a_index;
            latLong_new = [latLong_new; c1];
            Index = [Index; c1_index];
            cumlen = newlen;
        end
        
    end
    latLong_new = [latLong_new; c2];
    Index = [Index;num];

end


function distt = Dist_perpendicular(o1, o2, c1, c2)
    d1 = penDistance(o1, c1, c2);
    d2 = penDistance(o2, c1, c2);
    distt = (d1^2 + d2^2) / (d1 + d2);
end


function distt = Dist_angle(o1, o2, c1, c2)
    oo = o1 + (c2 - c1);
    distt = penDistance(o2,o1,oo);
end




function d = penDistance(Pp, P1, P2)
    % find the distance between a Point Pp and a line segment between P1, P2.
    d = abs((P2(2)-P1(2))*Pp(1) - (P2(1)-P1(1))*Pp(2) + P2(1)*P1(2) - P2(2)*P1(1)) ...
        / sqrt((P2(2)-P1(2))^2 + (P2(1)-P1(1))^2);
end


function distt = distanceBetweenAB(a, b)
    a = a(:);
    b = b(:);
    dismat = dist([a b]);
    distt = dismat(1,2);
end