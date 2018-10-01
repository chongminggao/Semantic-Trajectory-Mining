function [cell_Traj_Index,cell_ROI_Time,cell_ROI_Index,ff] = DMKD_Get_STQuery_Result(latLong, visitingTimes, param_multi, result_multi, Ps, Ts,isVisual)

    Layer = length(param_multi);
    cell_Traj_Index = cell(Layer,1);
    cell_ROI_Time = cell(Layer,1);
    cell_ROI_Index = cell(Layer,1);
    
    for i = 1:Layer
        param = param_multi{i};
        result = result_multi{i};
        
%         if ~ isfield(result,'ROI_information')
%             ROI_information = Obtain_ROI_Information(result_multi,latLong,visitingTimes);
%             result.ROI_information = ROI_information;
%         else
            ROI_information = result.ROI_information;
%         end
        
        
        [keyIndex, isInEpsilon] = searchNearestROI(param, result, Ps);
        cell_ROI_Index{i} = keyIndex;
        
        Traj_Index = findCommonTrajectory(ROI_information, keyIndex, Ts);
        
        fprintf('========QueryLayer[%d/%d],Radius[%f],#Traj[%d]===========\n',i,Layer,param.epsilon_meter,length(Traj_Index));
        
        for j = 1 : length(Traj_Index)
            if j == 1
                fprintf('[');
            end
            fprintf('%d, ',Traj_Index(j));
            if j == length(Traj_Index)
                fprintf(']\n');
            end
        end
        
        ROI_Time = zeros(length(Traj_Index),2 * length(keyIndex));
        if ~isempty(Traj_Index)
            
            for jj = 1:length(keyIndex)
                ROIInd = keyIndex(jj);
                time = getROI_TrajectoryTime(ROI_information,ROIInd,Traj_Index);
                ROI_Time(:,jj*2-1:jj*2) = time;
            end
            
            if isVisual
                ff = DMKD_visualizeQueryingTrajectory(latLong,param,Traj_Index);

%                 keypoints = result.X(keyIndex,:);
                keypoints = Ps;
                param.visualQuaryPoints = true;
                visualQuary(latLong,param,keypoints);
            end
        end
        cell_Traj_Index{i} = Traj_Index;
        cell_ROI_Time{i} = ROI_Time;
%         visualizeQueryingTrajectory(latLong,result.latLong_new_representation,result.latLong_using_prototypes_index_reduced,param,1,keyIndex);
    end
    
    
end

function time = getROI_TrajectoryTime(ROI_information,ROIInd,TrajInd)
    oneINFO = ROI_information{ROIInd};
    [~,index,~] = intersect(oneINFO(:,1),TrajInd);
    time = oneINFO(index,2:3);
end


function result = findCommonTrajectory(ROI_information, keyIndex, Ts)
    num = length(ROI_information);
    candidate = cell(length(keyIndex),1);
    for i = 1:length(keyIndex)
        candidate{i} = [];
        Q_ROI = keyIndex(i);
        Q_times = Ts(i,:);
        Traj = ROI_information{Q_ROI};
        for j = 1:size(Traj,1)
            Traj_ind = Traj(j,1);
            RealTime = Traj(j,2:3);
            isOverLap = isOverlapping(Q_times,RealTime);
            if isOverLap
                candidate{i} = [candidate{i};Traj_ind];
            end
        end
    end
    result = getCommenIndex(candidate);
end

function result = getCommenIndex(candidate)
    len = length(candidate);
    result = candidate{1};
    for i = 2:len
        new = candidate{i};
        result = intersect(result,new);
    end
end

function isOverLap = isOverlapping(Ts,RealTime) 
    
    if isInMiddle(RealTime(1),RealTime(2),Ts(1)) ||...
       isInMiddle(RealTime(1),RealTime(2),Ts(2)) ||...
       isInMiddle(Ts(1),Ts(2),RealTime(1))
        isOverLap = true;
    else
        isOverLap = false;
    end


    function isIn = isInMiddle(a,b,p)
        if a <= p && p <= b
            isIn = true;
        else
            isIn = false;
        end
    end
end


function showTheMap(param)
    figure;
    if isfield(param,'img') 
        img = imread(param.img);
        hi = imshow(img);
        set(hi,'AlphaData',0.7);
        Xlim = xlim;
        Ylim = ylim;
        Xlim = [0,Xlim(2)+0.5];
        Ylim = [0,Ylim(2)+0.5];
        isRescale = true;
        axis([Xlim,Ylim]);

        if ~isfield(param,'axisRange')
            error('Please specify the axisRange');
        end
    end
end

