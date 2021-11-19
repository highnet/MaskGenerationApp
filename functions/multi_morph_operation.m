function result = multi_morph_operation(masks, type, SE)

    numberOfImages = size(masks);
    numberOfImages = numberOfImages(2);

    morphs = cell(1,numberOfImages);

    for i = 1:numberOfImages
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
        morphs(1, i) = morphedImage;
        
    end
    result = morphs;
end
