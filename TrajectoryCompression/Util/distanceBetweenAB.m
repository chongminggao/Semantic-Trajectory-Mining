function distt = distanceBetweenAB(a, b)
    a = a(:);
    b = b(:);
    dismat = dist([a b]);
    distt = dismat(1,2);
end