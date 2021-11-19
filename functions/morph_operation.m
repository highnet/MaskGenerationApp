function result = morph_operation(image, type, SE)

    switch type
        case "erode"
            result = imerode(grayImage, SE);
        case "dilate"
            result = imdilate(grayImage, SE);
        case "open"
            result = imopen(grayImage, SE);
        case "close"
            result = imclose(grayImage, SE);
        otherwise
            result = image;
    end
end
