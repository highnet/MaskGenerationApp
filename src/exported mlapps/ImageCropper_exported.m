classdef ImageCropper_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        FileMenu                     matlab.ui.container.Menu
        LoadTIFButton                matlab.ui.control.Button
        AutoContrastEnhancementButtonGroup  matlab.ui.container.ButtonGroup
        adaptivehistogramequalizationButton  matlab.ui.control.RadioButton
        histogramequalizationButton  matlab.ui.control.RadioButton
        OffButton                    matlab.ui.control.RadioButton
        SetManualCropBoxLabel        matlab.ui.control.Label
        CropThisImageButton          matlab.ui.control.Button
        Label                        matlab.ui.control.Label
        LoadPNGButton                matlab.ui.control.Button
        Step1aCropImagesLabel        matlab.ui.control.Label
        SelectCropBoxButton          matlab.ui.control.Button
        UITable                      matlab.ui.control.Table
        P4EditField                  matlab.ui.control.NumericEditField
        P4EditFieldLabel             matlab.ui.control.Label
        P3EditField                  matlab.ui.control.NumericEditField
        P3EditFieldLabel             matlab.ui.control.Label
        P2EditField                  matlab.ui.control.NumericEditField
        P2EditFieldLabel             matlab.ui.control.Label
        P1EditField                  matlab.ui.control.NumericEditField
        P1EditFieldLabel             matlab.ui.control.Label
        CropAllImagesButton          matlab.ui.control.Button
        Image                        matlab.ui.control.Image
    end

    
    properties (Access = private)
        displayedImageIndex; % double. The index of the currently displayed image
        P1; % double. The first point of the cropping box
        P2; % double. The second point of the cropping box
        P3; % double. The third point of the cropping box
        P4; % double. The fourth point of the cropping box
        images;
        imagesCount = 0;

    end
    
    methods (Access = private)
        
        function updateDisplayedImages(app) % displays an image from the data table
            
              app.Image.ImageSource  = app.images{1,app.displayedImageIndex};

        end
        
        function loadimage(app,format) % loads an image into the data table
    
            if (format == 'png')
               filterspec = {'*.png','.PNG file'};  % Display uigetfile dialog
            elseif (format == 'tif')
               filterspec = {'*.tif','.TIF file'};  % Display uigetfile dialog
            end
            [file, path] = uigetfile(filterspec); % get filename from user

            if (ischar(path)) % Make sure user didn't cancel uigetfile dialog
               filename = [path file]; % set filename
            else
                return;
            end
            
            image = imread(filename); % read image from file name
            
            if (format == 'tif')
                [rgbgray,cmap] = gray2ind(image,256);
                image = cat (3, rgbgray, rgbgray, rgbgray);   
            end
            
            [height, width, dim] = size(image); % get image properties
            app.imagesCount = app.imagesCount + 1;
            app.images{1,app.imagesCount} = image;
            app.UITable.Data = [app.UITable.Data ; [app.imagesCount,strcat(num2str(height),"x", num2str(width), "x",num2str(dim))]]; % add data of the new image to the data table
        end
        
        function cropImages(app,mode) % crops all images
             selectedDirectory = uigetdir(); % get directory from user, we will store all the cropped images there

            if (selectedDirectory == 0) % Make sure user didn't cancel uigetdir dialog
                return;
            end
            
            if (mode == 0)
                for i = 1:app.imagesCount 
                image = app.images{1,i};
                image = imcrop(image,[app.P1 app.P2 app.P3 app.P4]); % crop the image within the cropping box
                if (app.adaptivehistogramequalizationButton.Value == true)
                    image = histeq(image);
                elseif(app.adaptivehistogramequalizationButton.Value == true)
                    image = adapthisteq(image);
                end
                imwrite(image,strcat(selectedDirectory,"\",num2str(posixtime(datetime)),"_cropped.png")); % save the image on the chosen directory
                end
            elseif (mode == 1)
                image = app.images{1,app.displayedImageIndex};
                image = imcrop(image,[app.P1 app.P2 app.P3 app.P4]); % crop the image within the cropping box
                if (app.adaptivehistogramequalizationButton.Value == true)
                    image = histeq(image);
                elseif(app.adaptivehistogramequalizationButton.Value == true)
                    image = adapthisteq(image);
                end
                imwrite(image,strcat(selectedDirectory,"\",num2str(posixtime(datetime)),"_cropped.png")); % save the image on the chosen directory
            end

        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
             app.images = cell(1,100); % create a new storage matrix for all masks of all pictures, this is initially empty.
        end

        % Cell selection callback: UITable
        function UITableCellSelection(app, event)
            indices = event.Indices;
            app.displayedImageIndex = indices(1); % sets the displayedImageIndex to the row of the selected cell
            app.Label.Text = num2str(app.displayedImageIndex);
            updateDisplayedImages(app); % update the displayed image
        end

        % Button pushed function: CropAllImagesButton
        function CropAllImagesButtonPushed(app, event)
            cropImages(app,0); % crop all images in the data table
        end

        % Button pushed function: SelectCropBoxButton
        function SelectCropBoxButtonPushed(app, event)
            image = app.images{1,app.displayedImageIndex}; % read the displayed image
            imshow(image); % show the image
            rect = drawrectangle(); % get a rectangle from the user
            app.P1 = rect.Position(1); % set the first point of the cropping box
            app.P2 = rect.Position(2); % set the second point of the cropping box
            app.P3 = rect.Position(3); % set the third point of the cropping box
            app.P4 = rect.Position(4); % set the fourth point of the cropping box

        end

        % Button pushed function: LoadPNGButton
        function LoadPNGButtonPushed(app, event)
            loadimage(app,'png'); % load a new image
        end

        % Button pushed function: CropThisImageButton
        function CropThisImageButtonPushed(app, event)
                cropImages(app,1);
        end

        % Button pushed function: LoadTIFButton
        function LoadTIFButtonPushed(app, event)
            loadimage(app,'tif'); % load a new image

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 705 597];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [234 273 304 299];

            % Create CropAllImagesButton
            app.CropAllImagesButton = uibutton(app.UIFigure, 'push');
            app.CropAllImagesButton.ButtonPushedFcn = createCallbackFcn(app, @CropAllImagesButtonPushed, true);
            app.CropAllImagesButton.Position = [407 230 101 22];
            app.CropAllImagesButton.Text = 'Crop All Images';

            % Create P1EditFieldLabel
            app.P1EditFieldLabel = uilabel(app.UIFigure);
            app.P1EditFieldLabel.HorizontalAlignment = 'right';
            app.P1EditFieldLabel.Position = [563 484 25 22];
            app.P1EditFieldLabel.Text = 'P1';

            % Create P1EditField
            app.P1EditField = uieditfield(app.UIFigure, 'numeric');
            app.P1EditField.Position = [594 483 100 22];

            % Create P2EditFieldLabel
            app.P2EditFieldLabel = uilabel(app.UIFigure);
            app.P2EditFieldLabel.HorizontalAlignment = 'right';
            app.P2EditFieldLabel.Position = [563 463 25 22];
            app.P2EditFieldLabel.Text = 'P2';

            % Create P2EditField
            app.P2EditField = uieditfield(app.UIFigure, 'numeric');
            app.P2EditField.Position = [594 462 100 22];

            % Create P3EditFieldLabel
            app.P3EditFieldLabel = uilabel(app.UIFigure);
            app.P3EditFieldLabel.HorizontalAlignment = 'right';
            app.P3EditFieldLabel.Position = [563 442 25 22];
            app.P3EditFieldLabel.Text = 'P3';

            % Create P3EditField
            app.P3EditField = uieditfield(app.UIFigure, 'numeric');
            app.P3EditField.Position = [594 441 100 22];

            % Create P4EditFieldLabel
            app.P4EditFieldLabel = uilabel(app.UIFigure);
            app.P4EditFieldLabel.HorizontalAlignment = 'right';
            app.P4EditFieldLabel.Position = [563 421 25 22];
            app.P4EditFieldLabel.Text = 'P4';

            % Create P4EditField
            app.P4EditField = uieditfield(app.UIFigure, 'numeric');
            app.P4EditField.Position = [594 420 100 22];

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Name'; 'Size'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true true];
            app.UITable.ColumnEditable = [false false];
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection, true);
            app.UITable.Position = [15 44 670 176];

            % Create SelectCropBoxButton
            app.SelectCropBoxButton = uibutton(app.UIFigure, 'push');
            app.SelectCropBoxButton.ButtonPushedFcn = createCallbackFcn(app, @SelectCropBoxButtonPushed, true);
            app.SelectCropBoxButton.Position = [574 383 102 22];
            app.SelectCropBoxButton.Text = 'Select Crop Box';

            % Create Step1aCropImagesLabel
            app.Step1aCropImagesLabel = uilabel(app.UIFigure);
            app.Step1aCropImagesLabel.Position = [15 576 122 22];
            app.Step1aCropImagesLabel.Text = 'Step 1a: Crop Images';

            % Create LoadPNGButton
            app.LoadPNGButton = uibutton(app.UIFigure, 'push');
            app.LoadPNGButton.ButtonPushedFcn = createCallbackFcn(app, @LoadPNGButtonPushed, true);
            app.LoadPNGButton.Position = [277 15 100 22];
            app.LoadPNGButton.Text = 'Load .PNG';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [384 571 13 22];
            app.Label.Text = '0';

            % Create CropThisImageButton
            app.CropThisImageButton = uibutton(app.UIFigure, 'push');
            app.CropThisImageButton.ButtonPushedFcn = createCallbackFcn(app, @CropThisImageButtonPushed, true);
            app.CropThisImageButton.Position = [273 230 104 22];
            app.CropThisImageButton.Text = 'Crop This Image';

            % Create SetManualCropBoxLabel
            app.SetManualCropBoxLabel = uilabel(app.UIFigure);
            app.SetManualCropBoxLabel.Position = [565 515 120 22];
            app.SetManualCropBoxLabel.Text = 'Set Manual Crop Box';

            % Create AutoContrastEnhancementButtonGroup
            app.AutoContrastEnhancementButtonGroup = uibuttongroup(app.UIFigure);
            app.AutoContrastEnhancementButtonGroup.Title = 'Auto Contrast Enhancement';
            app.AutoContrastEnhancementButtonGroup.Position = [13 384 204 99];

            % Create OffButton
            app.OffButton = uiradiobutton(app.AutoContrastEnhancementButtonGroup);
            app.OffButton.Text = 'Off';
            app.OffButton.Position = [11 53 58 22];
            app.OffButton.Value = true;

            % Create histogramequalizationButton
            app.histogramequalizationButton = uiradiobutton(app.AutoContrastEnhancementButtonGroup);
            app.histogramequalizationButton.Text = 'histogram equalization';
            app.histogramequalizationButton.Position = [11 27 142 22];

            % Create adaptivehistogramequalizationButton
            app.adaptivehistogramequalizationButton = uiradiobutton(app.AutoContrastEnhancementButtonGroup);
            app.adaptivehistogramequalizationButton.Text = 'adaptive histogram equalization';
            app.adaptivehistogramequalizationButton.Position = [11 6 192 22];

            % Create LoadTIFButton
            app.LoadTIFButton = uibutton(app.UIFigure, 'push');
            app.LoadTIFButton.ButtonPushedFcn = createCallbackFcn(app, @LoadTIFButtonPushed, true);
            app.LoadTIFButton.Position = [408 15 100 22];
            app.LoadTIFButton.Text = 'Load .TIF';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageCropper_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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