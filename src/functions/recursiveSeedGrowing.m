%Written by Maximilian Payer, 12023998
%A recursive function that grows a region, given a starting seed
function [temp_maskedImage] = recursiveSeedGrowing(image, similarity, seed, mask, colorValue)

            seedY = uint16(seed(1, 1));  %acquire the positions of the current Pixel
            seedX = uint16(seed(1, 2));  %acquire the positions of the current Pixel
            %it is to be noted that the horizontal values of the image
            %matrix are actually the second dimension, while the vertical
            %values are the first dimension. Hence, seedX stands for vertical
            %values, and vice versa

            temp_maskedImage = mask; 

            if(abs(sum(image(seedX, seedY, :) - colorValue)) > similarity*2)
                return;
            end
        
            temp_maskedImage = regionGrowingChunkHeuristic(image, similarity, seed, temp_maskedImage, 1, colorValue);
            temp_maskedImage(seedX, seedY) = 1; %add the current pixel to the mask
                    
            %the following code block is only executed if the current pixel
            %is not on the edge of the image (since checking the
            %neighbors would go out of bounds)
            if(seedX > 1 && seedY > 1 && seedX < size(image, 1) && seedY < size(image, 2))
                if(temp_maskedImage(seedX+1, seedY) == 0 && ... %check the pixel above
                        sum(image(seedX+1, seedY, :) - colorValue) <= similarity*2 && ...
                        sum(image(seedX+1, seedY, :) - colorValue) >= -similarity*2) %filter by color, using the similarity value
                    newSeed = seed;
                    newSeed(1, 2) = newSeed(1, 2) +1; 
                    temp_maskedImage = recursiveSeedGrowing(image, similarity, newSeed, temp_maskedImage, colorValue); %recursive call on shifted seed
                end
                if(temp_maskedImage(seedX-1, seedY, :) == 0 && ... %check the pixel below
                        sum(image(seedX-1, seedY, :) - colorValue) <= similarity*2 && ...
                        sum(image(seedX-1, seedY, :) - colorValue) >= -similarity*2) %filter by color, using the similarity value
                    newSeed = seed;
                    newSeed(1, 2) = newSeed(1, 2) -1;
                    temp_maskedImage = recursiveSeedGrowing(image, similarity, newSeed, temp_maskedImage, colorValue); %recursive call on shifted seed
                end
                if(temp_maskedImage(seedX, seedY+1, :) == 0 && ... %check the pixel to the right
                        sum(image(seedX, seedY+1, :) - colorValue) <= similarity*2 && ...
                        sum(image(seedX, seedY+1, :) - colorValue) >= -similarity*2) %filter by color, using the similarity value
                    newSeed = seed;
                    newSeed(1, 1) = newSeed(1, 1) +1;
                    temp_maskedImage = recursiveSeedGrowing(image, similarity, newSeed, temp_maskedImage, colorValue);  %recursive call on shifted seed
                end
                if(temp_maskedImage(seedX, seedY-1, :) == 0 && ... %check the pixel to the left
                        sum(image(seedX, seedY-1, :) - colorValue) <= similarity*2 && ...
                        sum(image(seedX, seedY-1, :) - colorValue) >= -similarity*2) %filter by color, using the similarity value
                    newSeed = seed;
                    newSeed(1, 1) = newSeed(1, 1) -1;
                    temp_maskedImage = recursiveSeedGrowing(image, similarity, newSeed, temp_maskedImage, colorValue); %recursive call on shifted seed 
                end
                

            end

        end