function [type3Neighorhoods, type4Neighorhoods] =  ROITimeCount(latLong,Map_Original_To_Prototype, visitingTime,TotalROI,bin,type3,type4)
    
    visitingTime = datenum(visitingTime);
    
    
    [index_of_trajectory, pointer_start] = unique(latLong(:,1),'stable');
    numberOfTrajectories = length(index_of_trajectory);
    pointer_start = [pointer_start;size(latLong,1) + 1];
    
    ROI_Staying_Set = cell(TotalROI,1);
    ROI_visting_bin = zeros(TotalROI,24);
    
    for i = 1:numberOfTrajectories
        if mod(i,100) == 0
            fprintf('The [%d]/[%d] trajectory is processing...\n',i,numberOfTrajectories);
        end
        oneTrajectory = Map_Original_To_Prototype(pointer_start(i):pointer_start(i+1)-1);
        oneVisitingTime = visitingTime(pointer_start(i):pointer_start(i+1)-1);
        nowwROI = 0;
%         profile on;
        for j = 1:length(oneTrajectory)
            newwROI = oneTrajectory(j);
            if newwROI ~= nowwROI 
                if j > 1
                    endlastROITIme = oneVisitingTime(j);
                    stayingLastROITime = endlastROITIme - startThisROITime;
                    if stayingLastROITime > 0
                        ROI_Staying_Set{nowwROI} = [ROI_Staying_Set{nowwROI},stayingLastROITime];
                    end
                end
                startThisROITime = oneVisitingTime(j);
                nowwROI = newwROI;
            end
            Time = oneVisitingTime(j);
            if ~isnan(Time)
                Hour = ceil(mod(Time,1)*24);
                Hour = max(1,Hour);
                ROI_visting_bin(newwROI,Hour) = ROI_visting_bin(newwROI,Hour) + 1;
            end
        end
%         profile off;
%         profile viewer;
        lastStayingTime = oneVisitingTime(length(oneTrajectory))-startThisROITime;
        if lastStayingTime > 0
            ROI_Staying_Set{nowwROI} = [ROI_Staying_Set{nowwROI},lastStayingTime];
        end
    end
    
    
    %% 
    StayingtimeCount = [];
    for i = 1:length(ROI_Staying_Set)
        AllStayingRecords = seconds(days(ROI_Staying_Set{i}));
        StayingtimeCount = [StayingtimeCount,AllStayingRecords];
    end
    InteruptPoint = quantile(StayingtimeCount,0.97);
    lengthOne = InteruptPoint / bin;
    
    ROI_Staying_Bin = zeros(length(ROI_Staying_Set),bin);
    
    
    for i = 1:length(ROI_Staying_Set)
        AllStayingRecords = seconds(days(ROI_Staying_Set{i}));
        AllStayingRecords(AllStayingRecords > InteruptPoint)  = InteruptPoint;
        for j = 1:length(AllStayingRecords)
            oneTime = AllStayingRecords(j);
            onebin  = min(floor(oneTime/lengthOne) + 1, bin);
            ROI_Staying_Bin(i,onebin) = ROI_Staying_Bin(i,onebin) + 1;
        end
    end
    
    ROI_visting_bin = bsxfun(@rdivide, ROI_visting_bin, sum(ROI_visting_bin,2));
    ROI_visting_bin(isnan(ROI_visting_bin)) = 0;
    
    ROI_Staying_Bin = bsxfun(@rdivide, ROI_Staying_Bin, sum(ROI_Staying_Bin,2));
    ROI_Staying_Bin(isnan(ROI_Staying_Bin)) = 0;
    
    visitingTimeSimilarMat =  zeros(TotalROI);
    stayingTimeSimilarMat = zeros(TotalROI);
    
    for i = 1:size(ROI_visting_bin,1) - 1 
        for j = i+1:size(ROI_visting_bin,1)
            visitingTimeSimilarMat(i,j) = sum(min([ROI_visting_bin(i,:);ROI_visting_bin(j,:)]));
            visitingTimeSimilarMat(j,i) = sum(min([ROI_visting_bin(i,:);ROI_visting_bin(j,:)]));
            stayingTimeSimilarMat(i,j) = sum(min([ROI_Staying_Bin(i,:);ROI_Staying_Bin(j,:)]));
            stayingTimeSimilarMat(j,i) = sum(min([ROI_Staying_Bin(i,:);ROI_Staying_Bin(j,:)]));
        end
    end
%     for i = 1:size(ROI_visting_bin,1)
%         visitingTimeSimilarMat(i,i) = 1;
%         stayingTimeSimilarMat(i,i) = 1;
%     end
    
    type3Neighorhoods = zeros(size(ROI_visting_bin,1),type3);
    type4Neighorhoods = zeros(size(ROI_visting_bin,1),type4);
    for i = 1:size(ROI_visting_bin,1)
        [~,index]  = sort(visitingTimeSimilarMat(i,:),'descend');
        type3Neighorhoods(i,:) = index(1:type3);
        [~,index]  = sort(stayingTimeSimilarMat(i,:),'descend');
        type4Neighorhoods(i,:)= index(1:type3);
    end

    
    
end