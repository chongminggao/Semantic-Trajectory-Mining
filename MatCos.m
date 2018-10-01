function S = MatCos(X,Y)
    
numerator = X * Y';

SX = sqrt(sum(X.^2, 2));
SY = sqrt(sum(Y.^2, 2));

Denumerator = SX * SY';

S = numerator ./ Denumerator;

end
 
 
 