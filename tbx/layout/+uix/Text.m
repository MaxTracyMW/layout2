classdef Text < matlab.mixin.SetGet
    
    properties( Dependent )
        BackgroundColor
        Callback
        DeleteFcn
        Enable
        FontAngle
        FontName
        FontSize
        FontUnits
        FontWeight
        ForegroundColor
        HandleVisibility
        HorizontalAlignment
        Parent
        Position
        String
        Tag
        TooltipString
        UIContextMenu
        Units
        UserData
        VerticalAlignment
        Visible
    end
    
    properties( Dependent, SetAccess = private )
        BeingDeleted
        Extent
        Type
    end
    
    properties( Access = private )
        Container % container
        Checkbox % checkbox, used for label
        Screen % text, used for covering checkbox
        VerticalAlignment_ = 'top' % backing for VerticalAlignment
        Dirty = false % flag
        FigureObserver % observer
        FigureListener % listener
    end
    
    properties( Constant, Access = private )
        Margin = 15
    end
    
    methods
        
        function obj = Text( varargin )
            
            % Create graphics
            container = uicontainer( 'Parent', [], ...
                'Units', get( 0, 'DefaultUicontrolUnits' ), ...
                'Position', get( 0, 'DefaultUicontrolPosition' ), ...
                'SizeChangedFcn', @obj.onResized );
            checkbox = uicontrol( 'Parent', container, ...
                'HandleVisibility', 'off', ...
                'Style', 'checkbox', 'Units', 'pixels', ...
                'HorizontalAlignment', 'center', ...
                'Enable', 'inactive' );
            screen = uicontrol( 'Parent', container, ...
                'HandleVisibility', 'off', ...
                'Style', 'text', 'Units', 'pixels' );
            
            % Create observers and listeners
            figureObserver = uix.FigureObserver( container );
            figureListener = event.listener( figureObserver, ...
                'FigureChanged', @obj.onFigureChanged );
            
            % Store properties
            obj.Container = container;
            obj.Checkbox = checkbox;
            obj.Screen = screen;
            obj.FigureObserver = figureObserver;
            obj.FigureListener = figureListener;
            
            % Set properties
            if nargin > 0
                set( obj, varargin{:} );
            end
            
        end % constructor
        
        function delete( obj )
            
            delete( obj.Container )
            
        end % destructor
        
    end % structors
    
    methods
        
        function value = get.BackgroundColor( obj )
            
            value = obj.Checkbox.BackgroundColor;
            
        end % get.BackgroundColor
        
        function set.BackgroundColor( obj, value )
            
            obj.Container.BackgroundColor = value;
            obj.Checkbox.BackgroundColor = value;
            obj.Screen.BackgroundColor = value;
            
        end % set.BackgroundColor
        
        function value = get.BeingDeleted( obj )
            
            value = obj.Checkbox.BeingDeleted;
            
        end % get.BeingDeleted
        
        function value = get.Callback( obj )
            
            value = obj.Checkbox.Callback;
            
        end % get.Callback
        
        function set.Callback( obj, value )
            
            obj.Checkbox.Callback = value;
            
        end % set.Callback
        
        function value = get.DeleteFcn( obj )
            
            value = obj.Checkbox.DeleteFcn;
            
        end % get.DeleteFcn
        
        function set.DeleteFcn( obj, value )
            
            obj.Checkbox.DeleteFcn = value;
            
        end % set.DeleteFcn
        
        function value = get.Enable( obj )
            
            value = obj.Checkbox.Enable;
            
        end % get.Enable
        
        function set.Enable( obj, value )
            
            obj.Checkbox.Enable = value;
            
        end % set.Enable
        
        function value = get.Extent( obj )
            
            value = obj.Checkbox.Extent;
            
        end % get.Extent
        
        function value = get.FontAngle( obj )
            
            value = obj.Checkbox.FontAngle;
            
        end % get.FontAngle
        
        function set.FontAngle( obj, value )
            
            % Set
            obj.Checkbox.FontAngle = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.FontAngle
        
        function value = get.FontName( obj )
            
            value = obj.Checkbox.FontName;
            
        end % get.FontName
        
        function set.FontName( obj, value )
            
            % Set
            obj.Checkbox.FontName = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.FontName
        
        function value = get.FontSize( obj )
            
            value = obj.Checkbox.FontSize;
            
        end % get.FontSize
        
        function set.FontSize( obj, value )
            
            % Set
            obj.Checkbox.FontSize = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.FontSize
        
        function value = get.FontUnits( obj )
            
            value = obj.Checkbox.FontUnits;
            
        end % get.FontUnits
        
        function set.FontUnits( obj, value )
            
            obj.Checkbox.FontUnits = value;
            
        end % set.FontUnits
        
        function value = get.FontWeight( obj )
            
            value = obj.Checkbox.FontWeight;
            
        end % get.FontWeight
        
        function set.FontWeight( obj, value )
            
            % Set
            obj.Checkbox.FontWeight = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.FontWeight
        
        function value = get.ForegroundColor( obj )
            
            value = obj.Checkbox.ForegroundColor;
            
        end % get.ForegroundColor
        
        function set.ForegroundColor( obj, value )
            
            obj.Checkbox.ForegroundColor = value;
            
        end % set.ForegroundColor
        
        function value = get.HandleVisibility( obj )
            
            value = obj.Container.HandleVisibility;
            
        end % get.HandleVisibility
        
        function set.HandleVisibility( obj, value )
            
            obj.Container.HandleVisibility = value;
            
        end % set.HandleVisibility
        
        function value = get.HorizontalAlignment( obj )
            
            value = obj.Checkbox.HorizontalAlignment;
            
        end % get.HorizontalAlignment
        
        function set.HorizontalAlignment( obj, value )
            
            % Set
            obj.Checkbox.HorizontalAlignment = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.HorizontalAlignment
        
        function value = get.Parent( obj )
            
            value = obj.Container.Parent;
            
        end % get.Parent
        
        function set.Parent( obj, value )
            
            obj.Container.Parent = value;
            
        end % set.Parent
        
        function value = get.Position( obj )
            
            value = obj.Container.Position;
            
        end % get.Position
        
        function set.Position( obj, value )
            
            obj.Container.Position = value;
            
        end % set.Position
        
        function value = get.String( obj )
            
            value = obj.Checkbox.String;
            
        end % get.String
        
        function set.String( obj, value )
            
            % Set
            obj.Checkbox.String = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.String
        
        function value = get.Tag( obj )
            
            value = obj.Checkbox.Tag;
            
        end % get.Tag
        
        function set.Tag( obj, value )
            
            obj.Checkbox.Tag = value;
            
        end % set.Tag
        
        function value = get.TooltipString( obj )
            
            value = obj.Checkbox.TooltipString;
            
        end % get.TooltipString
        
        function set.TooltipString( obj, value )
            
            obj.Checkbox.TooltipString = value;
            
        end % set.TooltipString
        
        function value = get.Type( obj )
            
            value = obj.Checkbox.Type;
            
        end % get.Type
        
        function value = get.UIContextMenu( obj )
            
            value = obj.Checkbox.UIContextMenu;
            
        end % get.UIContextMenu
        
        function set.UIContextMenu( obj, value )
            
            obj.Checkbox.UIContextMenu = value;
            
        end % set.UIContextMenu
        
        function value = get.Units( obj )
            
            value = obj.Container.Units;
            
        end % get.Units
        
        function set.Units( obj, value )
            
            obj.Container.Units = value;
            
        end % set.Units
        
        function value = get.UserData( obj )
            
            value = obj.Checkbox.UserData;
            
        end % get.UserData
        
        function set.UserData( obj, value )
            
            obj.Checkbox.UserData = value;
            
        end % set.UserData
        
        function value = get.VerticalAlignment( obj )
            
            value = obj.VerticalAlignment_;
            
        end % get.VerticalAlignment
        
        function set.VerticalAlignment( obj, value )
            
            % Check
            assert( ischar( value ) && ...
                any( strcmp( value, {'top','middle','bottom'} ) ), ...
                'uix:InvalidPropertyValue', ...
                'Property ''VerticalAlignment'' must be ''top'', ''middle'' or ''bottom''.' )
            
            % Set
            obj.VerticalAlignment_ = value;
            
            % Mark as dirty
            obj.setDirty()
            
        end % set.VerticalAlignment
        
        function value = get.Visible( obj )
            
            value = obj.Container.Visible;
            
        end % get.Visible
        
        function set.Visible( obj, value )
            
            obj.Container.Visible = value;
            
        end % set.Visible
        
    end % accessors
    
    methods( Access = private )
        
        function onResized( obj, ~, ~ )
            
            obj.redraw()
            
        end
        
        function onFigureChanged( obj, ~, eventData )
            
            if isempty( eventData.OldFigure ) && ...
                    ~isempty( eventData.NewFigure ) && obj.Dirty
                obj.redraw()
            end
            
        end
        
    end % event handlers
    
    methods( Access = private )
        
        function setDirty( obj )
            
            if isempty( obj.FigureObserver.Figure )
                obj.Dirty = true; % set flag
            else
                obj.Dirty = false; % unset flag
                obj.redraw() % redraw
            end
        end
        
        function redraw( obj )
            
            c = obj.Container;
            b = obj.Checkbox;
            s = obj.Screen;
            bo = hgconvertunits( ancestor( obj, 'figure' ), ...
                [0 0 1 1], 'normalized', 'pixels', c ); % bounds
            m = obj.Margin;
            e = b.Extent;
            switch b.HorizontalAlignment
                case 'left'
                    x = 1 - m;
                case 'center'
                    x = 1 + bo(3)/2 - e(3)/2 - m;
                case 'right'
                    x = 1 + bo(3) - e(3) - m;
            end
            w = bo(3) - x + 1;
            switch obj.VerticalAlignment_
                case 'top'
                    y = 1 + bo(4) - e(4);
                case 'middle'
                    y = 1 + bo(4)/2 - e(4)/2;
                case 'bottom'
                    y = 1;
            end
            h = e(4);
            b.Position = [x y w h];
            s.Position = [x y m h];
            
        end % redraw
        
    end % helpers
    
end % classdef