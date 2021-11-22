% Author: Maximilian Jack Seifried (11809634)
% Returns a mask for each of the given images with the morphological operation specified by type applied.
% inputs: 
%  masks: A list of images to be masked.
%  type: A string that is one of erode, dilate, open or close, that specifies the operation type.
%  SE: A structural element with which the morph. operation is applied.

% outputs: 
%  result: A list of the masked images.

function result = multi_morph_operation(masks, type, SE)

    numberOfImages = size(masks); % store the number of images to loop through
    numberOfImages = numberOfImages(2); % we only need the number of columns

    morphs = cell(1,numberOfImages); % the list that stores the morphed images

    for i = 1:numberOfImages % iterate through every input image
        mask = masks{1,i};

        switch type
            case "erode"
                morphedImage = imerode(mask, SE);
            case "dilate"
                morphedImage = imdilate(mask, SE);
            case "open"
                morphedImage = imopen(mask, SE);
            case "close"
                morphedImage = imclose(mask, SE);
            otherwise
                morphedImage = mask;
        end
        morphs{1, i} = morphedImage;
        
    end
    result = morphs;
end
