%Written by Maximilian Payer, 12023998
%A function that manages the growing of regions. The main process of region
%growing is being done in the recursiveSeedGrowing function
function [result] = regionGrowing(image, mask, similarity)
            if(mask == 0)  % if mask is the scalar value 0, it creates an empty mask
                mask = im2gray(zeros(size(image)));
            end
            
            imshow(im2uint8(mask) + image); % show the combined image

            % try seed = ginput(1) % get the location of one mouse click
            try seed = ginput(1); % wait for one mouse click
            catch 
            end

            result = or(mask, recursiveSeedGrowing(image, similarity, seed, mask)); 
            %add newly created mask to the existing mask

            imshow(im2uint8(cat(3,result,result,result)) + image); % show the combined image 
            %(called twice, so that the changes are visible immediately)
            
end