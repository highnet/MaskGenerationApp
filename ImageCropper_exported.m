classdef ImageCropper_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        FileMenu               matlab.ui.container.Menu
        Image                  matlab.ui.control.Image
        CropAllImagesButton    matlab.ui.control.Button
        P1EditFieldLabel       matlab.ui.control.Label
        P1EditField            matlab.ui.control.NumericEditField
        P2EditFieldLabel       matlab.ui.control.Label
        P2EditField            matlab.ui.control.NumericEditField
        P3EditFieldLabel       matlab.ui.control.Label
        P3EditField            matlab.ui.control.NumericEditField
        P4EditFieldLabel       matlab.ui.control.Label
        P4EditField            matlab.ui.control.NumericEditField
        UITable                matlab.ui.control.Table
        SelectCropBoxButton    matlab.ui.control.Button
        Step1aCropImagesLabel  matlab.ui.control.Label
        LoadImageButton        matlab.ui.control.Button
    end

    
    properties (Access = private)
        displayedImageIndex; % double. The index of the currently displayed image
        P1; % double. The first point of the cropping box
        P2; % double. The second point of the cropping box
        P3; % double. The third point of the cropping box
        P4; % double. The fourth point of the cropping box

    end
    
    methods (Access = private)
        
        function updateDisplayedImages(app) % displays an image from the data table
            
            image = imread(app.UITable.Data(app.displayedImageIndex,1)); % set the image from the data table

            app.Image.ImageSource = image;

        end
        
        function loadimage(app) % loads an image into the data table

            filterspec = {'*.png','All Image Files'};  % Display uigetfile dialog
            [file, path] = uigetfile(filterspec); % get filename from user
            

            if (ischar(path)) % Make sure user didn't cancel uigetfile dialog
               filename = [path file]; % set filename
            else
                return;
            end
            
            image = imread(filename); % read image from file name
            [height, width, dim] = size(image); % get image properties
            app.UITable.Data = [app.UITable.Data ; [filename,strcat(num2str(height),"x", num2str(width), "x",num2str(dim))]]; % add data of the new image to the data table
        end
        
        function cropAllImages(app) % crops all images
             selectedDirectory = uigetdir(); % get directory from user, we will store all the cropped images there

            if (selectedDirectory == 0) % Make sure user didn't cancel uigetdir dialog
                return;
            end
            
            for i = 1:size(app.UITable.Data,1) % iterate through every row of the data table
                image = imread(app.UITable.Data(i,1)); % read the image from the filename(first cell) stored in the data table row
                image = imcrop(image,[app.P1 app.P2 app.P3 app.P4]); % crop the image within the cropping box
                imwrite(image,strcat(selectedDirectory,"\img",num2str(i),"_cropped.png")); % save the image on the chosen directory
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Image clicked function: Image
        function ImageClicked(app, event)
                loadimage(app); % load a new image
        end

        % Cell selection callback: UITable
        function UITableCellSelection(app, event)
            indices = event.Indices;
            app.displayedImageIndex = indices(1); % sets the displayedImageIndex to the row of the selected cell
            updateDisplayedImages(app); % update the displayed image
        end

        % Button pushed function: CropAllImagesButton
        function CropAllImagesButtonPushed(app, event)
            cropAllImages(app); % crop all images in the data table
        end

        % Button pushed function: SelectCropBoxButton
        function SelectCropBoxButtonPushed(app, event)
            image = imread(app.UITable.Data(app.displayedImageIndex,1)); % read the displayed image
            imshow(image); % show the image
            rect = drawrectangle(); % get a rectangle from the user
            app.P1 = rect.Position(1); % set the first point of the cropping box
            app.P2 = rect.Position(2); % set the second point of the cropping box
            app.P3 = rect.Position(3); % set the third point of the cropping box
            app.P4 = rect.Position(4); % set the fourth point of the cropping box

        end

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            loadimage(app); % load a new image
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 796 714];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image.Position = [216 382 338 299];

            % Create CropAllImagesButton
            app.CropAllImagesButton = uibutton(app.UIFigure, 'push');
            app.CropAllImagesButton.ButtonPushedFcn = createCallbackFcn(app, @CropAllImagesButtonPushed, true);
            app.CropAllImagesButton.Position = [326 239 101 22];
            app.CropAllImagesButton.Text = 'Crop All Images';

            % Create P1EditFieldLabel
            app.P1EditFieldLabel = uilabel(app.UIFigure);
            app.P1EditFieldLabel.HorizontalAlignment = 'right';
            app.P1EditFieldLabel.Position = [45 325 25 22];
            app.P1EditFieldLabel.Text = 'P1';

            % Create P1EditField
            app.P1EditField = uieditfield(app.UIFigure, 'numeric');
            app.P1EditField.Position = [85 325 100 22];

            % Create P2EditFieldLabel
            app.P2EditFieldLabel = uilabel(app.UIFigure);
            app.P2EditFieldLabel.HorizontalAlignment = 'right';
            app.P2EditFieldLabel.Position = [237 325 25 22];
            app.P2EditFieldLabel.Text = 'P2';

            % Create P2EditField
            app.P2EditField = uieditfield(app.UIFigure, 'numeric');
            app.P2EditField.Position = [277 325 100 22];

            % Create P3EditFieldLabel
            app.P3EditFieldLabel = uilabel(app.UIFigure);
            app.P3EditFieldLabel.HorizontalAlignment = 'right';
            app.P3EditFieldLabel.Position = [433 325 25 22];
            app.P3EditFieldLabel.Text = 'P3';

            % Create P3EditField
            app.P3EditField = uieditfield(app.UIFigure, 'numeric');
            app.P3EditField.Position = [473 325 100 22];

            % Create P4EditFieldLabel
            app.P4EditFieldLabel = uilabel(app.UIFigure);
            app.P4EditFieldLabel.HorizontalAlignment = 'right';
            app.P4EditFieldLabel.Position = [628 325 25 22];
            app.P4EditFieldLabel.Text = 'P4';

            % Create P4EditField
            app.P4EditField = uieditfield(app.UIFigure, 'numeric');
            app.P4EditField.Position = [668 325 100 22];

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Image Filepath'; 'Dimensions'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true true];
            app.UITable.ColumnEditable = [false false];
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection, true);
            app.UITable.Position = [15 39 768 176];

            % Create SelectCropBoxButton
            app.SelectCropBoxButton = uibutton(app.UIFigure, 'push');
            app.SelectCropBoxButton.ButtonPushedFcn = createCallbackFcn(app, @SelectCropBoxButtonPushed, true);
            app.SelectCropBoxButton.Position = [324 278 102 22];
            app.SelectCropBoxButton.Text = 'Select Crop Box';

            % Create Step1aCropImagesLabel
            app.Step1aCropImagesLabel = uilabel(app.UIFigure);
            app.Step1aCropImagesLabel.Position = [15 693 122 22];
            app.Step1aCropImagesLabel.Text = 'Step 1a: Crop Images';

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.Position = [85 257 100 22];
            app.LoadImageButton.Text = 'Load Image';

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