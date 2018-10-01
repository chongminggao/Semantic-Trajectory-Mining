function distanceMat = transfer_latLongPair_to_meter(A,B)
n = size(A,1);
m = size(B,1);
distanceMat = zeros(n,m);
for i = 1:n
    lata = A(i,1);
    longa = A(i,2);
    for j = 1:m
        latb = B(j,1);
        longb = B(j,2);
        D = distance(lata,longa,latb,longb);
        distanceMat(i,j) = D*6371*1000*2*pi/360;
    end
end

end