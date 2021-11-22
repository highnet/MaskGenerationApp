function [maxDistance, dAtCords, riverSize, distances] = distance_transform(img,label, N, x,y)
%Author: Sergej Keser 11727255

%img is a pre-processsed image (i.e. with dilation, erosion and region growig)
%label represents a mask with N conected components
%x,y is an optional input used for calls in GUI

if ~exist("x","var")
     %if the parameter does not exist, we default it to something
      x = 1;
end
if ~exist("y","var")
     %if the parameter does not exist, we default it to something
      y = 1;
end

%the following code is there to ensure the right type of input data
%//////////////////////////////////////////////////////////////////////////
    %if the passed img is not a sigle channel grayscale, convert it to such
    %grayImg=im2gray(img);
    %convert the image to a binary image using Otsu's threshold
    %get the threshold
    %level=graythresh(grayImg);
    %use the threshold for creating a binary img
    %bwImg=imbinarize(grayImg, level);
%//////////////////////////////////////////////////////////////////////////

%finding the biggest region, i.e. the region that represent the main
%river/body of water
    maxRegion=[];
    %Finding the sizes (pixel counts) of all regions and puting them in a
    %single array
    for n=1:N
      [r, c] = find(label==n);
     rc=[r c];
     maxRegion=cat(1, maxRegion, size(rc,1));
    end
    
    %Using the max() function to find the biggest region
    riverSize = max(maxRegion(:));

    for labelIndex=1:N
        if(maxRegion(labelIndex)==riverSize)
          break;
        end
    end

%component representing the river as a binary image, 
river=~(label==labelIndex);
%imshow(river);

%Apply distance transform
distances=bwdist(river);
%figure, imshow(uint8(distances));

%get the bigest distance to the edge for some pixel
maxDistance=max(distances(:)); 

%getting the distance to the nearest edge for the user-selected coordinates
temp=bwdist(img);
dAtCords=temp(y,x);

end
