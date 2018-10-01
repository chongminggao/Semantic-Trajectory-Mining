function numberVec = countIntersect(mat)

numberOfTra = size(mat,2) + 1;
count = zeros(numberOfTra,1);
iter = size(mat,1);
numberVec = zeros(numberOfTra - 1,1);

last = 0;
for i = 1:numberOfTra-1
    count(mat(:,i)) = count(mat(:,i)) + 1;
    bingo = sum(count(mat(:,i)) == iter);
    numberVec(i) = last + bingo;
    last = numberVec(i);
end

end
