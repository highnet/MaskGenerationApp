function [allMaxDistances, allDAtCords] = multi_distance_transform(masks, CCMs)
%masks are all processed images of a certain body of water
%CCMs are respective connected component masks

numberOfImages=size(masks);
numberOfImages=numberOfImages(2);

%outputs represent max distance and max distance at coordinates for all
%images
allMaxDistances=[[]];
allDAtCords=[];

for i = 1:numberOfImages
    mask = masks{1,i};
    CC=CCMs{1,i};
    [maxDistances, dAtCords]=distance_transform(mask,CC);
    allMaxDistances=cat(1,allMaxDistances, maxDistances);
    allDAtCords=cat(2,allDAtCords,dAtCords);
end

end
