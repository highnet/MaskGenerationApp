function result = multi_morph_operation(masks, type, SE)

    numberOfImages = size(masks);
    numberOfImages = numberOfImages(2);

    morphs = cell(1,numberOfImages);

    for i = 1:numberOfImages
        grayImage = masks{1,i};

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
        morphs(1, i) = maskedImage;
        
    end
    result = morphs;
end
