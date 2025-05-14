classdef CaseStudies_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        HereareourcasestudiesLabel  matlab.ui.control.Label
        TabGroup                    matlab.ui.container.TabGroup
        ChangingRiversTab           matlab.ui.container.Tab
        Label                       matlab.ui.control.Label
        Image4                      matlab.ui.control.Image
        Image3                      matlab.ui.control.Image
        Image2                      matlab.ui.control.Image
        Image                       matlab.ui.control.Image
        UIAxes                      matlab.ui.control.UIAxes
        ShrinkingLakesTab           matlab.ui.container.Tab
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 431];

            % Create ChangingRiversTab
            app.ChangingRiversTab = uitab(app.TabGroup);
            app.ChangingRiversTab.Title = 'Changing Rivers';

            % Create UIAxes
            app.UIAxes = uiaxes(app.ChangingRiversTab);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [201 28 300 185];

            % Create Image
            app.Image = uiimage(app.ChangingRiversTab);
            app.Image.Position = [32 262 100 100];

            % Create Image2
            app.Image2 = uiimage(app.ChangingRiversTab);
            app.Image2.Position = [184 262 100 100];

            % Create Image3
            app.Image3 = uiimage(app.ChangingRiversTab);
            app.Image3.Position = [334 262 100 100];

            % Create Image4
            app.Image4 = uiimage(app.ChangingRiversTab);
            app.Image4.Position = [483 262 100 100];

            % Create Label
            app.Label = uilabel(app.ChangingRiversTab);
            app.Label.Position = [32 191 35 22];

            % Create ShrinkingLakesTab
            app.ShrinkingLakesTab = uitab(app.TabGroup);
            app.ShrinkingLakesTab.Title = 'Shrinking Lakes';

            % Create HereareourcasestudiesLabel
            app.HereareourcasestudiesLabel = uilabel(app.UIFigure);
            app.HereareourcasestudiesLabel.Position = [250 447 143 22];
            app.HereareourcasestudiesLabel.Text = 'Here are our case studies';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CaseStudies_exported

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