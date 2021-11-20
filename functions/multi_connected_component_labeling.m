% Returns 
% inputs: 
%  
% 

% outputs: 
%
%

function result = multi_connected_component_labeling(masks, conn)

    numberOfImages = size(masks);
    numberOfImages = numberOfImages(2);

    components = cell(1,numberOfImages);

    for i = 1:numberOfImages
        mask = masks{1,i};
        
        switch conn
            case 4
                maskedImage = bwlabel(mask, 4);
            otherwise
                maskedImage = bwlabel(mask, 8);
        end
        components{1, i} = maskedImage;
        
    end
    result = components;
end
