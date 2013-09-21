classdef( Sealed ) MouseObserver < handle
    
    properties( SetAccess = private )
        Object
    end
    
    properties( Access = private )
        FigureObserver
        Figure
        WindowStyle
        FigurePanelContainer
        Over
        Listeners = event.listener.empty( [0 1] )
    end
    
    events( NotifyAccess = private )
        MousePress
        MouseRelease
        MouseMotion
        MouseEnter
        MouseLeave
    end
    
    methods
        
        function obj = MouseObserver( object )
            
            % Check
            assert( ishghandle( object ) && ...
                isequal( size( object ), [1 1] ), 'uix.InvalidArgument', ...
                'Object must be a graphics object.' )
            
            % Store properties
            obj.Object = object;
            
            % Set up
            obj.setup()
            
        end
        
    end % structors
    
    methods( Access = private )
        
        function onMousePress( obj, ~, ~ )
            
            if obj.isOver()
                notify( obj, 'MousePress' )
            end
            
        end % onMousePress
        
        function onMouseRelease( obj, ~, ~ )
            
            if obj.isOver()
                notify( obj, 'MouseRelease' )
            end
            
        end % onMouseRelease
        
        function onMouseMotion( obj, ~, ~ )
            
            % Identify whether pointer was and is over the object
            isOver = obj.isOver();
            wasOver = obj.Over;
            if isequal( wasOver, [] )
                wasOver = false;
            end
            
            % Raise entered and left events
            if ~wasOver && isOver
                notify( obj, 'MouseEnter' )
            elseif wasOver && ~isOver
                notify( obj, 'MouseLeave' )
            end
            
            % Raise motion event
            if isOver
                notify( obj, 'MouseMotion' )
            end
            
            % Store state
            obj.Over = isOver;
            
        end % onMouseMotion
        
        function onFigureChanged( obj, ~, ~ )
            
            % Set up
            obj.setup()
            
        end % onFigureChanged
        
        function onVisibilityChanged( obj, ~, ~ )
            
            % Set up
            obj.setup()
            
        end % onVisibilityChanged
        
        function onWindowStyleChanged( obj, ~, ~ )
            
            % Set up
            obj.setup()
            
        end % onWindowStyleChanged
        
    end % event handlers
    
    methods( Access = private )
        
        function setup( obj )
            
            object = obj.Object;
            obj.Listeners = event.listener.empty( [0 1] );
            obj.addListener( event.proplistener( object, ...
                findprop( object, 'Visible' ), 'PostSet', ...
                @obj.onVisibilityChanged ) )
            figureObserver = uix.FigureObserver( object );
            obj.addListener( event.listener( figureObserver, ...
                'FigureChanged', @obj.onFigureChanged ) )
            figure = ancestor( object, 'figure' );
            if strcmp( object.Visible, 'off' ) || isempty( figure )
                windowStyle = 'none';
                jFigurePanelContainer = ...
                    matlab.graphics.GraphicsPlaceholder.empty( [0 0] );
            else
                windowStyle = figure.WindowStyle;
                if strcmp( windowStyle, 'docked' )
                    jFigurePanelContainer = ...
                        figure.JavaFrame.getFigurePanelContainer();
                else
                    jFigurePanelContainer = ...
                        matlab.graphics.GraphicsPlaceholder.empty( [0 0] );
                end
                obj.addListener( event.listener( figure, ...
                    'WindowMousePress', @obj.onMousePress ) )
                obj.addListener( event.listener( figure, ...
                    'WindowMouseRelease', @obj.onMouseRelease ) )
                obj.addListener( event.listener( figure, ...
                    'WindowMouseMotion', @obj.onMouseMotion ) )
                obj.addListener( event.proplistener( figure, ...
                    findprop( figure, 'WindowStyle' ), 'PostSet', ...
                    @obj.onWindowStyleChanged ) )
            end
            
            % Store properties
            obj.FigureObserver = figureObserver;
            obj.Figure = figure;
            obj.WindowStyle = windowStyle;
            obj.FigurePanelContainer = jFigurePanelContainer;
            obj.Over = [];
            obj.Listeners = listeners;
            
        end
        
        function tf = isOver( obj )
            
            % Get container
            object = obj.Object;
            
            % Get current point
            currentPoint = obj.getCurrentPoint();
            
            % Get object position
            position = getpixelposition( object );
            
            % Is over?
            tf = currentPoint(1) >= position(1) && ...
                currentPoint(1) < position(1) + position(3) && ...
                currentPoint(2) >= position(2) && ...
                currentPoint(2) < position(2) + position(4);
            
        end % isOver
        
        function p = getCurrentPoint( obj )
            
            % Cache root and screen size
            persistent root screenSize
            if isequal( root, [] )
                root = groot();
                screenSize = root.ScreenSize;
                warning( 'off', 'MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame' )
            end
            
            % Get current point
            pointerLocation = root.PointerLocation;
            figure = obj.Figure;
            if strcmp( obj.WindowStyle, 'docked' )
                figureSize = figure.Position(3:4);
                jFigurePanelContainer = obj.FigurePanelContainer;
                jFigureLocation = jFigurePanelContainer.getLocationOnScreen();
                figureOrigin = [jFigureLocation.getX(), screenSize(4) - ...
                    jFigureLocation.getY() - figureSize(2)];
            else
                figureOrigin = figure.Position(1:2) - [1 1];
            end
            p = pointerLocation - figureOrigin;
            
        end % getCurrentPoint
        
        function addListener( obj, listener )
            
            obj.Listeners(end+1,:) = listener;
            
        end % addListener
        
    end % helpers
    
end % classdef