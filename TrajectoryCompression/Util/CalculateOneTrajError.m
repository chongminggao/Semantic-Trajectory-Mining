function [cumError, cumError_SED] = CalculateOneTrajError(latLong, visitingTime, Index)
    cumError = CalculateError(latLong, Index);
    cumError_SED = CalculateError_SED(latLong, visitingTime, Index);
    
end



function cumError = CalculateError_SED(latLong, visitingTime, Index)
    len = length(Index);
    cumError = 0;
    for i =  2:len
        if Index(i) - Index(i-1)>1
            startID = Index(i-1);
            endID = Index(i);
            startP = latLong(startID,:);
            endP = latLong(endID,:);
            startT = visitingTime(startID);
            endT = visitingTime(endID);
            for j = Index(i-1) + 1 : Index(i) - 1
                tempP = latLong(j,:);
                tempT = visitingTime(j);
                ratios = DerivetimeRatio(startT,endT,tempT);
                P_should = ObtainSEDPosition(startP,endP,ratios);
                Dist = distanceBetweenAB(tempP, P_should);
                cumError = cumError + Dist;
            end
        end
    end
end




function cumError = CalculateError(latLong, Index)
    len = length(Index);
    cumError = 0;
    for i =  2:len
        if Index(i) - Index(i-1)>1
            startID = Index(i-1);
            endID = Index(i);
            startP = latLong(startID,:);
            endP = latLong(endID,:);
            for j = Index(i-1) + 1 : Index(i) - 1
                tempP = latLong(j,:);
                Dist = CalculateDistBetweenPointPandLineAB(tempP,startP,endP);
                cumError = cumError + Dist;
            end
        end
    end
end

function d = CalculateDistBetweenPointPandLineAB(P, A, B)
    numerator = abs((B(2)-A(2))*P(1) - (B(1)-A(1))*P(2) + B(1)*A(2) - B(2)*A(1));
    if numerator == 0 
        d = 0;
        return;
    end
    denumerator = sqrt((B(2)-A(2))^2 + (B(1)-A(1))^2);
    d = numerator / denumerator;
end

