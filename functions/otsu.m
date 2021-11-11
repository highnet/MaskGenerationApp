        function result = otsu(image, flipped)
            
            maskedImage = rgb2gray(image); 
            
            top = 256;
            maximumInterClassVariance = 0.0;
            
            for i = 1:top
                foreGroundPixels = maskedImage >= i;
                backGroundPixels = ~foreGroundPixels;
                
                numberOfPixelsInForeground = sum(foreGroundPixels(:) == 1);
                meanIntensityOfForeground = mean(maskedImage(maskedImage >= i));
                
                numberOfPixelsInBackground = sum(backGroundPixels(:) == 1);
                meanIntensityOfBackground = mean(maskedImage(maskedImage < i));
                
                interClassVariance = numberOfPixelsInBackground * numberOfPixelsInForeground * (meanIntensityOfBackground - meanIntensityOfForeground)^2;
                
                if (interClassVariance >= maximumInterClassVariance)
                    level = i;
                    maximumInterClassVariance = interClassVariance;
                end
            end
              maskedImage = rgb2gray(image) <= level; % compute a binary mask
            if flipped == 1
                maskedImage = ~maskedImage;
            end
              result = maskedImage;
        end
       
