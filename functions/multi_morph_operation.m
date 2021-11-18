function result = multi_morph_operation(images, type, SE)

    numberOfImages = size(images);
    numberOfImages = numberOfImages(2);

    masks = cell(1,numberOfImages);

    for i = 1:numberOfImages
        grayImage = images{1,i};

        switch type
            case "erode"
                maskedImage = imerode(grayImage, SE);
            case "dilate"
                maskedImage = imdilate(grayImage, SE);
            case "open"
                maskedImage = imopen(grayImage, SE);
            case "close"
                maskedImage = imclose(grayImage, SE);
            otherwise
                maskedImage = image;
        end
        masks(1, i) = maskedImage;
        
    end
    result = masks;
end
