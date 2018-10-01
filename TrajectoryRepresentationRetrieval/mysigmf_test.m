x = linspace(-6,6,1e3 + 1);
for itr = 1e3+1:-1:1
    y(itr) = mysigmf( x(itr) );
end
plot( x, y );