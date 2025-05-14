% Author: Joaquin Telleria (01408189)
% Given an image, return a mask of the image generated with Otsu's method.
% inputs:
% image: The image to be masked.
% flipped: Whether the mask should be flipped or not.

% outputs:
% result: The masked image.

function result = otsu(image, flipped)

grayImage = rgb2gray(image); % Convert the image to single channel grayscale
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
maskedImage = grayImage <= level; % Once we have our optimal level, generate the final mask with that level
if flipped == 1 % does the user want to flip the mask?
    maskedImage = ~maskedImage; % if so, flip the mask
end
result = maskedImage; % return the masked image
end
