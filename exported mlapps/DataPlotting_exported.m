classdef DataPlotting_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        UITable                   matlab.ui.control.Table
        LoadMaskButton            matlab.ui.control.Button
        Step4PlottheresultsLabel  matlab.ui.control.Label
        UIAxes                    matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadMaskButton
        function LoadMaskButtonPushed(app, event)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Mask Filename'; 'Date'};
            app.UITable.RowName = {};
            app.UITable.Position = [41 26 561 159];

            % Create LoadMaskButton
            app.LoadMaskButton = uibutton(app.UIFigure, 'push');
            app.LoadMaskButton.ButtonPushedFcn = createCallbackFcn(app, @LoadMaskButtonPushed, true);
            app.LoadMaskButton.Position = [271 198 100 22];
            app.LoadMaskButton.Text = 'Load Mask';

            % Create Step4PlottheresultsLabel
            app.Step4PlottheresultsLabel = uilabel(app.UIFigure);
            app.Step4PlottheresultsLabel.Position = [9 455 126 22];
            app.Step4PlottheresultsLabel.Text = 'Step 4: Plot the results';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [69 229 511 227];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DataPlotting_exported

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