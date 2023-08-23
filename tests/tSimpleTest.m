classdef tSimpleTest < sharedtests.SharedPanelTests
    %TBOXPANEL Tests for uiextras.BoxPanel and uix.BoxPanel.

    properties ( TestParameter )
        % The constructor name, or class, of the component under test.
        ConstructorName = {'uiextras.BoxPanel', 'uix.BoxPanel'}
        % Name-value pair arguments to use when testing the component's
        % constructor and get/set methods.
        NameValuePairs = {{
            'BackgroundColor', [1, 1, 0], ...
            'BorderType', 'line', ...
            'BorderWidth', 2, ...
            'CloseRequestFcn', @glttestutilities.noop, ...
            'CloseTooltipString', 'Close', ...
            'DeleteFcn', @glttestutilities.noop, ...
            'DockFcn', @glttestutilities.noop, ...
            'DockTooltipString', 'Dock', ...
            'FontAngle', 'italic', ...
            'FontName', 'SansSerif', ...
            'FontUnits', 'pixels', ...
            'FontSize', 20, ...
            'FontWeight', 'bold', ...
            'ForegroundColor', [0, 0, 1], ...
            'HelpFcn', @glttestutilities.noop, ...
            'HelpTooltipString', 'Help', ...
            'HighlightColor', [1, 0, 1], ...
            'IsDocked', false, ...
            'IsMinimized', false, ...
            'MaximizeTooltipString', 'Maximize', ...
            'MinimizeFcn', @glttestutilities.noop, ...
            'MinimizeTooltipString', 'Minimize', ...
            'Padding', 5, ...
            'Units', 'pixels', ...
            'Position', [10, 10, 400, 400], ...
            'Tag', 'Test', ...
            'Title', 'uiextras.BoxPanel Test', ...
            'TitleColor', [1, 0, 0], ...
            'UndockTooltipString', 'Undock', ...
            'Visible', 'on'
            }, ...
            {
            'BackgroundColor', [1, 1, 0], ...
            'BorderType', 'line', ...
            'BorderWidth', 2, ...
            'CloseRequestFcn', @glttestutilities.noop, ...
            'CloseTooltipString', 'Close', ...
            'DeleteFcn', @glttestutilities.noop, ...
            'Docked', false, ...
            'DockFcn', @glttestutilities.noop, ...
            'DockTooltipString', 'Dock', ...
            'FontAngle', 'italic', ...
            'FontName', 'SansSerif', ...
            'FontUnits', 'pixels', ...
            'FontSize', 20, ...
            'FontWeight', 'bold', ...
            'ForegroundColor', [0, 0, 1], ...
            'HelpFcn', @glttestutilities.noop, ...
            'HelpTooltipString', 'Help', ...
            'HighlightColor', [1, 0, 1], ...
            'MaximizeTooltipString', 'Maximize', ...
            'Minimized', false, ...
            'MinimizeFcn', @glttestutilities.noop, ...
            'MinimizeTooltipString', 'Minimize', ...
            'Padding', 5, ...
            'Units', 'pixels', ...
            'Position', [10, 10, 400, 400], ...
            'Tag', 'Test', ...
            'Title', 'uix.BoxPanel Test', ...
            'TitleColor', [1, 0, 0], ...
            'UndockTooltipString', 'Undock', ...
            'Visible', 'on'
            }}
    end % properties ( TestParameter )

    properties ( Constant )
        % Box panel properties that should support both strings and
        % character arrays.
        TooltipStringProperties = {
            'MaximizeTooltipString';
            'MinimizeTooltipString';
            'UndockTooltipString';
            'DockTooltipString';
            'HelpTooltipString';
            'CloseTooltipString'}
    end % properties ( Constant )

    methods ( Test, Sealed )

        function dummyTestPoint( ...
                testCase, ConstructorName )

            disp("---check here----");

            % Assume faile for webfigure
            %testCase.assumeGraphicsAreNotWebBased()

            % Create a component.
            %expectedColor = [0, 0, 0];
            %component = testCase.constructComponent( ...
            %    ConstructorName, 'ShadowColor', expectedColor );

            disp("---pass check---");


        end % tPassingShadowColorToConstructorIsCorrect

  end

end
