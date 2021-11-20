% Author: Joaquin Telleria (01408189)
% Given a cell of masks, returns a cell of areas (in squared meters) of foreground pixels (==1) of each image.
% inputs:
% masks: A [1xN] cell of logical matrices, whereby in each matrix water pixels are foreground pixels (==1).
% spatial_resolution_meters: The spatial resolution of the satellite image,  1 pixel = spatial_resolution_meters squared meters.

% outputs: masks
% result: A [1xN] cell of areas, each area is a [1x1] matrix containing a single value of the area of foreground pixels of each input image.


function result = multi_mask_to_area(masks,spatial_resolution_meters)

numberOfMasks = size(masks); % count how many images are in the masks cell 1/2
numberOfMasks = numberOfMasks(2); % count how many images are in the masks cell 2/2

areas = cell(1,numberOfMasks); % create an empty [1xN] cell, where N is the number of masks inputted

for i = 1:numberOfMasks % iterate through every inputted mask
    areas{1,i} = sum(masks{1,i}(:)) * spatial_resolution_meters; % Fetch the mask, multiply the count of foreground pixels (==1) with the spatial resolution in meters and store it in the areas cell
end

result = areas; % return the areas cell

end
