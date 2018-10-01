function [latLong_new, Index] = Squish(latLong, Times, ErrorBound)

    num = size(latLong,1);
    Index = 1:num;
    Index = Index(:);
    if num <= 2
        latLong_new = latLong;
        return;
    end

    latLong_new = latLong;
    EV = inf(size(latLong,1),1);
    
    for i = 2:num - 1
        pa = latLong(i-1,:);
        pb = latLong(i,:);
        pc = latLong(i+1,:);
        ta = Times(i-1);
        tb = Times(i);
        tc = Times(i+1);
        Dist = calculateSEDError(pa, pb, pc, ta, tb, tc);
        EV(i) = Dist;
    end
    
    [v,ind] = min(EV);
    while v < ErrorBound %&& length(EV) > 2
        EV(ind + 1) = EV(ind + 1) + v;
        EV(ind - 1) = EV(ind - 1) + v;
        EV(ind) = [];
        latLong_new(ind,:) = [];
        Index(ind) = [];
        [v,ind] = min(EV);
    end
end



function Dist = calculateSEDError(pa, pb, pc, ta, tb, tc)
    ratios = DerivetimeRatio(ta,tc,tb);
    P_should = ObtainSEDPosition(pa,pc,ratios);
    Dist = distanceBetweenAB(pb, P_should);
end