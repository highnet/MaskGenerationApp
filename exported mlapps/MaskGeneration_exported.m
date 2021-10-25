classdef MaskGeneration_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        FileMenu                 matlab.ui.container.Menu
        CompositeImageLabel      matlab.ui.control.Label
        MaskedImageLabel         matlab.ui.control.Label
        OriginalImageLabel       matlab.ui.control.Label
        Image3                   matlab.ui.control.Image
        Image2                   matlab.ui.control.Image
        SaveMaskButton           matlab.ui.control.Button
        UITable                  matlab.ui.control.Table
        NextStepButton           matlab.ui.control.Button
        PrevButton               matlab.ui.control.Button
        NextButton               matlab.ui.control.Button
        ImageCounterLabel        matlab.ui.control.Label
        Image                    matlab.ui.control.Image
        Step3GenerateMasksLabel  matlab.ui.control.Label
        ManualThresholdPanel     matlab.ui.container.Panel
        ManualThresholdLabel     matlab.ui.control.Label
        Slider                   matlab.ui.control.Slider
        FlipMaskButton           matlab.ui.control.Button
        OtsuThresholdPanel       matlab.ui.container.Panel
        RegionGrowingPanel       matlab.ui.container.Panel
        RegionGrowingLabel       matlab.ui.control.Label
        GrowNewRegionButton      matlab.ui.control.Button
        MorphologyPanel          matlab.ui.container.Panel
        MorphButton              matlab.ui.control.Button
        ConnectedComponentLabelingPanel  matlab.ui.container.Panel
        CCLButton                matlab.ui.control.Button
        EdgeDetectionPanel       matlab.ui.container.Panel
    end

    
    properties (Access = private)
        name;
        coordinates;
        band;
        location; %char. The location of the sattelite images
        pixelSize; %char. The pixel size of the satellite images
        method; %char. The method of segmentation used
        images; % cell.
        imagesCount; % uint8
        displayedImageIndex = 1; % double. The index of the currently displayed image
        flippedMask = 0; % double. A boolean for flipping the mask colors.
        masks; %cell. A storage matrix of all masks of all images
        
    end
    
    methods (Access = private)
        
        function manualThresholding(app,imageIndex,threshold)
            
            temp_OriginalImage = app.images{1,imageIndex}; % load the original image from the data table
            temp_maskedImage = rgb2gray(temp_OriginalImage) >= threshold; % compute a binary mask (>=)
            
            if app.flippedMask == 1
                temp_maskedImage = ~temp_maskedImage;
            end
            
            app.masks{imageIndex} = temp_maskedImage; % we save the mask on the masks cell
        end
        
        function otsu(app,imageIndex)
            
            temp_OriginalImage = app.images{1,imageIndex}; % load the original image from the data table
            temp_MaskedImage = rgb2gray(temp_OriginalImage); % compute a binary mask (>=)
            
            top = 256;
            maximumInterClassVariance = 0.0;
            
            for i = 1:top
                foreGroundPixels = temp_MaskedImage >= i;
                backGroundPixels = ~foreGroundPixels;
                
                numberOfPixelsInForeground = sum(foreGroundPixels(:) == 1);
                meanIntensityOfForeground = mean(temp_MaskedImage(temp_MaskedImage >= i));
                
                numberOfPixelsInBackground = sum(backGroundPixels(:) == 1);
                meanIntensityOfBackground = mean(temp_MaskedImage(temp_MaskedImage < i));
                
                interClassVariance = numberOfPixelsInBackground * numberOfPixelsInForeground * (meanIntensityOfBackground - meanIntensityOfForeground)^2;
                
                if (interClassVariance >= maximumInterClassVariance)
                    level = i;
                    maximumInterClassVariance = interClassVariance;
                end
            end
            
            temp_MaskedImage = rgb2gray(temp_OriginalImage) <= level; % compute a binary mask
            app.masks{imageIndex} = temp_MaskedImage; % we save the mask on the masks cell
            
        end

        function connectedComponentLabeling(app)
            
        end
        
        function edgeDetection(app)
            
        end
        
        function regionGrowing(app,imageIndex)
            
            temp_OriginalImage = app.images{1,imageIndex}; % load the original image from the data table
            temp_MaskedImage = app.masks{1,imageIndex}; % compute a binary mask (>=)
            
            imshow(im2uint8(cat(3,temp_MaskedImage,temp_MaskedImage,temp_MaskedImage)) + temp_OriginalImage); % show the combined image
            

            % try seed = ginput(1) % get the location of one mouse click
            try ginput(1) % wait for one mouse click
            catch
            end
            
            temp_MaskedImage = imnoise(temp_MaskedImage,'salt & pepper',0.1); % write some random data into the mask purely for testing purposes
            app.masks{imageIndex} = temp_MaskedImage; % save the mask so we can keep adding information to it
            
        end
        
        function morphologicalOperation(app)
            
        end
        
        function generateDefaultMasks(app)
            % generate a default mask for each image
            
            if app.method == "Manual Thresholding"
                for (i = 1:app.imagesCount)
                    manualThresholding(app,i,app.Slider.Value);
                end
            elseif app.method == "Otsu's Thresholding" % check if we are on the otsu's thresholding mode
                for (i = 1:app.imagesCount)
                    otsu(app,i);
                end
            elseif app.method == "Region Growing"
                for (i = 1:app.imagesCount)
                    temp_OriginalImage = app.images{1,i}; % load the original image from the data table
                    temp_maskedImage = rgb2gray(temp_OriginalImage); % compute a binary mask (>=)
                    temp_maskedImage(:) = 0; % set the masking start point to a black image of the same size as the orignal image
                    app.masks{i} = temp_maskedImage; % we save the mask on the masks cell
                end
            end
        end
        
        function updateDisplayedImages(app) % updates the displayed images
            
            originalImage = app.images{1,app.displayedImageIndex}; % load the original image from the data table
            maskedImage = app.masks{app.displayedImageIndex}; % Load a mask from the masks cell if it already exists
            combinedImage = im2uint8(cat(3,maskedImage,maskedImage,maskedImage)) + originalImage; % create a composite image of the original image plus the image's mask
            
            app.ImageCounterLabel.Text = strcat("Image ", num2str(app.displayedImageIndex), " of ", num2str(app.imagesCount)); % set the displayed image text
            app.Image.ImageSource = originalImage; % set the imagesource1 to the original image
            app.Image2.ImageSource = im2uint8(cat(3,maskedImage,maskedImage,maskedImage)); % set the imagesource2 to the masked image (the grayscale mask has to be temporarily converted to a RGB image in order to be displayed in the image component)
            app.Image3.ImageSource = combinedImage; % set the imagesource3 to the combined image
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, name, location, coordinates, pixelSize, band, method, imageData, images, imagesCount)
            app.name = name;
            app.location = location; % store the location value
            app.coordinates = coordinates;
            app.pixelSize = pixelSize; % store the pixel size value
            app.band = band;
            app.method = method; % store the method value
            app.images = images;
            app.imagesCount = imagesCount;
            app.UITable.Data = imageData; % copy the imagedata into a new table
            
            if (strcmp(method,"Manual Thresholding")) % Turn on the UI components exclusive to the Manual Thresholding method
                app.ManualThresholdPanel.Visible = true;
            elseif (strcmp(method,"Otsu's Thresholding")) % Turn on the UI components exclusive to the Otsu's Thresholding method
                app.OtsuThresholdPanel.Visible = true;
            elseif (strcmp(method,"Region Growing")) % Turn on the UI components exclusive to the Region Growing method
                app.RegionGrowingPanel.Visible = true;
            elseif (strcmp(method,"Edge Detection")) % Turn on the UI components exclusive to the Region Growing method
                app.RegionGrowingPanel.Visible = true;
            end
            app.masks = cell(1,imagesCount); % create a new storage matrix for all masks of all pictures, this is initially empty.
            
            generateDefaultMasks(app);
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
            if app.displayedImageIndex < size(app.UITable.Data,1) % if there is a next row in the table
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
            manualThresholding(app,app.displayedImageIndex,app.Slider.Value);
            updateDisplayedImages(app); % update the displyed images (with a new manual thresholding slider value)
        end

        % Button pushed function: FlipMaskButton
        function FlipMaskButtonPushed(app, event)
            if app.flippedMask == 0 % bitflip the flipped mask boolean
                app.flippedMask = 1;
            else
                app.flippedMask = 0;
            end
            
            manualThresholding(app,app.displayedImageIndex,app.Slider.Value);
            updateDisplayedImages(app); % update the displayed images

        end

        % Button pushed function: GrowNewRegionButton
        function GrowNewRegionButtonPushed(app, event)
            % Do region growing
           
           regionGrowing(app,app.displayedImageIndex);
           app.updateDisplayedImages(); % update the displayed images
        end

        % Button pushed function: NextStepButton
        function NextStepButtonPushed(app, event)
            DataPlotting(app.location,app.pixelSize,app.method,app.UITable.Data,app.images,app.imagesCount,app.masks);
            app.delete;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 952 653];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create CompositeImageLabel
            app.CompositeImageLabel = uilabel(app.UIFigure);
            app.CompositeImageLabel.Position = [427 576 100 22];
            app.CompositeImageLabel.Text = 'Composite Image';

            % Create MaskedImageLabel
            app.MaskedImageLabel = uilabel(app.UIFigure);
            app.MaskedImageLabel.Position = [114 395 84 22];
            app.MaskedImageLabel.Text = 'Masked Image';

            % Create OriginalImageLabel
            app.OriginalImageLabel = uilabel(app.UIFigure);
            app.OriginalImageLabel.Position = [114 236 84 22];
            app.OriginalImageLabel.Text = 'Original Image';

            % Create Image3
            app.Image3 = uiimage(app.UIFigure);
            app.Image3.Position = [235 92 484 489];

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [83 261 140 135];

            % Create SaveMaskButton
            app.SaveMaskButton = uibutton(app.UIFigure, 'push');
            app.SaveMaskButton.ButtonPushedFcn = createCallbackFcn(app, @SaveMaskButtonPushed, true);
            app.SaveMaskButton.Position = [434 17 100 22];
            app.SaveMaskButton.Text = 'Save Mask';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Name'; 'Year'; 'Size'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true true true true];
            app.UITable.ColumnEditable = [false true false false];
            app.UITable.Position = [728 38 209 581];

            % Create NextStepButton
            app.NextStepButton = uibutton(app.UIFigure, 'push');
            app.NextStepButton.ButtonPushedFcn = createCallbackFcn(app, @NextStepButtonPushed, true);
            app.NextStepButton.Position = [827 9 100 22];
            app.NextStepButton.Text = 'Next Step';

            % Create PrevButton
            app.PrevButton = uibutton(app.UIFigure, 'push');
            app.PrevButton.ButtonPushedFcn = createCallbackFcn(app, @PrevButtonPushed, true);
            app.PrevButton.Position = [375 53 100 22];
            app.PrevButton.Text = '<- Prev';

            % Create NextButton
            app.NextButton = uibutton(app.UIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.Position = [489 53 100 22];
            app.NextButton.Text = 'Next ->';

            % Create ImageCounterLabel
            app.ImageCounterLabel = uilabel(app.UIFigure);
            app.ImageCounterLabel.FontSize = 30;
            app.ImageCounterLabel.Position = [391 597 206 36];
            app.ImageCounterLabel.Text = 'Image 0 of 0';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [88 102 135 135];

            % Create Step3GenerateMasksLabel
            app.Step3GenerateMasksLabel = uilabel(app.UIFigure);
            app.Step3GenerateMasksLabel.Position = [4 632 135 22];
            app.Step3GenerateMasksLabel.Text = 'Step 3: Generate Masks';

            % Create ManualThresholdPanel
            app.ManualThresholdPanel = uipanel(app.UIFigure);
            app.ManualThresholdPanel.Visible = 'off';
            app.ManualThresholdPanel.Position = [4 420 172 125];

            % Create ManualThresholdLabel
            app.ManualThresholdLabel = uilabel(app.ManualThresholdPanel);
            app.ManualThresholdLabel.FontWeight = 'bold';
            app.ManualThresholdLabel.Position = [39 94 108 22];
            app.ManualThresholdLabel.Text = 'Manual Threshold';

            % Create Slider
            app.Slider = uislider(app.ManualThresholdPanel);
            app.Slider.Limits = [0 255];
            app.Slider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.Slider.Position = [12 86 150 3];
            app.Slider.Value = 10;

            % Create FlipMaskButton
            app.FlipMaskButton = uibutton(app.ManualThresholdPanel, 'push');
            app.FlipMaskButton.ButtonPushedFcn = createCallbackFcn(app, @FlipMaskButtonPushed, true);
            app.FlipMaskButton.Position = [39 20 100 22];
            app.FlipMaskButton.Text = 'Flip Mask';

            % Create OtsuThresholdPanel
            app.OtsuThresholdPanel = uipanel(app.UIFigure);
            app.OtsuThresholdPanel.Visible = 'off';
            app.OtsuThresholdPanel.Position = [4 468 172 84];

            % Create RegionGrowingPanel
            app.RegionGrowingPanel = uipanel(app.UIFigure);
            app.RegionGrowingPanel.Visible = 'off';
            app.RegionGrowingPanel.Position = [4 468 172 82];

            % Create RegionGrowingLabel
            app.RegionGrowingLabel = uilabel(app.RegionGrowingPanel);
            app.RegionGrowingLabel.FontWeight = 'bold';
            app.RegionGrowingLabel.Position = [36 59 98 22];
            app.RegionGrowingLabel.Text = 'Region Growing';

            % Create GrowNewRegionButton
            app.GrowNewRegionButton = uibutton(app.RegionGrowingPanel, 'push');
            app.GrowNewRegionButton.ButtonPushedFcn = createCallbackFcn(app, @GrowNewRegionButtonPushed, true);
            app.GrowNewRegionButton.Position = [26 35 113 22];
            app.GrowNewRegionButton.Text = 'Grow New Region';

            % Create MorphologyPanel
            app.MorphologyPanel = uipanel(app.UIFigure);
            app.MorphologyPanel.Title = 'Morphology';
            app.MorphologyPanel.Position = [5 9 133 84];

            % Create MorphButton
            app.MorphButton = uibutton(app.MorphologyPanel, 'push');
            app.MorphButton.Position = [27 29 100 22];
            app.MorphButton.Text = 'Morph';

            % Create ConnectedComponentLabelingPanel
            app.ConnectedComponentLabelingPanel = uipanel(app.UIFigure);
            app.ConnectedComponentLabelingPanel.Title = 'Connected Component Labeling';
            app.ConnectedComponentLabelingPanel.Position = [142 9 152 84];

            % Create CCLButton
            app.CCLButton = uibutton(app.ConnectedComponentLabelingPanel, 'push');
            app.CCLButton.Position = [23 19 100 22];
            app.CCLButton.Text = 'CCL';

            % Create EdgeDetectionPanel
            app.EdgeDetectionPanel = uipanel(app.UIFigure);
            app.EdgeDetectionPanel.Title = 'Edge Detection';
            app.EdgeDetectionPanel.Visible = 'off';
            app.EdgeDetectionPanel.Position = [16 468 139 98];

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