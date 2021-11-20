% Author: Joaquin Telleria (01408189)
% Given a cell of images, return a cell of masks of each image generated with Otsu's method.
% inputs:
% images: A cell of images to be masked.
% flipped: Whether the mask should be flipped or not.

% outputs:
% result: A cell of masks, whereby each input image has been masked using Otsu's method.

function result = multi_otsu(images, flipped)

numberOfImages = size(images); % count how many images are in the input images cell 1/2
numberOfImages = numberOfImages(2); % count how many images are in the input images cell 2/2

masks = cell(1,numberOfImages); % create a new [1xN] masks cell, where N is the number of input images.

for j = 1:numberOfImages % iterate through every input image
    
    grayImage = rgb2gray(images{1,j}); % Convert the image to single channel grayscale
    top = 256; % top defines the maximum possible value of the grayscale image, in our case for uint8 images that value is 256
    maximumInterClassVariance = 0.0; % this variable stores the maximum inter class variance for Otsu's method

    for i = 1:top % iterate through every possible mask
        foreGroundPixels = grayImage >= i; % generate the foreground pixels
        backGroundPixels = ~foreGroundPixels; % generate the background pixels

        numberOfPixelsInForeground = sum(foreGroundPixels(:) == 1); % count the foreground pixels
        meanIntensityOfForeground = mean(grayImage(foreGroundPixels)); % calculate the average value in the original image of the foreground pixels

        numberOfPixelsInBackground = sum(backGroundPixels(:) == 1); % count the background pixels
        meanIntensityOfBackground = mean(grayImage(backGroundPixels)); % calculate the average value in the original image of the background pixels

        interClassVariance = numberOfPixelsInBackground * numberOfPixelsInForeground * (meanIntensityOfBackground - meanIntensityOfForeground)^2; % calculate the inter class variance for this iteration

        if (interClassVariance >= maximumInterClassVariance) % is this the largest inter class variance we have ever seen?
            level = i; % if so, store the level...
            maximumInterClassVariance = interClassVariance; % ...and store the new record
        end
    end
    maskedImage = grayImage <= level; % compute a binary mask % Once we have our optimal level, generate the final mask with that level
    if flipped == 1 % does the user want to flip the mask?
        maskedImage = ~maskedImage; % if so, flip the mask
    end
    masks{1,j} = maskedImage; % store the mask in the masks cell
end
result = masks; % return the masked image
end
