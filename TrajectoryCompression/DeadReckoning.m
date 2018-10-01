function [latLong_new, Index] = DeadReckoning(latLong, Times, ErrorBound)

num = size(latLong,1);
Index = 1:num;
Index = Index(:);
if num <= 2
    latLong_new = latLong;
    return;
end

latLong_new = zeros(size(latLong));
inda = 1;
indb = inda + 1;
indc = indb + 1;
numCompress = 1;
latLong_new(1,:) = latLong(1,:);
Index = 1;

% figure;
% hold on;
while indc <= num
	pa = latLong(inda,:);
    pb = latLong(indb,:);
    pc = latLong(indc,:);
    ta = Times(inda);
    tb = Times(indb);
    tc = Times(indc);
    
%     plot([pa(1),pb(1)],[pa(2),pb(2)]);
%     pclast = latLong(indc-1,:);
%     plot([pc(1),pclast(1)],[pc(2),pclast(2)]);
    isOk = judge(pa,pb,pc,ta,tb,tc,ErrorBound);
    if isOk
        indc = indc + 1;
    else
        inda = indc - 1;
        numCompress = numCompress + 1;
        latLong_new(numCompress,:) = latLong(inda,:);
        Index = [Index; inda];
        indb = inda + 1;
        indc = indb + 1;
    end
end
numCompress = numCompress + 1;
latLong_new(numCompress,:) = latLong(end,:);
latLong_new(numCompress+1:end,:) = [];
Index = [Index; num];

end


function isOk = judge(p1,p2,p3,ta,tb,tc,ErrorBound)

ratios = DerivetimeRatio(ta,tb,tc);
P_should = ObtainSEDPosition(p1,p2,ratios);
Dist = distanceBetweenAB(p3, P_should);

if Dist <= ErrorBound
    isOk = true;
else
    isOk = false;
end

end


% 
% 
% function isOk = judge(p1,p2,p3,ErrorBound)
% 
% p12 = p1 - p2;
% p32 = p3 - p2;
% if sum(p12.*p32) >= 0
%     isOk = false;
%     return;
% end
% 
% x1 = p1(1); y1 = p1(2);
% x2 = p2(1); y2 = p2(2);
% x3 = p3(1); y3 = p3(2);
% 
% if abs(x1 - x2)<eps
%     Dist = abs(x3 - x1);
% else
%     [k,b] = lineFunction(p1,p2);
%     Dist = abs(x3 * k + b - y3) / ((k^2 + 1)^.5);
% end
% 
% if Dist < ErrorBound
%     isOk = true;
% else
%     isOk = false;
% end
% 
% end



function [k,b] = lineFunction(pa,pb)
    xa = pa(1); ya = pa(2);
    xb = pb(1); yb = pb(2);
    k = (yb - ya)/(xb - xa);
    b = ya - k * xa;
end


