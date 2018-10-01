function visulization(X,dimension)
figure;
if(dimension == 1)  %The position verse time on 1 dimensional data
    ax = 0: 1: size(X,2)-1;
    ax = repmat(ax,size(X,1),1);
    colors = hsv(size(X,1));
    for i=1:size(X,2)
        scatter(ax(:,i), X(:,i),10,colors);
        if(i~=1)
            for j = 1:size(X,1)
                hold on
                plot([ax(j,i-1) ax(j,i)], [X(j,i-1) X(j,i)], 'color',colors(j,:));
            end
        end
    end
    set( gca , 'XLim' , [ 0 size(X,2)+1 ] , 'Visible' , 'on' ) ;
end

if(dimension == 2) %The position verse time on 2 dimensional data
    for i= 1:size(X,3)
        scatter(X(:,1,i),X(:,2,i),15,[1 0 0]);
        axis equal;
        set( gca , 'XLim' , [ -0.1 1.65 ] , 'YLim' , [ -0.1 1.65 ] , 'Visible' , 'on' ) ;
        pause(1);
    end
end

end