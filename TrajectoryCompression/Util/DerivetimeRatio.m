function ratio = DerivetimeRatio(a, b, x)
   a = transferFromcell2num(a);
   b = transferFromcell2num(b);
   x = transferFromcell2num(x);

   if a > b || x < a
       error('Time Error!');
   end
   
   ratio = (x - a) / (b - a);
   
end


function a = transferFromcell2num(a)
    if iscell(a)
        a = a{1};
    end
end
