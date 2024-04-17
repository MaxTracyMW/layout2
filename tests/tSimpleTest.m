classdef tSimpleTest < glttestutilities.TestInfrastructure

    methods ( Test, Sealed )

         function tAddingInvisibleControlIsWarningFree(testCase )

            ConstructorName = 'uiextras.BoxPanel'; % doesnt matter choosing 'uiextras.BoxPanel' or 'uix.BoxPanel'

            % Create the component.     
            component = testCase.constructComponent(ConstructorName); 

            % Create an invisible control 
            screenDPI = get(groot, 'ScreenPixelsPerInch');
            button = uicontrol( 'Parent', []);
            testCase.addTeardown( @() delete( button ) )
       
        end 

  end

end
