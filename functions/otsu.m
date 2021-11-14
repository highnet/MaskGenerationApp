        function result = otsu(image, flipped)
            
            grayImage = rgb2gray(image); 
            top = 256;
            maximumInterClassVariance = 0.0;
            
            for i = 1:top
                foreGroundPixels = grayImage >= i;
                backGroundPixels = ~foreGroundPixels;
                
                numberOfPixelsInForeground = sum(foreGroundPixels(:) == 1);
                meanIntensityOfForeground = mean(grayImage(foreGroundPixels));
                
                numberOfPixelsInBackground = sum(backGroundPixels(:) == 1);
                meanIntensityOfBackground = mean(grayImage(backGroundPixels));
                
                interClassVariance = numberOfPixelsInBackground * numberOfPixelsInForeground * (meanIntensityOfBackground - meanIntensityOfForeground)^2;
                
                if (interClassVariance >= maximumInterClassVariance)
                    level = i;
                    maximumInterClassVariance = interClassVariance;
                end
            end
              maskedImage = grayImage <= level;
            if flipped == 1
                maskedImage = ~maskedImage;
            end
              result = maskedImage;
        end
       
