 function [Category,Rate] =  RemoveIndFromRate(ind, Category,Rate)
    Category(ind) = [];
    Rate(:,ind) = [];
    
    Rate = bsxfun(@rdivide, Rate, sum(Rate,2));
    Rate(isnan(Rate)) = 0;
    
 end