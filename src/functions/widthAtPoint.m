%Written by: Sergej Keser 11727255

%WIDTHATPOINT Summary of this function goes here
%maxDistance is the biggest distance for some pixel
%distances is a matrix result of distance transform
%binImg is a binary image

function [point1X,point1Y,point2X,point2Y] = widthAtPoint(maxDistance, distances, bwImg)

%getting the coordinates of the point with maxDistance
[xMax,yMax] = find(distances==maxDistance);
xMax=xMax(1);
yMax=yMax(1);

%finding the point with this distance from the above defined point
radius=sqrt(maxDistance)-1;
radius=round(radius);
[rows, columns]=size(distances);
width=columns;
height=rows;

%this is the same method for finding the nearest point with zero as in the
%DT_2F function. And as described there, same thing can be achived by using
%vectorization. However, due to the increased memory usage, it tends to be
%less efficient.
broken=0;
% yolo=distances(max([xMax-radius, 1]):min([height, xMax+radius]),max([yMax-radius, 1]):min([width, yMax+radius]));
% imshow(yolo);
for i=max([xMax-radius, 1]):min([height, xMax+radius])
    for j=max([yMax-radius, 1]):min([width, yMax+radius])
        if distances(i,j)==0

            dx=max(xMax-i, i-xMax);
            dy=max(yMax-j, j-yMax);
            distance=sqrt((dx*dx)+(dy*dy));
            distance=distance*distance;

            if maxDistance==distance
                broken=1;
                break
            else
                continue;
            end
        end
    end
    if broken==1
        break
    end
end
point1X=i;
point1Y=j;

dx=max(xMax-point1X,point1X-xMax);
dy=max(yMax-point1Y, point1Y-yMax);
m=dy/dx;

point2X=xMax(1);
point2Y=yMax(1);
%deciding in which direction to search for the other river bank
if xMax-point1X<0 && yMax-point1Y<0
    for k=1:xMax-1
        point2X=xMax-k;
        point2Y=round(yMax-k*m);
        if bwImg(point2X, point2Y)==0
            break
        end
    end

elseif xMax-point1X>0 && yMax-point1Y<0
    for k=1:height-xMax
        point2X=xMax+k;
        point2Y=round(yMax-k*m);
        if bwImg(point2X, point2Y)==0
            break
        end
    end

elseif xMax-point1X<0 && yMax-point1Y>0
    for k=1:xMax-1
        point2X=xMax-k;
        point2Y=round(yMax+k*m);
        if bwImg(point2X, point2Y)==0
            break
        end
    end

else

    for k=1:height-xMax
        point2X=xMax+k;
        point2Y=round(yMax+k*m);
        if bwImg(point2X, point2Y)==0
            break
        end
    end


end

end

