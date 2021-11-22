function [allMaxDistances, allDAtCords] = multi_distance_transform(masks, CCMs, x, y)
%masks are all processed images of a certain body of water
%CCMs are respective connected component masks

%x,y is an optional input used for calls in GUI
if ~exist("x","var")
     %if the parameter does not exist, we default it to something
      x = 1;
end
if ~exist("y","var")
     %if the parameter does not exist, we default it to something
      y = 1;
end

numberOfImages=size(masks);
numberOfImages=numberOfImages(2);



%outputs represent max distance and max distance at coordinates for all
%images
allMaxDistances=[[]];
allDAtCords=[];

for i = 1:numberOfImages
    mask = masks{1,i};
    CC=CCMs{1,i};
    [label, N]=bwlabel(CC);
    [maxDistances, dAtCords]=distance_transform(mask,label, N,x, y);
    allMaxDistances=cat(1,allMaxDistances, maxDistances);
    allDAtCords=cat(2,allDAtCords,dAtCords);
end

end
