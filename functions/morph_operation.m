% Author: Maximilian Jack Seifried (11809634)
% Returns a mask of the given image with the morphological operation specified by type applied.
% inputs: 
%  image: The image to be masked.
%  type: A string that is one of erode, dilate, open or close, that specifies the operation type.
%  SE: A structural element with which the morph. operation is applied.

% outputs: 
%  result: The masked image.

function result = morph_operation(mask, type, SE)

switch type
   case 'erode'
        result = imerode(mask, SE); 
   case 'dilate'
       result = imdilate(mask, SE);
   case 'open'
       result = imopen(mask, SE);
   case 'close'
       result = imclose(mask, SE);
   otherwise
       result = mask;
end
end
