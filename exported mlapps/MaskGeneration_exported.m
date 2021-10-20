classdef MaskGeneration_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        Panel_3                   matlab.ui.container.Panel
        RegionGrowingLabel        matlab.ui.control.Label
        GrowNewRegionButton       matlab.ui.control.Button
        Panel_2                   matlab.ui.container.Panel
        OtsusThresholdLabel       matlab.ui.control.Label
        CalculatedThresholdLabel  matlab.ui.control.Label
        Panel                     matlab.ui.container.Panel
        ManualThresholdLabel      matlab.ui.control.Label
        Slider                    matlab.ui.control.Slider
        FlipMaskButton            matlab.ui.control.Button
        Step3GenerateMasksLabel   matlab.ui.control.Label
        Image                     matlab.ui.control.Image
        ImageCounter              matlab.ui.control.Label
        NextButton                matlab.ui.control.Button
        PrevButton                matlab.ui.control.Button
        ResetMaskButton           matlab.ui.control.Button
        NextStepButton            matlab.ui.control.Button
        UITable                   matlab.ui.control.Table
        SaveMaskButton            matlab.ui.control.Button
        Image2                    matlab.ui.control.Image
        Image3                    matlab.ui.control.Image
    end

    
    properties (Access = private)
        location; % char. The location of the sattelite images
        pixelSize; % char. The pixel size of the satellite images
        method; % char. The method of segmentation used 
        imageData;
        images; % cell.
        imagesCount; % uint8
        displayedImageIndex = 1; % double. The index of the currently displayed image
        originalImage; % uint8. A reference to the unaltered currently displayed image
        maskedImage; % logical. A reference to the mask of the currently displayed image
        combinedImage; % uint8. A composite of the original+mask of the currently displayed image.
        flippedMask = 0; % double. A boolean for flipping the mask colors.
        masks; %cell. A storage matrix of all masks of all images
        
    end
    
    methods (Access = private)
        
        function updateDisplayedImages(app) % updates the displayed images

            app.originalImage = app.images{1,app.displayedImageIndex}; % load the original image from the data table

            % Do manual thresholding
            if app.method == "Manual Thresholding"
                    app.maskedImage = rgb2gray(app.originalImage); % convert the original image to grayscale as a mask starting point
                    if app.flippedMask == 0
                        app.maskedImage = rgb2gray(app.originalImage) >= app.Slider.Value; % compute a binary mask (>=)
                    else
                        app.maskedImage = rgb2gray(app.originalImage) <= app.Slider.Value; % compute a binary mask (<=)
                    end
                    app.masks{app.displayedImageIndex} = app.maskedImage; % we save the mask on the masks cell

            end

            
            % Do Otsu's Thresholding
            if app.method == "Otsu's Thresholding" % check if we are on the otsu's thresholding mode
                if(isempty(app.masks{app.displayedImageIndex}))
                    app.maskedImage = rgb2gray(app.originalImage); % convert the original image to grayscale as a mask starting point
                    level = otsu(app);
                    app.CalculatedThresholdLabel.Text = strcat("Calculated Threshold = ",num2str(level));
                    app.masks{app.displayedImageIndex} = app.maskedImage; % we save the mask on the masks cell
                else
                    app.maskedImage = app.masks{app.displayedImageIndex}; % Load a mask from the masks cell if it already exists
                end
            end
            
            if app.method == "Region Growing" % check if we are on the region growing mode
                if(isempty(app.masks{app.displayedImageIndex}))
                   app.maskedImage = rgb2gray(app.originalImage); % convert the original image to grayscale as a mask starting point
                   app.maskedImage(:) = 0; % set the masking start point to a black image of the same size as the orignal image
                else
                    app.maskedImage = app.masks{app.displayedImageIndex}; % Load a mask from the masks cell if it already exists
                end
            
            end
           
            
            app.ImageCounter.Text = strcat("Image ", num2str(app.displayedImageIndex), " of ", num2str(app.imagesCount)); % set the displayed image text
            app.Image.ImageSource = app.originalImage; % set the imagesource1 to the original image
            app.Image2.ImageSource = im2uint8(cat(3,app.maskedImage,app.maskedImage,app.maskedImage)); % set the imagesource2 to the masked image (the grayscale mask has to be temporarily converted to a RGB image in order to be displayed in the image component)
            app.combinedImage = im2uint8(cat(3,app.maskedImage,app.maskedImage,app.maskedImage)) + app.originalImage; % create a composite image of the original image plus the image's mask
            app.Image3.ImageSource = app.combinedImage; % set the imagesource3 to the combined image
        end
        
        function level = otsu(app)
            top = 256;            
            maximumInterClassVariance = 0.0;
            
            for (i = 1:top)
                foreGroundPixels = app.maskedImage >= i;
                backGroundPixels = ~foreGroundPixels;
                
                numberOfPixelsInForeground = sum(foreGroundPixels(:) == 1);
                meanIntensityOfForeground = mean(app.maskedImage(app.maskedImage >= i));

                numberOfPixelsInBackground = sum(backGroundPixels(:) == 1);
                meanIntensityOfBackground = mean(app.maskedImage(app.maskedImage < i));
                    
               interClassVariance = numberOfPixelsInBackground * numberOfPixelsInForeground * (meanIntensityOfBackground - meanIntensityOfForeground)^2;
                    
               if (interClassVariance >= maximumInterClassVariance)
                    level = i;
                    maximumInterClassVariance = interClassVariance;
               end
            end 
            
             app.maskedImage = rgb2gray(app.originalImage) <= level; % compute a binary mask (>=)

        end
        
        function results = connectedComponentLabeling(app)
            
        end
        
        function results = edgeDetection(app)
            
        end
        
        function results = regionGrowing(app)
            
        end
        
        function results = noiseRemoval(app)
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, location, pixelSize, method, imageData, images, imagesCount)
            app.location = location; % store the location value
            app.pixelSize = pixelSize; % store the pixel size value
            app.method = method; % store the method value
            app.imageData = imageData; % store the image data value (the image data is the entire table from the previous ImageLoading window)
            app.images = images;
            app.imagesCount = imagesCount;
            app.UITable.Data = imageData; % copy the imagedata into a new table
            if (strcmp(method,"Manual Thresholding")) % Turn on the UI components exclusive to the Manual Thresholding method
                app.Panel.Visible = true;
            elseif (strcmp(method,"Otsu's Thresholding")) % Turn on the UI components exclusive to the Otsu's Thresholding method
                app.Panel_2.Visible = true;
            elseif (strcmp(method,"Region Growing")) % Turn on the UI components exclusive to the Region Growing method
                app.Panel_3.Visible = true;
            end
            app.masks = cell(1,imagesCount); % create a new storage matrix for all masks of all pictures, this is initially empty.
            updateDisplayedImages(app); % update the displayed images
            
        end

        % Button pushed function: SaveMaskButton
        function SaveMaskButtonPushed(app, event)
            selectedDirectory = uigetdir(); % get a directory from user where they want to store the mask
            if (selectedDirectory == 0) % Make sure user didn't cancel uigetdir dialog
                return;
            end
            
            timestamp = num2str(posixtime(datetime)); 
            imwrite(app.maskedImage,strcat(selectedDirectory,"\",timestamp,"_",num2str(app.displayedImageIndex),"_mask.png")); % store an image of the mask
            imwrite(app.combinedImage,strcat(selectedDirectory,"\",timestamp,"_",num2str(app.displayedImageIndex),"_mask_combined.png")); % store an image of the composite
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            if app.displayedImageIndex < size(app.imageData,1) % if there is a next row in the table
                app.displayedImageIndex = app.displayedImageIndex + 1; % increase the index of the displayed row
                updateDisplayedImages(app); % update the displayed images
            end

        end

        % Button pushed function: PrevButton
        function PrevButtonPushed(app, event)
            if app.displayedImageIndex > 1 % if there is a previous row in the table
                app.displayedImageIndex = app.displayedImageIndex - 1; % decrease the index of the displayed row
                updateDisplayedImages(app); % update the displayed images
            end
        end

        % Value changed function: Slider
        function SliderValueChanged(app, event)
           updateDisplayedImages(app); % update the displyed images (with a new manual thresholding slider value)
        end

        % Button pushed function: FlipMaskButton
        function FlipMaskButtonPushed(app, event)
            if app.flippedMask == 0 % bitflip the flipped mask boolean
                app.flippedMask = 1;
            else
                app.flippedMask = 0;
            end
            updateDisplayedImages(app); % update the displayed images

        end

        % Button pushed function: GrowNewRegionButton
        function GrowNewRegionButtonPushed(app, event)
            % Do region growing

            imshow(app.combinedImage); % show the combined image
            try ginput(1) % get the location of one mouse click
            catch 
            end
            
           app.maskedImage = imnoise(app.maskedImage,'salt & pepper',0.1); % write some random data into the mask purely for testing purposes
           app.masks{app.displayedImageIndex} = app.maskedImage; % save the mask so we can keep adding information to it
           app.updateDisplayedImages(); % update the displayed images
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 720 698];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create Panel_3
            app.Panel_3 = uipanel(app.UIFigure);
            app.Panel_3.Visible = 'off';
            app.Panel_3.Position = [4 511 172 84];

            % Create RegionGrowingLabel
            app.RegionGrowingLabel = uilabel(app.Panel_3);
            app.RegionGrowingLabel.FontWeight = 'bold';
            app.RegionGrowingLabel.Position = [36 61 98 22];
            app.RegionGrowingLabel.Text = 'Region Growing';

            % Create GrowNewRegionButton
            app.GrowNewRegionButton = uibutton(app.Panel_3, 'push');
            app.GrowNewRegionButton.ButtonPushedFcn = createCallbackFcn(app, @GrowNewRegionButtonPushed, true);
            app.GrowNewRegionButton.Position = [26 37 113 22];
            app.GrowNewRegionButton.Text = 'Grow New Region';

            % Create Panel_2
            app.Panel_2 = uipanel(app.UIFigure);
            app.Panel_2.Visible = 'off';
            app.Panel_2.Position = [4 419 172 84];

            % Create OtsusThresholdLabel
            app.OtsusThresholdLabel = uilabel(app.Panel_2);
            app.OtsusThresholdLabel.FontWeight = 'bold';
            app.OtsusThresholdLabel.Position = [28 54 104 22];
            app.OtsusThresholdLabel.Text = 'Otsu''s Threshold';

            % Create CalculatedThresholdLabel
            app.CalculatedThresholdLabel = uilabel(app.Panel_2);
            app.CalculatedThresholdLabel.Position = [0 31 272 22];
            app.CalculatedThresholdLabel.Text = 'Calculated Threshold = ';

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Visible = 'off';
            app.Panel.Position = [4 279 172 125];

            % Create ManualThresholdLabel
            app.ManualThresholdLabel = uilabel(app.Panel);
            app.ManualThresholdLabel.FontWeight = 'bold';
            app.ManualThresholdLabel.Position = [39 94 108 22];
            app.ManualThresholdLabel.Text = 'Manual Threshold';

            % Create Slider
            app.Slider = uislider(app.Panel);
            app.Slider.Limits = [0 255];
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.Position = [12 86 150 3];
            app.Slider.Value = 10;

            % Create FlipMaskButton
            app.FlipMaskButton = uibutton(app.Panel, 'push');
            app.FlipMaskButton.ButtonPushedFcn = createCallbackFcn(app, @FlipMaskButtonPushed, true);
            app.FlipMaskButton.Position = [39 20 100 22];
            app.FlipMaskButton.Text = 'Flip Mask';

            % Create Step3GenerateMasksLabel
            app.Step3GenerateMasksLabel = uilabel(app.UIFigure);
            app.Step3GenerateMasksLabel.Position = [4 677 135 22];
            app.Step3GenerateMasksLabel.Text = 'Step 3: Generate Masks';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [188 372 88 81];

            % Create ImageCounter
            app.ImageCounter = uilabel(app.UIFigure);
            app.ImageCounter.FontSize = 30;
            app.ImageCounter.Position = [247 606 172 36];
            app.ImageCounter.Text = 'Image 0 of 0';

            % Create NextButton
            app.NextButton = uibutton(app.UIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Position = [302 315 100 22];
            app.NextButton.Text = 'Next ->';

            % Create PrevButton
            app.PrevButton = uibutton(app.UIFigure, 'push');
            app.PrevButton.ButtonPushedFcn = createCallbackFcn(app, @PrevButtonPushed, true);
            app.PrevButton.Position = [188 315 100 22];
            app.PrevButton.Text = '<- Prev';

            % Create ResetMaskButton
            app.ResetMaskButton = uibutton(app.UIFigure, 'push');
            app.ResetMaskButton.Enable = 'off';
            app.ResetMaskButton.Position = [247 237 100 22];
            app.ResetMaskButton.Text = 'Reset Mask';

            % Create NextStepButton
            app.NextStepButton = uibutton(app.UIFigure, 'push');
            app.NextStepButton.Enable = 'off';
            app.NextStepButton.Position = [610 226 100 22];
            app.NextStepButton.Text = 'Next Step';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Image #'; 'Image Year'; 'Size(x;y;dimensions)'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true true true true];
            app.UITable.ColumnEditable = [false true false false];
            app.UITable.Position = [21 30 679 179];

            % Create SaveMaskButton
            app.SaveMaskButton = uibutton(app.UIFigure, 'push');
            app.SaveMaskButton.ButtonPushedFcn = createCallbackFcn(app, @SaveMaskButtonPushed, true);
            app.SaveMaskButton.Position = [247 279 100 22];
            app.SaveMaskButton.Text = 'Save Mask';

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [188 457 88 81];

            % Create Image3
            app.Image3 = uiimage(app.UIFigure);
            app.Image3.Position = [287 373 216 214];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MaskGeneration_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end