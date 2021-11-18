function result = multi_connected_component_labeling(images, conn)

    numberOfImages = size(images);
    numberOfImages = numberOfImages(2);

    masks = cell(1,numberOfImages);

    for i = 1:numberOfImages
        grayImage = images{1,i};
        
        switch conn
            case 4
                maskedImage = bwlabel(grayImage, 4);
            otherwise
                maskedImage = bwlabel(grayImage, 8);
        end
        masks(1, i) = maskedImage;
        
    end
    result = masks;
end
