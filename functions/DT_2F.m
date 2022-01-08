%Written by: Sergej Keser e11727255

%Preforms distance transform on a matrix (2D array) by transforming it
%first allong columns, than allong rows, and than by checking the
%surrounding diagonal pixels
function [output2D] = DT_2F(input2D)

[rows, columns]=size(input2D);
output2D=zeros(rows, columns);

width=columns;
height=rows;

%transforming along columns
for i=1:width
    output2D(:, i)=DT_1D(input2D(:,i), 1);
end

%transforming along rows
for i=1:height
    output2D(i,:)=DT_1D(output2D(i,:), 2);
end
%checking the diagonal pixels
for x=1:height
    for y=1:width
        if output2D(x,y)<4
            continue;
        else
            radius=sqrt(output2D(x,y))-1;
            radius=round(radius);

            %checking the surrounding region for closer black pixels

            %The following code is the vectorised version of the code that
            %avoids double for loops. However, the preformance is not
            %improved when doing this. In fact, it is slightly
            %worse

            %             I=max([x-radius, 1]):min([height, x+radius]);
            %             J=max([y-radius, 1]):min([width, y+radius]);
            %
            %             Dx=x-I;
            %             Dy=y-J;
            %             a=Dx.*Dx;
            %             b=Dy.*Dy;
            %
            %
            %             distances=sqrt(reshape(bsxfun(@plus,a,b.'),1,[]));
            %             distances=distances.*distances;
            %
            %             B = output2D(I, J)';
            %             B=reshape(B, 1, []);
            %
            %             yolo=find(B==0);
            %
            %             if ~isempty(yolo)
            %
            %                 distances=distances(yolo);
            %                 minDistance=min(distances);
            %                 output2D(x,y)=minDistance;
            %             end

            %The following code checks the surrounding pixels for a closer black pixel
            %using double for loops.
            for i=max([x-radius, 1]):min([height, x+radius])
                for j=max([y-radius, 1]):min([width, y+radius])
                    if output2D(i,j)==0

                        dx=max(x-i, i-x);
                        dy=max(y-j, j-y);
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
end



