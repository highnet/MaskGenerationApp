%Written by: Sergej Keser 11727255
%runs distance transform on multiple images
function [allMaxDistances, allDAtCords,allRiverSizes, allDistances] = multi_distance_transform(labels, Ns, x, y)

%x,y is an optional input used for calls in GUI
if ~exist("x","var")
    %if the parameter does not exist, we default it to something
    x = 1;
end
if ~exist("y","var")
    %if the parameter does not exist, we default it to something
    y = 1;
end

numberOfLabels=max(size(labels));

%outputs represent max distance and max distance at coordinates for all
%images
allMaxDistances=[];
allDAtCords=[];
allRiverSizes=[];
allDistances=[[]];

for i = 1:numberOfLabels
    label=labels(i);
    N=Ns(i);
    [maxDistances, dAtCords, riverSize, distances]=distance_transform(label, N,x, y);

    allMaxDistances=cat(2,allMaxDistances, maxDistances);
    allDAtCords=cat(2,allDAtCords,dAtCords);
    allRiverSizes=cat(2,allRiverSizes, riverSize);
    allDistances=cat(3,allDistances,distances);
end

end
