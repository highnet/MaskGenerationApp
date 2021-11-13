function result = mask_to_area(mask,spatial_resolution_meters)

area = sum(mask(:)) * spatial_resolution_meters;

result = area;

end
