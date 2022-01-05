function [output2D] = DT_2F(input2D)

[rows, columns]=size(input2D);
output2D=zeros(rows, columns);

width=columns;
height=rows;

%transforming along columns
for i=1:width
    output2D(:, i)=DT_1D(input2D(:,i), 1);
end
% disp('after first pass');
% disp(output2D);

%transforming along rows
for i=1:height
    output2D(i,:)=DT_1D(output2D(i,:), 2);
end
%disp('after second pass');
%disp(output2D);

%checking the diagonal pixels
for x=1:height
    for y=1:width

        if output2D(x,y)<4
            continue;
        else
            radius=sqrt(output2D(x,y))-1;
            

            %optimized for better run time, needs more work though
            for i=max([x-radius, 1]):min([height, x+radius])
                for j=max([y-radius, 1]):min([width, y+radius])

                    if output2D(i,j)==0

                        dx=x-i;
                        dy=y-j;
                        distance=sqrt((dx*dx)+(dy*dy));
                        distance=distance*distance;

                        if output2D(x,y)>distance
                            output2D(x,y)=distance;
                        else 
                            continue;
                        end  
                    end
                end
            end
        end
    end
end

%output2D=uint16(output2D);

end



