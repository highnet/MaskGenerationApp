       function results = cropImages(image,P1, P2, P3, P4) % crops all images
             selectedDirectory = uigetdir(); % get directory from user, we will store all the cropped images there

            if (selectedDirectory == 0) % Make sure user didn't cancel uigetdir dialog
                return;
            end
            
                image = imcrop(image,[P1 P2 P3 P4]); % crop the image within the cropping box
                image = histeq(image);
                imwrite(image,strcat(selectedDirectory,"\_cropped.png")); % save the image on the chosen directory
                results = image;
       end
