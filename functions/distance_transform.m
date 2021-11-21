function [maxDistances, dAtCords] = distance_transform(img,CCM, coordinates)
%img is a pre-processsed image (i.e. with dilation, erosion and region growig)
%CCM represents a mask with conected components
%coordinates is an optional input used for calls in GUI

if ~exist('coordinates','var')
     %if the third parameter does not exist, we default it to something
      coordinates = [1 1];
end

%if the passed img is not a sigle channel grayscale, convert it to such
grayImg=im2gray(img);

%convert the image to a binary image using Otsu's threshold
%get the threshold
level=graythresh(grayImg);
%use the threshold for creating a binary img
bwImg=imbinarize(grayImg, level);

%get the number of labels for conected components
[label,N] = bwlabel(CCM); 
%N=number of components
%label=mask with positive integers recognising diferent components
imshow(label)

%array with max distances for each component
maxDistances=[];

% For each component
for index = 1 : N
    %a mask representing an individual component
    component = label == index;  
    d = bwdist(component); % apply distance transform 
    maxDistance = max(d(:)); % Get the maximum distance to the edge
    maxDistances=cat(1,maxDistances, maxDistance);
end
    
temp=bwdist(bwImg);
dAtCords=temp(coordinates(1),coordinates(2));
end



