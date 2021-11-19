function result = connected_component_labeling(image, conn)

    switch conn
        case 4
            result = bwlabel(grayImage, 4);
        otherwise
            result = bwlabel(grayImage, 8);
    end
end
