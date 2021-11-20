% Author: Joaquin Telleria (01408189)
% Given a cell of images, return a cell of masks of each image generated with Otsu's method.
% inputs:
% images: A cell of images to be masked.
% flipped: Whether the mask should be flipped or not.

% outputs:
% result: A cell of masks, whereby each input image has been masked using Otu's method.

function result = multi_otsu(images, flipped)

numberOfImages = size(images);
numberOfImages = numberOfImages(2);

masks = cell(1,numberOfImages);

for j = 1:numberOfImages
    
    grayImage = rgb2gray(images{1,j});
    top = 256;
    maximumInterClassVariance = 0.0;

    for i = 1:top
        foreGroundPixels = grayImage >= i;
        backGroundPixels = ~foreGroundPixels;

        numberOfPixelsInForeground = sum(foreGroundPixels(:) == 1);
        meanIntensityOfForeground = mean(grayImage(foreGroundPixels));

        numberOfPixelsInBackground = sum(backGroundPixels(:) == 1);
        meanIntensityOfBackground = mean(grayImage(backGroundPixels));

        interClassVariance = numberOfPixelsInBackground * numberOfPixelsInForeground * (meanIntensityOfBackground - meanIntensityOfForeground)^2;

        if (interClassVariance >= maximumInterClassVariance)
            level = i;
            maximumInterClassVariance = interClassVariance;
        end
    end
    maskedImage = grayImage <= level; % compute a binary mask
    if flipped == 1
        maskedImage = ~maskedImage;
    end
    masks{1,j} = maskedImage;
end
result = masks;
end
