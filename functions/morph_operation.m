% Returns 
% inputs: 
%  
% 

% outputs: 
%
%

function result = morph_operation(mask, type, SE)

    switch type
        case "erode"
            result = imerode(mask, SE);
        case "dilate"
            result = imdilate(mask, SE);
        case "open"
            result = imopen(mask, SE);
        case "close"
            result = imclose(mask, SE);
        otherwise
            result = mask;
    end
end
