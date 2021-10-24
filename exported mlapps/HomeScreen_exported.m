classdef HomeScreen_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        FileMenu          matlab.ui.container.Menu
        Image2            matlab.ui.control.Image
        Image3            matlab.ui.control.Image
        Image4            matlab.ui.control.Image
        Image5            matlab.ui.control.Image
        Image6            matlab.ui.control.Image
        Image8            matlab.ui.control.Image
        Image10           matlab.ui.control.Image
        Image11           matlab.ui.control.Image
        StartLabel        matlab.ui.control.Label
        HelpLabel         matlab.ui.control.Label
        GetImagesLabel    matlab.ui.control.Label
        ExamplesLabel     matlab.ui.control.Label
        ImageEditorLabel  matlab.ui.control.Label
        UserManualLabel   matlab.ui.control.Label
        Image             matlab.ui.control.Image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Image clicked function: Image
        function ImageClicked(app, event)
            app.Image.Enable = false;
            app.Image.Visible = false;
        end

        % Image clicked function: Image10
        function Image10Clicked(app, event)
            ConfigureSettings();
            app.delete;
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

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [1 1 800 600];
            app.Image2.ImageSource = 'bg.PNG';

            % Create Image3
            app.Image3 = uiimage(app.UIFigure);
            app.Image3.Position = [525 30 77 90];
            app.Image3.ImageSource = 'About.PNG';

            % Create Image4
            app.Image4 = uiimage(app.UIFigure);
            app.Image4.Position = [205 29 81 87];
            app.Image4.ImageSource = 'Capture.PNG';

            % Create Image5
            app.Image5 = uiimage(app.UIFigure);
            app.Image5.Position = [22 20 100 100];
            app.Image5.ImageSource = 'EditImages.PNG';

            % Create Image6
            app.Image6 = uiimage(app.UIFigure);
            app.Image6.Position = [694 30 88 90];
            app.Image6.ImageSource = 'GetImages.PNG';

            % Create Image8
            app.Image8 = uiimage(app.UIFigure);
            app.Image8.Position = [374 31 77 83];
            app.Image8.ImageSource = 'UserManual.PNG';

            % Create Image10
            app.Image10 = uiimage(app.UIFigure);
            app.Image10.ImageClickedFcn = createCallbackFcn(app, @Image10Clicked, true);
            app.Image10.Position = [323 242 152 119];
            app.Image10.ImageSource = 'Start.PNG';

            % Create Image11
            app.Image11 = uiimage(app.UIFigure);
            app.Image11.Position = [160 360 463 150];
            app.Image11.ImageSource = 'title.PNG';

            % Create StartLabel
            app.StartLabel = uilabel(app.UIFigure);
            app.StartLabel.FontName = 'Arial';
            app.StartLabel.FontSize = 32;
            app.StartLabel.FontColor = [1 1 1];
            app.StartLabel.Position = [355 204 73 39];
            app.StartLabel.Text = 'Start';

            % Create HelpLabel
            app.HelpLabel = uilabel(app.UIFigure);
            app.HelpLabel.FontName = 'Arial';
            app.HelpLabel.FontSize = 24;
            app.HelpLabel.FontColor = [1 1 1];
            app.HelpLabel.Position = [536 2 55 30];
            app.HelpLabel.Text = 'Help';

            % Create GetImagesLabel
            app.GetImagesLabel = uilabel(app.UIFigure);
            app.GetImagesLabel.FontName = 'Arial';
            app.GetImagesLabel.FontSize = 24;
            app.GetImagesLabel.FontColor = [1 1 1];
            app.GetImagesLabel.Position = [652 1 130 30];
            app.GetImagesLabel.Text = 'Get Images';

            % Create ExamplesLabel
            app.ExamplesLabel = uilabel(app.UIFigure);
            app.ExamplesLabel.FontName = 'Arial';
            app.ExamplesLabel.FontSize = 24;
            app.ExamplesLabel.FontColor = [1 1 1];
            app.ExamplesLabel.Position = [190 2 111 30];
            app.ExamplesLabel.Text = 'Examples';

            % Create ImageEditorLabel
            app.ImageEditorLabel = uilabel(app.UIFigure);
            app.ImageEditorLabel.FontName = 'Arial';
            app.ImageEditorLabel.FontSize = 24;
            app.ImageEditorLabel.FontColor = [1 1 1];
            app.ImageEditorLabel.Position = [10 1 142 30];
            app.ImageEditorLabel.Text = 'Image Editor';

            % Create UserManualLabel
            app.UserManualLabel = uilabel(app.UIFigure);
            app.UserManualLabel.FontName = 'Arial';
            app.UserManualLabel.FontSize = 24;
            app.UserManualLabel.FontColor = [1 1 1];
            app.UserManualLabel.Position = [342 2 142 30];
            app.UserManualLabel.Text = 'User Manual';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ImageClickedFcn = createCallbackFcn(app, @ImageClicked, true);
            app.Image.Position = [1 1 800 600];
            app.Image.ImageSource = 'splash.gif';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HomeScreen_exported

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