% Given a mask, returns the area (in squared meters) of foreground pixels (==1).
% inputs:
% mask: A logical matrix, whereby water pixels are foreground pixels (==1).
% spatial_resolution_meters: The spatial resolution of the satellite image,  1 pixel = spatial_resolution_meters squared meters.

% outputs:
% result: The area of foreground pixels.

function result = mask_to_area(mask,spatial_resolution_meters)

area = sum(mask(:)) * spatial_resolution_meters; % Multiply the count of foreground pixels (==1) with the spatial resolution in meters.

result = area; % return the result.

end
