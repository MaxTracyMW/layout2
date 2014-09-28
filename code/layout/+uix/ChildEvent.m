classdef( Hidden, Sealed ) ChildEvent < event.EventData
    %uix.ChildEvent  Event data for child event
    %
    %  e = uix.ChildEvent(c) creates event data including the child c.
    
    %  Copyright 2009-2014 The MathWorks, Inc.
    %  $Revision$ $Date$
    
    properties( SetAccess = private )
        Child % child
    end
    
    methods
        
        function obj = ChildEvent( child )
            %uix.ChildEvent  Event data for child event
            %
            %  e = uix.ChildEvent(c) creates event data including the child
            %  c.
            
            % Set properties
            obj.Child = child;
            
        end % constructor
        
    end % structors
    
end % classdef