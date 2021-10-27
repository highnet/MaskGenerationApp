classdef ImageLoading_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        FileMenu           matlab.ui.container.Menu
        LoadPNGButton      matlab.ui.control.Button
        Image              matlab.ui.control.Image
        NextButton         matlab.ui.control.Button
        locationLabel      matlab.ui.control.Label
        pixelSizeLabel     matlab.ui.control.Label
        MethodLabel        matlab.ui.control.Label
        UITable            matlab.ui.control.Table
        RemoveImageButton  matlab.ui.control.Button
        NameLabel          matlab.ui.control.Label
        CoordinatesLabel   matlab.ui.control.Label
        ImageBandLabel     matlab.ui.control.Label
    end

    
    properties (Access = private)
        displayedImageIndex; %double. The index of the currently displayed image
        name;
        coordinates;
        band;
        location; %char. The location of the sattelite images
        pixelSize; %char. The pixel size of the satellite images
        method; %char. The method of segmentation used
        images;
        imagesCount = 0;
    end
    methods (Access = private)
        
        function updateimage(app) % updates the image displayed on the screen
            app.Image.ImageSource = app.images{1,app.displayedImageIndex}; % set the image from the data table
            
        end
        
        function loadimage(app)                 
 
            filterspec = {'*.png;','.PNG Image Files'};

            [file, path] = uigetfile(filterspec); % Display uigetfile dialog
            
            if (ischar(path)) % Make sure user didn't cancel uigetfile dialog
               filename = [path file]; % set filename
            else
                return;
            end
            
            image = imread(filename); % read image from file name
            [height, width, dim] = size(image); % get image properties
            app.imagesCount = app.imagesCount + 1;
            app.images{1,app.imagesCount} = image;
            app.UITable.Data = [app.UITable.Data ; [file,num2str(1989+app.imagesCount),strcat(num2str(height),"x", num2str(width), "x",num2str(dim))]]; % add data of the new image to the data table
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, name, location, coordinates, pixelSize, band, method)
            app.name = name;
            app.location = location; % store the location value
            app.coordinates = coordinates;
            app.pixelSize = pixelSize; % store the pixel size value
            app.band = band;
            app.method = method; % store the method value
            
            app.NameLabel.Text = strcat("Project Name: ", name);
            app.locationLabel.Text = strcat("Location: ", location); %  set the location label
            app.CoordinatesLabel.Text = strcat("Coordinates: ", coordinates);
            app.pixelSizeLabel.Text = strcat("Pixel Size: ", pixelSize, "(m^2)"); % set the pixel size labe
            app.ImageBandLabel.Text = strcat("Image Band: ", band);
            app.MethodLabel.Text = strcat("Method: ", method); % set the method label
            
            app.images = cell(1,1024);
        end

        % Button pushed function: LoadPNGButton
        function LoadPNGButtonPushed(app, event)
            loadimage(app); % load a new image
        end

        % Cell selection callback: UITable
        function UITableCellSelection(app, event)
            indices = event.Indices;
            app.displayedImageIndex = indices(1); % sets the displayedImageIndex to the row of the selected cell
            updateimage(app); % update the displayed image
        end

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            if(isempty(app.UITable.Data)) % make sure the user has uploaded at least one image
                return;
            end
            MaskGeneration(app.name,app.location,app.coordinates,app.pixelSize,app.band,app.method,app.UITable.Data,app.images,app.imagesCount); % open a MaskGeneration window with the parameters
            app.delete; % close this window
        end

        % Button pushed function: RemoveImageButton
        function RemoveImageButtonPushed(app, event)
            if(isempty(app.UITable.Data))
                return;
            end
            app.UITable.Data(app.displayedImageIndex,:) = []; % delete the row
            app.images(app.displayedImageIndex) = [];
            app.imagesCount = app.imagesCount - 1;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 800 600];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create LoadPNGButton
            app.LoadPNGButton = uibutton(app.UIFigure, 'push');
            app.LoadPNGButton.ButtonPushedFcn = createCallbackFcn(app, @LoadPNGButtonPushed, true);
            app.LoadPNGButton.Position = [257 47 100 22];
            app.LoadPNGButton.Text = {'Load .PNG'; ''};

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Tooltip = {'Here you can load as many images as you want and edit their image year in the table blow.'; ''; 'Warning: all images should have the same size(x;y;dimensions) and be taken by the same satellite at different dates for meaningful results.'};
            app.Image.Position = [156 153 411 401];

            % Create NextButton
            app.NextButton = uibutton(app.UIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.IconAlignment = 'center';
            app.NextButton.BackgroundColor = [0.3216 0.8902 1];
            app.NextButton.FontWeight = 'bold';
            app.NextButton.Position = [694 9 98 60];
            app.NextButton.Text = {'Next Step'; ''};

            % Create locationLabel
            app.locationLabel = uilabel(app.UIFigure);
            app.locationLabel.Position = [13 132 208 22];
            app.locationLabel.Text = 'Location: ';

            % Create pixelSizeLabel
            app.pixelSizeLabel = uilabel(app.UIFigure);
            app.pixelSizeLabel.Position = [11 88 210 22];
            app.pixelSizeLabel.Text = 'Pixel Size: ';

            % Create MethodLabel
            app.MethodLabel = uilabel(app.UIFigure);
            app.MethodLabel.Position = [11 44 210 22];
            app.MethodLabel.Text = 'Method: ';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Name'; 'Year'; 'Size'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true true true true];
            app.UITable.ColumnEditable = [false true false false];
            app.UITable.CellSelectionCallback = createCallbackFcn(app, @UITableCellSelection, true);
            app.UITable.Position = [602 81 190 520];

            % Create RemoveImageButton
            app.RemoveImageButton = uibutton(app.UIFigure, 'push');
            app.RemoveImageButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveImageButtonPushed, true);
            app.RemoveImageButton.Position = [378 47 100 22];
            app.RemoveImageButton.Text = 'Remove Image';

            % Create NameLabel
            app.NameLabel = uilabel(app.UIFigure);
            app.NameLabel.Position = [258 553 207 22];
            app.NameLabel.Text = 'Name: ';

            % Create CoordinatesLabel
            app.CoordinatesLabel = uilabel(app.UIFigure);
            app.CoordinatesLabel.Position = [13 110 208 22];
            app.CoordinatesLabel.Text = 'Coordinates: ';

            % Create ImageBandLabel
            app.ImageBandLabel = uilabel(app.UIFigure);
            app.ImageBandLabel.Position = [11 66 210 22];
            app.ImageBandLabel.Text = 'Image Band: ';

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