classdef ConfigureSettings_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        WaterlabUIFigure          matlab.ui.Figure
        FileMenu                  matlab.ui.container.Menu
        SegmentationMethodLabel   matlab.ui.control.Label
        ImageBandEditField        matlab.ui.control.EditField
        ImageBandLabel            matlab.ui.control.Label
        m2Label                   matlab.ui.control.Label
        NameEditField             matlab.ui.control.EditField
        NameLabel                 matlab.ui.control.Label
        CoordinatesEditField      matlab.ui.control.EditField
        CoordinatesLabel          matlab.ui.control.Label
        PixelSizeEditField        matlab.ui.control.EditField
        PixelSizeEditFieldLabel   matlab.ui.control.Label
        LocationEditField         matlab.ui.control.EditField
        LocationLabel             matlab.ui.control.Label
        ButtonGroup               matlab.ui.container.ButtonGroup
        EdgeDetectionButton       matlab.ui.control.RadioButton
        RegionGrowingButton       matlab.ui.control.RadioButton
        OtsusThresholdingButton   matlab.ui.control.RadioButton
        ManualThresholdingButton  matlab.ui.control.RadioButton
        NextButton                matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: NextButton
        function NextButtonPushed(app, event)
            name = app.NameEditField.Value;
            location = app.LocationEditField.Value; % store the location value (The location of the sattelite images)
            coordinates = app.CoordinatesEditField.Value;
            pixelSize = app.PixelSizeEditField.Value; % store the pixel size value (The pixel size of the satellite images)
            band = app.ImageBandEditField.Value;
            method = app.ButtonGroup.SelectedObject.Text; % store the method value (The method of segmentation used)
            ImageLoading(name,location,coordinates,pixelSize,band,method); % open a new ImageLoading window with the parameters
            app.delete; % delete the window
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create WaterlabUIFigure and hide until all components are created
            app.WaterlabUIFigure = uifigure('Visible', 'off');
            app.WaterlabUIFigure.Position = [100 100 221 352];
            app.WaterlabUIFigure.Name = 'Waterlab';
            app.WaterlabUIFigure.Icon = 'GetImages.PNG';

            % Create FileMenu
            app.FileMenu = uimenu(app.WaterlabUIFigure);
            app.FileMenu.Enable = 'off';
            app.FileMenu.Text = 'File';

            % Create NextButton
            app.NextButton = uibutton(app.WaterlabUIFigure, 'push');
            app.NextButton.ButtonPushedFcn = createCallbackFcn(app, @NextButtonPushed, true);
            app.NextButton.IconAlignment = 'center';
            app.NextButton.BackgroundColor = [0.3216 0.8902 1];
            app.NextButton.FontWeight = 'bold';
            app.NextButton.Position = [61 15 103 56];
            app.NextButton.Text = 'Next Step';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.WaterlabUIFigure);
            app.ButtonGroup.TitlePosition = 'centertop';
            app.ButtonGroup.BackgroundColor = [0.3216 0.8902 1];
            app.ButtonGroup.FontName = 'Arial';
            app.ButtonGroup.Position = [14 75 204 92];

            % Create ManualThresholdingButton
            app.ManualThresholdingButton = uiradiobutton(app.ButtonGroup);
            app.ManualThresholdingButton.Text = 'Manual Thresholding';
            app.ManualThresholdingButton.FontName = 'Arial';
            app.ManualThresholdingButton.FontSize = 14;
            app.ManualThresholdingButton.FontColor = [1 1 1];
            app.ManualThresholdingButton.Position = [11 65 153 22];
            app.ManualThresholdingButton.Value = true;

            % Create OtsusThresholdingButton
            app.OtsusThresholdingButton = uiradiobutton(app.ButtonGroup);
            app.OtsusThresholdingButton.Text = 'Otsu''s Thresholding';
            app.OtsusThresholdingButton.FontName = 'Arial';
            app.OtsusThresholdingButton.FontSize = 14;
            app.OtsusThresholdingButton.FontColor = [1 1 1];
            app.OtsusThresholdingButton.Position = [11 43 146 22];

            % Create RegionGrowingButton
            app.RegionGrowingButton = uiradiobutton(app.ButtonGroup);
            app.RegionGrowingButton.Text = 'Region Growing';
            app.RegionGrowingButton.FontName = 'Arial';
            app.RegionGrowingButton.FontSize = 14;
            app.RegionGrowingButton.FontColor = [1 1 1];
            app.RegionGrowingButton.Position = [11 21 122 22];

            % Create EdgeDetectionButton
            app.EdgeDetectionButton = uiradiobutton(app.ButtonGroup);
            app.EdgeDetectionButton.Text = 'Edge Detection';
            app.EdgeDetectionButton.FontName = 'Arial';
            app.EdgeDetectionButton.FontSize = 14;
            app.EdgeDetectionButton.FontColor = [1 1 1];
            app.EdgeDetectionButton.Position = [11 0 118 22];

            % Create LocationLabel
            app.LocationLabel = uilabel(app.WaterlabUIFigure);
            app.LocationLabel.HorizontalAlignment = 'right';
            app.LocationLabel.FontName = 'Arial';
            app.LocationLabel.FontSize = 16;
            app.LocationLabel.Position = [35 288 70 22];
            app.LocationLabel.Text = 'Location:';

            % Create LocationEditField
            app.LocationEditField = uieditfield(app.WaterlabUIFigure, 'text');
            app.LocationEditField.FontSize = 14;
            app.LocationEditField.FontColor = [1 1 1];
            app.LocationEditField.BackgroundColor = [0.3216 0.8902 1];
            app.LocationEditField.Position = [107 287 111 22];
            app.LocationEditField.Value = 'Testing Location';

            % Create PixelSizeEditFieldLabel
            app.PixelSizeEditFieldLabel = uilabel(app.WaterlabUIFigure);
            app.PixelSizeEditFieldLabel.HorizontalAlignment = 'right';
            app.PixelSizeEditFieldLabel.FontName = 'Arial';
            app.PixelSizeEditFieldLabel.FontSize = 16;
            app.PixelSizeEditFieldLabel.Position = [23 222 80 22];
            app.PixelSizeEditFieldLabel.Text = 'Pixel Size:';

            % Create PixelSizeEditField
            app.PixelSizeEditField = uieditfield(app.WaterlabUIFigure, 'text');
            app.PixelSizeEditField.FontSize = 14;
            app.PixelSizeEditField.FontColor = [1 1 1];
            app.PixelSizeEditField.BackgroundColor = [0.3216 0.8902 1];
            app.PixelSizeEditField.Position = [107 222 61 22];
            app.PixelSizeEditField.Value = '30';

            % Create CoordinatesLabel
            app.CoordinatesLabel = uilabel(app.WaterlabUIFigure);
            app.CoordinatesLabel.HorizontalAlignment = 'right';
            app.CoordinatesLabel.FontName = 'Arial';
            app.CoordinatesLabel.FontSize = 16;
            app.CoordinatesLabel.Position = [7 253 96 22];
            app.CoordinatesLabel.Text = 'Coordinates:';

            % Create CoordinatesEditField
            app.CoordinatesEditField = uieditfield(app.WaterlabUIFigure, 'text');
            app.CoordinatesEditField.FontSize = 14;
            app.CoordinatesEditField.FontColor = [1 1 1];
            app.CoordinatesEditField.BackgroundColor = [0.3216 0.8902 1];
            app.CoordinatesEditField.Position = [108 256 111 22];
            app.CoordinatesEditField.Value = '48.209879932502155, 16.37450700759511';

            % Create NameLabel
            app.NameLabel = uilabel(app.WaterlabUIFigure);
            app.NameLabel.HorizontalAlignment = 'right';
            app.NameLabel.FontName = 'Arial';
            app.NameLabel.FontSize = 16;
            app.NameLabel.Position = [47 318 53 22];
            app.NameLabel.Text = 'Name:';

            % Create NameEditField
            app.NameEditField = uieditfield(app.WaterlabUIFigure, 'text');
            app.NameEditField.FontSize = 14;
            app.NameEditField.FontColor = [1 1 1];
            app.NameEditField.BackgroundColor = [0.3216 0.8902 1];
            app.NameEditField.Position = [107 318 111 22];
            app.NameEditField.Value = 'Test Project';

            % Create m2Label
            app.m2Label = uilabel(app.WaterlabUIFigure);
            app.m2Label.FontName = 'Arial';
            app.m2Label.FontSize = 16;
            app.m2Label.Position = [173 222 46 22];
            app.m2Label.Text = '(m^2)';

            % Create ImageBandLabel
            app.ImageBandLabel = uilabel(app.WaterlabUIFigure);
            app.ImageBandLabel.HorizontalAlignment = 'right';
            app.ImageBandLabel.FontName = 'Arial';
            app.ImageBandLabel.FontSize = 16;
            app.ImageBandLabel.Position = [8 190 96 22];
            app.ImageBandLabel.Text = 'Image Band:';

            % Create ImageBandEditField
            app.ImageBandEditField = uieditfield(app.WaterlabUIFigure, 'text');
            app.ImageBandEditField.FontName = 'Arial';
            app.ImageBandEditField.FontSize = 14;
            app.ImageBandEditField.FontColor = [1 1 1];
            app.ImageBandEditField.BackgroundColor = [0.3216 0.8902 1];
            app.ImageBandEditField.Position = [108 190 111 22];
            app.ImageBandEditField.Value = 'Near-infrared';

            % Create SegmentationMethodLabel
            app.SegmentationMethodLabel = uilabel(app.WaterlabUIFigure);
            app.SegmentationMethodLabel.FontName = 'Arial';
            app.SegmentationMethodLabel.FontSize = 16;
            app.SegmentationMethodLabel.Position = [5 166 166 22];
            app.SegmentationMethodLabel.Text = 'Segmentation Method:';

            % Show the figure after all components are created
            app.WaterlabUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ConfigureSettings_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.WaterlabUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.WaterlabUIFigure)
        end
    end
end