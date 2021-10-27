classdef HomeScreen_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WaterLabDevelopmentBuildUIFigure  matlab.ui.Figure
        FileMenu           matlab.ui.container.Menu
        NewMenu            matlab.ui.container.Menu
        ExitMenu           matlab.ui.container.Menu
        Background         matlab.ui.control.Image
        GetImagesButton    matlab.ui.control.Button
        AboutButton        matlab.ui.control.Button
        ImageEditorButton  matlab.ui.control.Button
        ExamplesButton     matlab.ui.control.Button
        UserManualButton   matlab.ui.control.Button
        StartButton        matlab.ui.control.Button
        UserManualLabel    matlab.ui.control.Label
        ImageEditorLabel   matlab.ui.control.Label
        ExamplesLabel      matlab.ui.control.Label
        GetImagesLabel     matlab.ui.control.Label
        AboutLabel         matlab.ui.control.Label
        StartLabel         matlab.ui.control.Label
        Title              matlab.ui.control.Image
        Splash             matlab.ui.control.Image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
        end

        % Image clicked function: Splash
        function SplashClicked(app, event)
            app.Splash.Enable = false;
            app.Splash.Visible = false;
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            ConfigureSettings();
            app.delete;
        end

        % Button pushed function: ImageEditorButton
        function ImageEditorButtonPushed(app, event)
            ImageCropper();
        end

        % Button pushed function: GetImagesButton
        function GetImagesButtonPushed(app, event)
            web("https://earthexplorer.usgs.gov/");
        end

        % Button pushed function: ExamplesButton
        function ExamplesButtonPushed(app, event)
            CaseStudies();
        end

        % Button pushed function: UserManualButton
        function UserManualButtonPushed(app, event)
            web("https://www.overleaf.com/project/616d930f46ea936cbb9fdf1f");
        end

        % Button pushed function: AboutButton
        function AboutButtonPushed(app, event)
            About();
        end

        % Menu selected function: NewMenu
        function NewMenuSelected(app, event)
            ConfigureSettings();
            app.delete;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create WaterLabDevelopmentBuildUIFigure and hide until all components are created
            app.WaterLabDevelopmentBuildUIFigure = uifigure('Visible', 'off');
            app.WaterLabDevelopmentBuildUIFigure.Position = [100 100 800 600];
            app.WaterLabDevelopmentBuildUIFigure.Name = 'WaterLab (Development Build)';
            app.WaterLabDevelopmentBuildUIFigure.Icon = 'GetImages.PNG';

            % Create FileMenu
            app.FileMenu = uimenu(app.WaterLabDevelopmentBuildUIFigure);
            app.FileMenu.Text = 'File';

            % Create NewMenu
            app.NewMenu = uimenu(app.FileMenu);
            app.NewMenu.MenuSelectedFcn = createCallbackFcn(app, @NewMenuSelected, true);
            app.NewMenu.Text = 'New';

            % Create ExitMenu
            app.ExitMenu = uimenu(app.FileMenu);
            app.ExitMenu.Text = 'Exit';

            % Create Background
            app.Background = uiimage(app.WaterLabDevelopmentBuildUIFigure);
            app.Background.ScaleMethod = 'fill';
            app.Background.Position = [1 4 800 600];
            app.Background.ImageSource = 'bg.PNG';

            % Create GetImagesButton
            app.GetImagesButton = uibutton(app.WaterLabDevelopmentBuildUIFigure, 'push');
            app.GetImagesButton.ButtonPushedFcn = createCallbackFcn(app, @GetImagesButtonPushed, true);
            app.GetImagesButton.Icon = 'EditImages.PNG';
            app.GetImagesButton.IconAlignment = 'center';
            app.GetImagesButton.BackgroundColor = [0.3216 0.8902 1];
            app.GetImagesButton.Position = [662 79 107 91];
            app.GetImagesButton.Text = '';

            % Create AboutButton
            app.AboutButton = uibutton(app.WaterLabDevelopmentBuildUIFigure, 'push');
            app.AboutButton.ButtonPushedFcn = createCallbackFcn(app, @AboutButtonPushed, true);
            app.AboutButton.Icon = 'About.PNG';
            app.AboutButton.IconAlignment = 'center';
            app.AboutButton.BackgroundColor = [0.3216 0.8902 1];
            app.AboutButton.Position = [510 79 107 91];
            app.AboutButton.Text = '';

            % Create ImageEditorButton
            app.ImageEditorButton = uibutton(app.WaterLabDevelopmentBuildUIFigure, 'push');
            app.ImageEditorButton.ButtonPushedFcn = createCallbackFcn(app, @ImageEditorButtonPushed, true);
            app.ImageEditorButton.Icon = 'EditImages.PNG';
            app.ImageEditorButton.IconAlignment = 'center';
            app.ImageEditorButton.BackgroundColor = [0.3216 0.8902 1];
            app.ImageEditorButton.Position = [39 79 107 91];
            app.ImageEditorButton.Text = '';

            % Create ExamplesButton
            app.ExamplesButton = uibutton(app.WaterLabDevelopmentBuildUIFigure, 'push');
            app.ExamplesButton.ButtonPushedFcn = createCallbackFcn(app, @ExamplesButtonPushed, true);
            app.ExamplesButton.Icon = 'Capture.PNG';
            app.ExamplesButton.IconAlignment = 'center';
            app.ExamplesButton.BackgroundColor = [0.3216 0.8902 1];
            app.ExamplesButton.Position = [192 79 107 91];
            app.ExamplesButton.Text = '';

            % Create UserManualButton
            app.UserManualButton = uibutton(app.WaterLabDevelopmentBuildUIFigure, 'push');
            app.UserManualButton.ButtonPushedFcn = createCallbackFcn(app, @UserManualButtonPushed, true);
            app.UserManualButton.Icon = 'UserManual.PNG';
            app.UserManualButton.IconAlignment = 'center';
            app.UserManualButton.BackgroundColor = [0.3216 0.8902 1];
            app.UserManualButton.Position = [349 79 107 91];
            app.UserManualButton.Text = '';

            % Create StartButton
            app.StartButton = uibutton(app.WaterLabDevelopmentBuildUIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Icon = 'Start.PNG';
            app.StartButton.IconAlignment = 'center';
            app.StartButton.BackgroundColor = [0.3216 0.8902 1];
            app.StartButton.Position = [324 256 143 97];
            app.StartButton.Text = '';

            % Create UserManualLabel
            app.UserManualLabel = uilabel(app.WaterLabDevelopmentBuildUIFigure);
            app.UserManualLabel.FontName = 'Arial';
            app.UserManualLabel.FontSize = 24;
            app.UserManualLabel.FontColor = [1 1 1];
            app.UserManualLabel.Position = [338 49 143 31];
            app.UserManualLabel.Text = 'User Manual';

            % Create ImageEditorLabel
            app.ImageEditorLabel = uilabel(app.WaterLabDevelopmentBuildUIFigure);
            app.ImageEditorLabel.FontName = 'Arial';
            app.ImageEditorLabel.FontSize = 24;
            app.ImageEditorLabel.FontColor = [1 1 1];
            app.ImageEditorLabel.Position = [21 49 143 31];
            app.ImageEditorLabel.Text = 'Image Editor';

            % Create ExamplesLabel
            app.ExamplesLabel = uilabel(app.WaterLabDevelopmentBuildUIFigure);
            app.ExamplesLabel.FontName = 'Arial';
            app.ExamplesLabel.FontSize = 24;
            app.ExamplesLabel.FontColor = [1 1 1];
            app.ExamplesLabel.Position = [193 49 111 31];
            app.ExamplesLabel.Text = 'Examples';

            % Create GetImagesLabel
            app.GetImagesLabel = uilabel(app.WaterLabDevelopmentBuildUIFigure);
            app.GetImagesLabel.FontName = 'Arial';
            app.GetImagesLabel.FontSize = 24;
            app.GetImagesLabel.FontColor = [1 1 1];
            app.GetImagesLabel.Position = [651 50 128 30];
            app.GetImagesLabel.Text = 'Get Images';

            % Create AboutLabel
            app.AboutLabel = uilabel(app.WaterLabDevelopmentBuildUIFigure);
            app.AboutLabel.FontName = 'Arial';
            app.AboutLabel.FontSize = 24;
            app.AboutLabel.FontColor = [1 1 1];
            app.AboutLabel.Position = [529 49 68 31];
            app.AboutLabel.Text = 'About';

            % Create StartLabel
            app.StartLabel = uilabel(app.WaterLabDevelopmentBuildUIFigure);
            app.StartLabel.FontName = 'Arial';
            app.StartLabel.FontSize = 32;
            app.StartLabel.FontColor = [1 1 1];
            app.StartLabel.Position = [355 218 90 39];
            app.StartLabel.Text = 'Start';

            % Create Title
            app.Title = uiimage(app.WaterLabDevelopmentBuildUIFigure);
            app.Title.Position = [146 354 471 150];
            app.Title.ImageSource = 'title.PNG';

            % Create Splash
            app.Splash = uiimage(app.WaterLabDevelopmentBuildUIFigure);
            app.Splash.ScaleMethod = 'fill';
            app.Splash.ImageClickedFcn = createCallbackFcn(app, @SplashClicked, true);
            app.Splash.Position = [3 3 798 601];
            app.Splash.ImageSource = 'splash.gif';

            % Show the figure after all components are created
            app.WaterLabDevelopmentBuildUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = HomeScreen_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WaterLabDevelopmentBuildUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WaterLabDevelopmentBuildUIFigure)
        end
    end
end