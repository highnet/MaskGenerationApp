% Author: Joaquin Telleria (01408189)
% Given a cell of masks, returns a cell of areas (in squared meters) of foreground pixels (==1) of each image.
% inputs:
% masks: A [1xN] cell of logical matrices, whereby in each matrix water pixels are foreground pixels (==1).
% spatial_resolution_meters: The spatial resolution of the satellite image,  1 pixel = spatial_resolution_meters squared meters.

% outputs: masks
% result: A [1xN] cell of areas, each cell contains the area of foreground pixels of each input image.


function result = multi_mask_to_area(masks,spatial_resolution_meters)

numberOfMasks = size(masks);
numberOfMasks = numberOfMasks(2);

areas = cell(1,numberOfMasks);

for i = 1:numberOfMasks
    areas{1,i} = sum(masks{1,i}(:)) * spatial_resolution_meters;
end

result = areas;

end
