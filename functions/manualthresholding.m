        function results = manualThresholding(image,threshold,flipped)
            
            maskedImage = rgb2gray(image) >= threshold; % compute a binary mask (>=)
            
            if flipped == 1
                maskedImage = ~maskedImage;
            end
            results = maskedImage;
        end
