%Written by Maximilian Payer, 12023998
%A recursive auxiliary function that aids the region growing function and
%increases its performance greatly
function [mask] = regionGrowingChunkHeuristic(image, similarity, seed, mask, depth, colorValue)

seedY = uint16(seed(1, 1));  %acquire the positions of the current Pixel
    seedX = uint16(seed(1, 2));  %acquire the positions of the current Pixel

    if(mask(seedX, seedY) == 1)
        return
    end

    maxdepth = floor(min(min(min(size(image, 1) - seedX, size(image, 2) - seedY), seedX), seedY)/ 2) -2;
    %The maximum size that the heuristic can use for the given seed (based
    %on the image borders


    if(depth > maxdepth)
        return;
    end

    %colorValue
    %image(seedX, seedY, :)


   %A rough heuristic check whether the square region of the given size (depth)
   %can be added without obstruction. If not, then a thresholding check
   %adds the appropriate pixels in a 11x11 region
   if((abs(sum(image(seedX + depth*2, seedY, :)  - colorValue)) <= similarity*2 && ...
   abs(sum(image(seedX, seedY + depth*2, :)  - colorValue)) <= similarity*2  && ...
   abs(sum(image(seedX - depth*2, seedY, :)  - colorValue)) <= similarity*2  && ...
   abs(sum(image(seedX, seedY - depth*2, :)  - colorValue)) <= similarity*2  ))
   elseif (depth <= 3 && maxdepth > 5)
        mask(seedX- 5*2:seedX+5*2, seedY-5*2:seedY+5*2) = ...
        sum(image(seedX-5*2:seedX+5*2, seedY-5*2:seedY+5*2) - colorValue, 3) <= similarity*2;

           for i = 1:5*2
               newSeed(1,2) = seedX - 5*2 + i*2;
               newSeed(1,1) = seedY - 5*2 - 1;
               if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
                    mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
               end
               
               newSeed(1,2) = seedX - 5*2 - 1;
               newSeed(1,1) = seedY - 5*2  + i*2;
               if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
                    mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
               end
    
               newSeed(1,2) = seedX + 5*2 - i*2;
               newSeed(1,1) = seedY + 5*2 + 1;
               if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
                    mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
               end
    
               newSeed(1,2) = seedX + 5*2 + 1;
               newSeed(1,1) = seedY + 5*2 - i*2;
               if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
                    mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
               end
           end
   
           return;
       else 
           return;
   end


   %A precise heuristic check whether the square region of the given size (depth)
   %can be added without obstruction

   for i = 1:depth
       if(abs(sum(image(seedX - depth*2 + i*4, seedY - depth*2, :)  - colorValue)) <= similarity*2 && ...
        abs(sum(image(seedX - depth*2, seedY - depth*2  + i*4, :)  - colorValue)) <= similarity*2  && ...
        abs(sum(image(seedX + depth*2 - i*4, seedY + depth*2, :)  - colorValue)) <= similarity*2  && ...
        abs(sum(image(seedX + depth*2, seedY + depth*2 - i*4, :)  - colorValue)) <= similarity*2  )
        else
           return;
        end
   end

   %functions for testing purposes
   %pause(0.2);
   %mask(1:size(image, 1), 1:size(image, 2)) = 1;
   %imshow(im2uint8(mask) + image);
    
   %Adds the square region to the mask
   mask(seedX-depth*2:seedX+depth*2, seedY-depth*2:seedY+depth*2) = 1;

   newSeed = seed;

   %Spreads the region growing algorithm to adjacent pixels of the square region
   for i = 1:depth*2
       newSeed(1,2) = seedX - depth*2 + i*2;
       newSeed(1,1) = seedY - depth*2 - 1;
       if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
            mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
       end
       
       newSeed(1,2) = seedX - depth*2 - 1;
       newSeed(1,1) = seedY - depth*2 + i*2;
       if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
            mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
       end

       newSeed(1,2) = seedX + depth*2 - i*2;
       newSeed(1,1) = seedY + depth*2 + 1;
       if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
            mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
       end

       newSeed(1,2) = seedX + depth*2 + 1;
       newSeed(1,1) = seedY + depth*2 - i*2;
       if(mask(newSeed(1,2), newSeed(1,1)) ~= 1)
            mask = recursiveSeedGrowing(image, similarity, newSeed, mask, colorValue);
       end

   end


end