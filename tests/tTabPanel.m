classdef tTabPanel  < ContainerSharedTests ...
        & PanelTests
    %TTABPANEL unit tests for uiextras.TabPanel
    
    properties (TestParameter)
        ContainerType = {'uiextras.TabPanel'};
        GetSetArgs  = {{
            'BackgroundColor',     [1 1 0], ...
            'SelectedChild',       2, ...
            'TabNames',            {'Tab 1', 'Tab 2', 'Empty', 'Tab 3'}, ...
            'TabEnable',           {'on', 'off', 'on', 'on'}, ...
            'TabPosition',         'bottom', ...
            'TabSize',             10, ...
            'ForegroundColor',     [1 1 1], ...
            'HighlightColor',      [1 0 1], ...
            'ShadowColor',         [0 0 0], ...
            'FontAngle',           'normal', ...
            'FontName',            'Arial', ...
            'FontSize',            20, ...
            'FontUnits',           'points', ...
            'FontWeight',          'bold'
            }};
        ConstructorArgs = {{
            'Units',           'pixels', ...
            'Position',        [10 10 400 400], ...
            'Padding',         5, ...
            'Tag',             'Test', ...
            'Visible',         'on', ...
            'FontAngle',   'normal', ...
            'FontName',    'Arial', ...
            'FontSize',    20, ...
            'FontUnits',   'points', ...
            'FontWeight',  'bold'
            }};
        ValidCallbacks = struct(...
            'fcnString',    '@()disp(''function as string'');', ...
            'fcnAnonHandle', @()disp('function as anon handle'), ...
            'fcnHandle',     @tTabPanel.selectionChangedCallback, ...
            'fcnCell',      {{@()disp, 'function as cell'}} ...
            );
    end
    
    properties
        selectionChangedCallbackCalled = false;
    end
    
    methods (Test)
        
        function testTabPanelCallbacks(testcase, ValidCallbacks)
            [obj, ~] = testcase.hBuildRGBBox('uiextras.TabPanel');
            set(obj, 'Callback', ValidCallbacks);
            
            testcase.verifyEqual(get(obj, 'Callback'), ValidCallbacks);
        end
        
        function testTabPanelGetSetOnSelectionChanged(testcase, ValidCallbacks)
            [obj, ~] = testcase.hBuildRGBBox('uiextras.TabPanel');
            set(obj, 'SelectionChangedFcn', ValidCallbacks);
            
            testcase.verifyEqual(get(obj, 'SelectionChangedFcn'), ValidCallbacks);
        end
        
        function testTabPanelOnSelectionChangedCallbackExecutes(testcase)
            [obj, ~] = testcase.hBuildRGBBox('uiextras.TabPanel');
            
            % MATLAB did not correctly set callbacks when defined as a test
            % parameter.
            callbackCell = {...
                @(varargin)testcase.selectionChangedCallback, ...
                @testcase.selectionChangedCallback, ...
                {@testcase.selectionChangedCallback, 2, 3 ,4} ...
                };
            
            for i = 1:numel(callbackCell)
                % set new callback
                set(obj, 'SelectionChangedFcn', callbackCell{i});
                % change selection
                obj.Selection = 3;
                % check callback executed
                testcase.verifyTrue(testcase.selectionChangedCallbackCalled);
                % reset selection and successflag
                obj.Selection = 1;
                testcase.selectionChangedCallbackCalled = false;
            end
        end
        
        function testContextMenuReparents(testcase)
            % test for g1250808 where reparenting a tab panel to a
            % different figure causes the context menus to be orphaned.
            
            f = figure;
            obj = uix.TabPanel( 'Parent', f );
            obj.Position = [0.1 0.1 0.8 0.8];
            for ii = 1:3
                uicontrol( 'Parent', obj );
            end
            % Create a context menu
            contextMenu = uicontextmenu( 'Parent', f );
            uimenu( 'Parent', contextMenu, 'Label', 'Red' );
            uimenu( 'Parent', contextMenu, 'Label', 'Green' );
            uimenu( 'Parent', contextMenu, 'Label', 'Blue' );
            obj.TabContextMenus{2} = contextMenu;
            % Reparent to a new figure
            g = figure;
            obj.Parent = g;
            testcase.verifyEqual( contextMenu.Parent, g );
            % Unparent
            obj.Parent = [];
            testcase.verifyEmpty( contextMenu.Parent );
            % Reparent within the current figure
            u = uix.TabPanel( 'Parent', g, 'TabLocation', 'bottom' );
            obj.Parent = u;
            testcase.verifyEqual( contextMenu.Parent, g );
            
        end
        
        function testRotate3dDoesNotAddMoreTabs(testcase)
            % test for g1129721 where rotating an axis in a panel causes
            % the axis to lose visibility.
            obj = uiextras.TabPanel();
            con = uicontainer('Parent', obj);
            axes('Parent', con, 'Visible', 'on');
            testcase.verifyNumElements(obj.TabTitles, 1);
            % equivalent of selecting the rotate button on figure window:
            rotate3d;
            testcase.verifyNumElements(obj.TabTitles, 1);
        end
    end
    
    methods (Access = private)
        function selectionChangedCallback(src, varargin)
            src.selectionChangedCallbackCalled = true;
        end
    end
    
end