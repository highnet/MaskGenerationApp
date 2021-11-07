classdef About_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure    matlab.ui.Figure
        AboutLabel  matlab.ui.control.Label
        Label       matlab.ui.control.Label
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 195 244];
            app.UIFigure.Name = 'MATLAB App';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.WordWrap = 'on';
            app.Label.FontSize = 14;
            app.Label.Position = [5 14 189 193];
            app.Label.Text = {'Mask Generation App environment for EDBV WS2021 TU Wien'; ''; 'AC5 Group Members:'; ''; '1. Telleria Joaquin'; '2. Tomanov Svetlin'; '3. Keser Sergej'; '4. Seifried Maximilian Jack'; '5. Payer Maximilian'; ''};

            % Create AboutLabel
            app.AboutLabel = uilabel(app.UIFigure);
            app.AboutLabel.FontSize = 30;
            app.AboutLabel.Position = [56 206 84 36];
            app.AboutLabel.Text = 'About';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = About_exported

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