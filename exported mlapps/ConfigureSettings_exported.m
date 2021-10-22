classdef ConfigureSettings_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        FileMenu                    matlab.ui.container.Menu
        WelcomeLabel                matlab.ui.control.Label
        NextStepButton              matlab.ui.control.Button
        ChoseyourmethodButtonGroup  matlab.ui.container.ButtonGroup
        ManualThresholdingButton    matlab.ui.control.RadioButton
        OtsusThresholdingButton     matlab.ui.control.RadioButton
        RegionGrowingButton         matlab.ui.control.RadioButton
        EdgeDetectionButton         matlab.ui.control.RadioButton
        LocationEditFieldLabel      matlab.ui.control.Label
        LocationEditField           matlab.ui.control.EditField
        PixelSizeEditFieldLabel     matlab.ui.control.Label
        PixelSizeEditField          matlab.ui.control.EditField
        ConnectedComponentLabelingCheckBox  matlab.ui.control.CheckBox
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: NextStepButton
        function NextStepButtonPushed(app, event)
            location = app.LocationEditField.Value; % store the location value (The location of the sattelite images)
            pixelSize = app.PixelSizeEditField.Value; % store the pixel size value (The pixel size of the satellite images)
            method = app.ChoseyourmethodButtonGroup.SelectedObject.Text; % store the method value (The method of segmentation used)
            ImageLoading(location,pixelSize,method); % open a new ImageLoading window with the parameters
            app.delete; % delete the window
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 235 306];
            app.UIFigure.Name = 'MATLAB App';

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create WelcomeLabel
            app.WelcomeLabel = uilabel(app.UIFigure);
            app.WelcomeLabel.Position = [89 274 59 22];
            app.WelcomeLabel.Text = 'Welcome!';

            % Create NextStepButton
            app.NextStepButton = uibutton(app.UIFigure, 'push');
            app.NextStepButton.ButtonPushedFcn = createCallbackFcn(app, @NextStepButtonPushed, true);
            app.NextStepButton.FontWeight = 'bold';
            app.NextStepButton.Position = [120 21 100 22];
            app.NextStepButton.Text = 'Next Step';

            % Create ChoseyourmethodButtonGroup
            app.ChoseyourmethodButtonGroup = uibuttongroup(app.UIFigure);
            app.ChoseyourmethodButtonGroup.Title = 'Chose your method:';
            app.ChoseyourmethodButtonGroup.Position = [16 89 204 110];

            % Create ManualThresholdingButton
            app.ManualThresholdingButton = uiradiobutton(app.ChoseyourmethodButtonGroup);
            app.ManualThresholdingButton.Text = 'Manual Thresholding';
            app.ManualThresholdingButton.Position = [11 64 134 22];
            app.ManualThresholdingButton.Value = true;

            % Create OtsusThresholdingButton
            app.OtsusThresholdingButton = uiradiobutton(app.ChoseyourmethodButtonGroup);
            app.OtsusThresholdingButton.Text = 'Otsu''s Thresholding';
            app.OtsusThresholdingButton.Position = [11 42 128 22];

            % Create RegionGrowingButton
            app.RegionGrowingButton = uiradiobutton(app.ChoseyourmethodButtonGroup);
            app.RegionGrowingButton.Text = 'Region Growing';
            app.RegionGrowingButton.Position = [11 20 108 22];

            % Create EdgeDetectionButton
            app.EdgeDetectionButton = uiradiobutton(app.ChoseyourmethodButtonGroup);
            app.EdgeDetectionButton.Text = 'Edge Detection';
            app.EdgeDetectionButton.Position = [11 -1 104 22];

            % Create LocationEditFieldLabel
            app.LocationEditFieldLabel = uilabel(app.UIFigure);
            app.LocationEditFieldLabel.HorizontalAlignment = 'right';
            app.LocationEditFieldLabel.Position = [16 238 51 22];
            app.LocationEditFieldLabel.Text = 'Location';

            % Create LocationEditField
            app.LocationEditField = uieditfield(app.UIFigure, 'text');
            app.LocationEditField.Position = [82 238 100 22];
            app.LocationEditField.Value = 'Testing Location';

            % Create PixelSizeEditFieldLabel
            app.PixelSizeEditFieldLabel = uilabel(app.UIFigure);
            app.PixelSizeEditFieldLabel.HorizontalAlignment = 'right';
            app.PixelSizeEditFieldLabel.Position = [9 207 58 22];
            app.PixelSizeEditFieldLabel.Text = 'Pixel Size';

            % Create PixelSizeEditField
            app.PixelSizeEditField = uieditfield(app.UIFigure, 'text');
            app.PixelSizeEditField.Position = [82 207 100 22];
            app.PixelSizeEditField.Value = '30';

            % Create ConnectedComponentLabelingCheckBox
            app.ConnectedComponentLabelingCheckBox = uicheckbox(app.UIFigure);
            app.ConnectedComponentLabelingCheckBox.Text = 'Connected Component Labeling';
            app.ConnectedComponentLabelingCheckBox.Position = [29 42 195 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ConfigureSettings_exported

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