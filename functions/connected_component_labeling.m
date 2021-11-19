function result = connected_component_labeling(mask, conn)

    switch conn
        case 4
            result = bwlabel(mask, 4);
        otherwise
            result = bwlabel(mask, 8);
    end
end
