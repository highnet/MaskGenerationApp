% Returns 
% inputs: 
%  
% 

% outputs: 
%
%

function result = multi_mask_to_area(masks,spatial_resolution_meters)

numberOfMasks = size(masks);
numberOfMasks = numberOfMasks(2);

areas = cell(1,numberOfMasks);

for i = 1:numberOfMasks
    areas{1,i} = sum(masks{1,i}(:)) * spatial_resolution_meters;
end

result = areas;

end
