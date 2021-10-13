classdef ImageLoading_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        LoadImageButton           matlab.ui.control.Button
        Image                     matlab.ui.control.Image
        NextStepButton            matlab.ui.control.Button
        Step2LoadyourImagesLabel  matlab.ui.control.Label
        LocationLabel             matlab.ui.control.Label
        locLabel                  matlab.ui.control.Label
        PixelSizeLabel            matlab.ui.control.Label
        pixsizLabel               matlab.ui.control.Label
        MethodLabel               matlab.ui.control.Label
        metLabel                  matlab.ui.control.Label
        ProjectMetadataLabel      matlab.ui.control.Label
        UITable                   matlab.ui.control.Table
        RemoveImageButton         matlab.ui.control.Button
        PictureMetadataLabel      matlab.ui.control.Label
    end

    
    properties (Access = private)
        displayedImageIndex; %double. The index of the currently displayed image
        location; %char. The location of the sattelite images
        pixelSize; %char. The pixel size of the satellite images
        method; %char. The method of segmentation used
    end
    methods (Access = private)
        
        function updateimage(app) % updates the image displayed on the screen
            app.Image.ImageSource = imread(app.UITable.Data(app.displayedImageIndex,1)); % set the image from the data table
            
        end
        
        function loadimage(app)                 

            filterspec = {'*.jpg;*.png;*.gif','All Image Files'};
            [file, path] = uigetfile(filterspec); % Display uigetfile dialog
            

            if (ischar(path)) % Make sure user didn't cancel uigetfile dialog
               filename = [path file]; % set filename
            else
                return;
            end
            
            image = imread(filename); % read image from file name
            [height, width, dim] = size(image); % get image properties
            app.UITable.Data = [app.UITable.Data ; [filename,"1990",strcat(num2str(height),"x", num2str(width), "x",num2str(dim)),""]]; % add data of the new image to the data table
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, location, pixelSize, method)
            app.location = location; % store the location value
            app.pixelSize = pixelSize; % store the pixel size value
            app.method = method; % store the method value
            app.locLabel.Text = location; %  set the location label
            app.pixsizLabel.Text = pixelSize; % set the pixel size labe
            app.metLabel.Text = method; % set the method label
        end

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            loadimage(app); % load a new image
        end

        % Cell selection callback: UITable
        function UITableCellSelection(app, event)
            indices = event.Indices;
            app.displayedImageIndex = indices(1); % sets the displayedImageIndex to the row of the selected cell
            updateimage(app); % update the displayed image
        end

        % Button pushed function: RemoveImageButton
        function RemoveImageButtonPushed(app, event)
            if(isempty(app.UITable.Data))
                return;
            end
            app.UITable.Data(app.displayedImageIndex,:) = []; % delete the row
        end

        % Button pushed function: NextStepButton
        function NextStepButtonPushed(app, event)
            if(isempty(app.UITable.Data)) % make sure the user has uploaded at least one image
                return;
            end
            MaskGeneration(app.locLabel.Text,app.pixsizLabel.Text,app.metLabel.Text,app.UITable.Data); % open a MaskGeneration window with the parameters
            app.delete; % close this window
        end

        % Image clicked function: Image
        function ImageClicked(app, event)
            loadimage(app); % load a new image
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 899 481];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.Position = [227 17 100 22];
            app.LoadImageButton.Text = 'Load Image';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image.Tooltip = {'Here you can load as many images as you want and edit their image year in the table blow.'; ''; 'Warning: all images should have the same size(x;y;dimensions) and be taken by the same satellite at different dates for meaningful results.'};
            app.Image.Position = [298 251 194 196];

            % Create NextStepButton
            app.NextStepButton = uibutton(app.UIFigure, 'push');
            app.NextStepButton.ButtonPushedFcn = createCallbackFcn(app, @NextStepButtonPushed, true);
            app.NextStepButton.FontWeight = 'bold';
            app.NextStepButton.Position = [775 17 100 22];
            app.NextStepButton.Text = 'Next Step';

            % Create Step2LoadyourImagesLabel
            app.Step2LoadyourImagesLabel = uilabel(app.UIFigure);
            app.Step2LoadyourImagesLabel.Position = [4 460 143 22];
            app.Step2LoadyourImagesLabel.Text = 'Step 2: Load your Images';

            % Create LocationLabel
            app.LocationLabel = uilabel(app.UIFigure);
            app.LocationLabel.Position = [676 374 54 22];
            app.LocationLabel.Text = 'Location:';

            % Create locLabel
            app.locLabel = uilabel(app.UIFigure);
            app.locLabel.Position = [742 374 112 22];
            app.locLabel.Text = 'loc';

            % Create PixelSizeLabel
            app.PixelSizeLabel = uilabel(app.UIFigure);
            app.PixelSizeLabel.Position = [676 343 62 22];
            app.PixelSizeLabel.Text = 'Pixel Size:';

            % Create pixsizLabel
            app.pixsizLabel = uilabel(app.UIFigure);
            app.pixsizLabel.Position = [744 343 110 22];
            app.pixsizLabel.Text = 'pix siz';

            % Create MethodLabel
            app.MethodLabel = uilabel(app.UIFigure);
            app.MethodLabel.Position = [676 312 49 22];
            app.MethodLabel.Text = 'Method:';

            % Create metLabel
            app.metLabel = uilabel(app.UIFigure);
            app.metLabel.Position = [744 312 110 22];
            app.metLabel.Text = 'met';

            % Create ProjectMetadataLabel
            app.ProjectMetadataLabel = uilabel(app.UIFigure);
            app.ProjectMetadataLabel.Position = [690 406 96 22];
            app.ProjectMetadataLabel.Text = 'Project Metadata';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Image Filepath'; 'Image Year'; 'Size(x;y;dimensions)'; 'Masked Image Filepath'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true true true true];
            app.UITable.ColumnEditable = [false true false false];
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection, true);
            app.UITable.Position = [72 52 768 176];

            % Create RemoveImageButton
            app.RemoveImageButton = uibutton(app.UIFigure, 'push');
            app.RemoveImageButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveImageButtonPushed, true);
            app.RemoveImageButton.Position = [392 17 100 22];
            app.RemoveImageButton.Text = 'Remove Image';

            % Create PictureMetadataLabel
            app.PictureMetadataLabel = uilabel(app.UIFigure);
            app.PictureMetadataLabel.Position = [72 230 96 22];
            app.PictureMetadataLabel.Text = 'Picture Metadata';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageLoading_exported(varargin)

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