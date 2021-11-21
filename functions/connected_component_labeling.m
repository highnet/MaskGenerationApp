% Returns 
% inputs: 
%  
% 

% outputs: 
%
%

function [result,N] = connected_component_labeling(mask, conn)

    switch conn
        case 4
            [result,N] = bwlabel(mask, 4);
        otherwise
            [result,N] = bwlabel(mask, 8);
    end
end
