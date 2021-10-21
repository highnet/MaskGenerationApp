classdef DataPlotting_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        UITable                   matlab.ui.control.Table
        Step4PlottheresultsLabel  matlab.ui.control.Label
        PlotDataButton            matlab.ui.control.Button
        UIAxes                    matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        location;
        pixelSize;
        method;
        imageData;
        images;
        imagesCount;
        masks;
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, location, pixelSize, method, imageData, images, imagesCount, masks)
            app.location = location;
            app.pixelSize = pixelSize;
            app.method = method;
            app.imageData = imageData;
            app.images = images;
            app.imagesCount = imagesCount;
            app.masks = masks;
            app.UITable.Data = imageData;

        end

        % Button pushed function: PlotDataButton
        function PlotDataButtonPushed(app, event)
            disp(app.imagesCount);
            
            x = [];
            y = [];
            for (i = 1:app.imagesCount)
                
                mask = app.masks{1,i};
                y = [y sum(mask(:))];
                x = [x str2num(app.UITable.Data(i,2))];
            end
            
            disp(x);
            disp(y);
            
            figure;
            plot(x,y);
            title(app.location);
            subtitle(app.method);
            xlabel("Year");
            ylabel("Pixel Count");
            
            plot(app.UIAxes,x,y);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 646 500];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Image #'; 'Image Year'; 'Size(x;y;dimensions)'};
            app.UITable.RowName = {};
            app.UITable.Position = [41 46 561 159];

            % Create Step4PlottheresultsLabel
            app.Step4PlottheresultsLabel = uilabel(app.UIFigure);
            app.Step4PlottheresultsLabel.Position = [9 475 126 22];
            app.Step4PlottheresultsLabel.Text = 'Step 4: Plot the results';

            % Create PlotDataButton
            app.PlotDataButton = uibutton(app.UIFigure, 'push');
            app.PlotDataButton.ButtonPushedFcn = createCallbackFcn(app, @PlotDataButtonPushed, true);
            app.PlotDataButton.Position = [272 13 100 22];
            app.PlotDataButton.Text = 'Plot Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [69 249 511 227];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DataPlotting_exported(varargin)

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