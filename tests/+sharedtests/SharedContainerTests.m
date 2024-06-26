classdef ( Abstract ) SharedContainerTests < glttestutilities.TestInfrastructure
    %CONTAINERTESTS Tests common to all GUI Layout Toolbox containers,
    %across both the +uiextras and +uix packages.

    properties ( TestParameter, Abstract )
        % The constructor name, or class, of the component under test.
        ConstructorName
        % Name-value pair arguments to use when testing the component's
        % constructor and get/set methods.
        NameValuePairs
    end % properties ( TestParameter, Abstract )

    properties ( Constant )
        % List of containers with get and set methods for the 'Enable'
        % property.
        ContainersWithEnableGetAndSetMethods = {
            'uiextras.CardPanel', ...
            'uiextras.Grid', ...
            'uiextras.GridFlex', ...
            'uiextras.HBox', ...
            'uiextras.HBoxFlex', ...
            'uiextras.TabPanel', ...
            'uiextras.VBox', ...
            'uiextras.VBoxFlex'
            }
        % List of containers that may need the 'Enable' property to be
        % added dynamically (depending on the MATLAB version). The 'Enable'
        % property was added to matlab.ui.container.Panel in R2020b.
        ContainersWithDynamicEnableProperty = {
            'uiextras.BoxPanel', ...
            'uiextras.Panel'
            }
        % List of containers that have the 'SelectedChild' property.
        ContainersWithSelectedChildProperty = {
            'uiextras.BoxPanel', ...
            'uiextras.CardPanel', ...
            'uiextras.Panel', ...
            'uiextras.TabPanel'
            }
    end % properties ( Constant )

    methods(TestClassTeardown)
        function showTestDone(testCase)
            disp("done for SharedContainerTests");
        end
    end

    methods ( Test, Sealed )
%{
        function tConstructorWithNoArgumentsIsWarningFree( ...
                testCase, ConstructorName )
            disp("check 11");
            % This test only applies to containers in the uix namespace.
            % (Containers in the uiextras namespace exhibit auto-parenting
            % behavior, which is tested separately.)
            testCase.assumeComponentIsFromNamespace( ...
                ConstructorName, 'uix' )

            % Verify that constructing a component with no input arguments
            % is warning-free.
            creator = @() constructComponentWithoutFixture( ...
                ConstructorName );
            testCase.verifyWarningFree( creator, ...
                ['The ', ConstructorName, ' constructor was ', ...
                'not warning-free when called with no input arguments.'] )
            disp("pass 11");
        end % tConstructorWithNoArgumentsIsWarningFree

        function tConstructorWithNoArgumentsReturnsScalarComponent( ...
                testCase, ConstructorName )
            disp("check 12");
            % This test only applies to containers in the uix namespace.
            % (Containers in the uiextras namespace exhibit auto-parenting
            % behavior, which is tested separately.)
            testCase.assumeComponentIsFromNamespace( ...
                ConstructorName, 'uix' )

            % Call the constructor with no input arguments.
            component = constructComponentWithoutFixture( ...
                ConstructorName );

            % Assert that the type is correct.
            testCase.assertClass( component, ConstructorName, ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'an object of type ', ConstructorName, '.'] )

            % Assert that the returned object is a scalar.
            testCase.assertSize( component, [1, 1], ...
                ['The ', ConstructorName, ...
                ' constructor did not return a scalar object.'] )
            disp("pass 12");
        end % tConstructorWithNoArgumentsReturnsScalarComponent

        function tConstructorWithAnEmptyParentIsWarningFree( ...
                testCase, ConstructorName )
            disp("check 13");
            % Verify that constructing a component with the 'Parent'
            % property set to [] is warning-free.
            creator = @() constructComponentWithoutFixture( ...
                ConstructorName, 'Parent', [] );
            testCase.verifyWarningFree( creator, ...
                ['The ', ConstructorName, ' constructor was ', ...
                'not warning-free when called with ''Parent'' ', ...
                'set to [].'] )
            disp("pass 13");
        end % tConstructorWithAnEmptyParentIsWarningFree

        function tConstructorWithAnEmptyParentReturnsScalarComponent( ...
                testCase, ConstructorName )
            disp("check 14");
            % Call the constructor with an empty 'Parent' input.
            component = constructComponentWithoutFixture( ...
                ConstructorName, 'Parent', [] );

            % Assert that the type is correct.
            testCase.assertClass( component, ConstructorName, ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'an object of type ', ConstructorName, '.'] )

            % Assert that the returned object is a scalar.
            testCase.assertSize( component, [1, 1], ...
                ['The ', ConstructorName, ...
                ' constructor did not return a scalar object.'] )
            disp("pass 14");
        end % tConstructorWithAnEmptyParentReturnsScalarComponent

        function tAutoParentBehaviorIsCorrect( testCase, ConstructorName )
            disp("check 15");
            % Testing auto-parenting behavior only applies to containers in
            % the uiextras namespace. Containers in the uix namespace do
            % not exhibit auto-parenting behavior.
            testCase.assumeComponentIsFromNamespace( ...
                ConstructorName, 'uiextras' )

            % Create a new figure.
            newFig = figure();
            testCase.addTeardown( @() delete( newFig ) )

            % Instantiate the component, without specifying the parent.
            component = feval( ConstructorName );
            testCase.addTeardown( @() delete( component ) )

            % Verify the class and size of the component.
            testCase.assertClass( component, ConstructorName, ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'an object of type ', ConstructorName, '.'] )
            testCase.assertSize( component, [1, 1], ...
                ['The ', ConstructorName, ...
                ' constructor did not return a scalar object.'] )

            % Verify that the parent of the component is the new figure we
            % created above.
            testCase.verifySameHandle( component.Parent, newFig, ...
                [ConstructorName, ' has not auto-parented correctly.'] )
            disp("pass 15");
        end % tAutoParentBehaviorIsCorrect

        function tConstructorWithParentArgumentIsWarningFree( ...
                testCase, ConstructorName )
            disp("check 16");
            % Verify that calling the component constructor with the
            % 'Parent' input argument given by the figure fixture is
            % warning-free.
            creator = @() testCase.constructComponent( ConstructorName );
            testCase.verifyWarningFree( creator, ...
                ['The ', ConstructorName, ' constructor was not ', ...
                'warning-free when called with the ''Parent'' input ', ...
                'argument.'] )
            disp("pass 16");
        end % tConstructorWithParentArgumentIsWarningFree

        function tConstructorWithParentArgumentReturnsScalarComponent( ...
                testCase, ConstructorName )
            disp("check 17");
            % Call the component constructor.
            component = testCase.constructComponent( ConstructorName );

            % Assert that the type is correct.
            testCase.assertClass( component, ConstructorName, ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'an object of type ', ConstructorName, ' when called ', ...
                'with the ''Parent'' input argument.'] )

            % Assert that the returned object is a scalar.
            testCase.assertSize( component, [1, 1], ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'a scalar object when called with the ''Parent'' ', ...
                'input argument.'] )
            disp("pass 17");
        end % tConstructorWithParentArgumentReturnsScalarComponent

        function tConstructorSetsRepeatedNameValuePairsCorrectly( ...
                testCase, ConstructorName )
            disp("check 18");
            % Create the component, passing in repeated name-value pairs.
            component = testCase.constructComponent( ConstructorName, ...
                'Tag', '1', 'Tag', '2', 'Tag', '3' );
            % Verify that the 'Tag' has been set correctly.
            testCase.verifyEqual( component.Tag, '3', ...
                ['The ', ConstructorName, ' constructor did not set ', ...
                'the ''Tag'' correctly when this property was passed ', ...
                'multiple times to the constructor.'] )
            disp("pass 18");
        end % tConstructorSetsRepeatedNameValuePairsCorrectly

        function tConstructorErrorsWithBadArguments( ...
                testCase, ConstructorName )
            disp("check 19");
            % Test with providing the name of a property only.
            invalidConstructor = @() testCase.constructComponent( ...
                ConstructorName, 'BackgroundColor' );
            testCase.verifyError( ...
                invalidConstructor, 'uix:InvalidArgument' )

            % Test with providing a property value only.
            invalidConstructor = @() testCase.constructComponent( ...
                ConstructorName, 200 );
            testCase.verifyError( ...
                invalidConstructor, 'uix:InvalidArgument' );
            disp("pass 19");
        end % tConstructorErrorsWithBadArguments

        function tChildObserverDoesNotIncorrectlyAddElements( ...
                testCase, ConstructorName )
            disp("check 20");
            % Create the component and verify that its 'Contents' property
            % has no elements.
            component = testCase.constructComponent( ConstructorName );
            testCase.verifyNumElements( component.Contents, 0 )

            % Add a control, and set its 'Internal' property to false.
            c = uicontrol( 'Parent', component );
            c.Internal = false;

            % Verify that the component's 'Contents' property has one
            % element.
            testCase.verifyNumElements( component.Contents, 1 )
            disp("pass 20");
        end % tChildObserverDoesNotIncorrectlyAddElements

        function tContentsAreUpdatedWhenChildrenAreAdded( ...
                testCase, ConstructorName )
            disp("check 21");
            % Create the component, with children.
            [component, kids] = testCase...
                .constructComponentWithChildren( ConstructorName );
            % Verify that the contents are equal to the list of children.
            testCase.verifyEqual( component.Contents, kids, ...
                ['The ', ConstructorName, ' component has not ', ...
                'updated its ''Contents'' property correctly when ', ...
                'controls were added.'] )
            disp("pass 21");
        end % tContentsAreUpdatedWhenChildrenAreAdded

        function tContentsAreUpdatedWhenAChildIsDeleted( testCase, ...
                ConstructorName )
            disp("check 22");
            % Create the component, with children.
            [component, kids] = testCase...
                .constructComponentWithChildren( ConstructorName );

            % Delete a child.
            delete( kids(2) )

            % Verify that the 'Contents' property has been updated.
            testCase.verifyEqual( component.Contents, kids([1, 3, 4]), ...
                ['The ', ConstructorName, ' component has not ', ...
                'updated its ''Contents'' property correctly when ', ...
                'a child was deleted.'] )
            disp("pass 22");
        end % tContentsAreUpdatedWhenAChildIsDeleted

        function tContentsAreUpdatedWhenAChildIsReparented( ...
                testCase, ConstructorName )
            disp("check 23");
            % Create the component, with children.
            [component, kids] = testCase...
                .constructComponentWithChildren( ConstructorName );

            % Reparent a child.
            kids(2).Parent = testCase.ParentFixture.Parent;
            testCase.addTeardown( @() delete( kids(2) ) )

            % Verify that the 'Contents' property has been updated.
            testCase.verifyEqual( component.Contents, kids([1, 3, 4]), ...
                ['The ', ConstructorName, ' component has not ', ...
                'updated its ''Contents'' property correctly when ', ...
                'a child was reparented.'] )
            disp("pass 23");
        end % tContentsAreUpdatedWhenAChildIsReparented

        function tContentsAreUpdatedAfterChildrenAreReordered( ...
                testCase, ConstructorName )
            disp("check 24");
            % Create the component, with children.
            component = testCase...
                .constructComponentWithChildren( ConstructorName );

            % Reorder the children.
            previousContents = component.Contents;
            component.Children = component.Children(4:-1:1);

            % Verify that the 'Contents' property has been updated.
            testCase.verifyEqual( component.Contents, ...
                previousContents(4:-1:1), ...
                ['The ', ConstructorName, ' component has not ', ...
                'updated its ''Contents'' property correctly when ', ...
                'the children were reordered.'] )
            disp("pass 24");
        end % tContentsAreUpdatedAfterChildrenAreReordered

        function tPlottingInAxesInComponentRespectsContents( ...
                testCase, ConstructorName )
            disp("check 25");
            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Add two axes.
            ax(1) = axes( 'Parent', component );
            ax(2) = axes( 'Parent', component );

            % Plot into these axes.
            plot( ax(1), 1:10 )
            plot( ax(2), 1:10 )

            % Verify that the component's 'Contents' property is correct.
            testCase.verifyNumElements( component.Contents, 2, ...
                ['Plotting in axes in a ', ConstructorName, ...
                ' component resulted in the incorrect number of ', ...
                '''Contents''.'] )
            diagnostic = ['Plotting in axes in a ', ConstructorName, ...
                ' component resulted in an incorrect value for ', ...
                'the ''Contents'' property.'];
            testCase.verifySameHandle( ...
                component.Contents(1), ax(1), diagnostic )
            testCase.verifySameHandle( ...
                component.Contents(2), ax(2), diagnostic )
            disp("pass 25");
        end % tPlottingInAxesInComponentRespectsContents

        function tAxesInComponentRemainsVisibleAfter3DRotation( ...
                testCase, ConstructorName )
            disp("check 26");
            % Assume the component is rooted.
            testCase.assumeGraphicsAreRooted()

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Add an axes.
            ax = axes( 'Parent', component );

            % Enable 3D rotation mode.
            rotate3d( ax, 'on' )

            % Verify that the axes is still visible.
            testCase.verifyEqual( char( ax.Visible ), 'on', ...
                ['Enabling 3D rotation mode on an axes within a ', ...
                ConstructorName, ' component made the axes invisible.'] )
            disp("pass 26");
        end % tAxesInComponentRemainsVisibleAfter3DRotation

        function tEnablingDataCursorModePreservesAxesPosition( ...
                testCase, ConstructorName )
            disp("check 27");
            % Data cursor mode only works in Java figures, so we need to
            % exclude the unrooted and Web figure cases.
            testCase.assumeGraphicsAreRooted()
            testCase.assumeGraphicsAreNotWebBased()

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Add an axes.
            ax = axes( 'Parent', component );

            % Ensure that the axes is not too small.
            if isprop( component, 'ButtonSize' )
                component.ButtonSize = [200, 200];
            end % if

            % Plot into the axes.
            p = plot( ax, 1:10 );

            % Enable data cursor mode.
            dcm = datacursormode( component.Parent );
            dcm.Enable = 'on';
            drawnow()

            % Capture the current axes position, add a datatip, then
            % capture the axes position again.
            oldPosition = ax.Position;
            dcm.createDatatip( p );
            drawnow()
            newPosition = ax.Position;

            % Verify that the axes 'Position' property has not changed.
            testCase.verifyEqual( newPosition, oldPosition, ...
                ['Enabling data cursor mode on an axes in a ', ...
                ConstructorName, ' component caused the axes ', ...
                '''Position'' property to change.'] )
            disp("pass 27");
        end % tEnablingDataCursorModePreservesAxesPosition

        function tContentsRespectAddingAxesAndControl( ...
                testCase, ConstructorName )
            disp("check 28");
            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Add an axes.
            ax = axes( 'Parent', component );

            % Add a control.
            c = uicontrol( 'Parent', component );

            % Verify the 'Contents' property is correct initially.
            diagnostic = ['Adding an axes and a control to a ', ...
                ConstructorName, ' component resulted in an ', ...
                'incorrect value for the ''Contents'' property.'];
            testCase.verifyEqual( ...
                component.Contents, [ax; c], diagnostic )

            % Wait, and then repeat the verification.
            pause( 0.1 )
            testCase.verifyEqual( ...
                component.Contents, [ax; c], diagnostic )
            disp("pass 28");
        end % tContentsRespectAddingAxesAndControl

        function tSettingContentsAcceptsRowOrientation( ...
                testCase, ConstructorName )
            disp("check 29");
            % Create a component with children.
            [component, kids] = testCase...
                .constructComponentWithChildren( ConstructorName );

            % Permute the 'Contents' property and set it as a row vector
            % (rather than a column vector).
            flipPerm = length( kids ) : -1 : 1;
            component.Contents = transpose( component.Contents(flipPerm) );

            % Verify that the 'Contents' property has been updated
            % correctly.
            testCase.verifySameHandle( component.Contents, ...
                kids(flipPerm), ...
                ['Setting the ''Contents'' property of the ', ...
                ConstructorName, ' component as a row vector did not ', ...
                'assign the value correctly.'] )
            disp("pass 29");
        end % tSettingContentsAcceptsRowOrientation

        function tContainerEnableGetMethod( testCase, ConstructorName )
            disp("check 30");
            % Filter the test if the container does not have get and set
            % methods for the 'Enable' property.
            testCase.assumeComponentHasEnableGetSetMethods( ...
                ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Verify that the 'Enable' property is set to 'on'.
            testCase.verifyEqual( component.Enable, 'on', ...
                ['The ''Enable'' property of the ', ConstructorName, ...
                'container is not set to ''on''.'] )
            disp("pass 30");
        end % tContainerEnableGetMethod

        function tContainerEnableSetMethod( testCase, ConstructorName )
            disp("check 31");
            % Filter the test if the container does not have get and set
            % methods for the 'Enable' property.
            testCase.assumeComponentHasEnableGetSetMethods( ...
                ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Check that setting 'on' or 'off' is accepted.
            for enable = {'on', 'off'}
                enableSetter = ...
                    @() set( component, 'Enable', enable{1} );
                testCase.verifyWarningFree( enableSetter, ...
                    [ConstructorName, ' has not accepted a value ', ...
                    'of ''', enable{1}, ...
                    ''' for the ''Enable'' property.'] )
            end % for

            % Check that setting an invalid value causes an error.
            errorID = 'uiextras:InvalidPropertyValue';
            invalidSetter = @() set( component, 'Enable', {} );
            testCase.verifyError( invalidSetter, errorID, ...
                [ConstructorName, ' has not produced an ', ...
                'error with the expected ID when the ''Enable'' ', ...
                'property was set to an invalid value.'] )
            disp("pass 31")
        end % tContainerEnableSetMethod

        function tContainerDynamicEnableGetMethod( ...
                testCase, ConstructorName )
            disp("check 32");
            % Filter the test if the component does not have a dynamic
            % 'Enable' property.
            testCase.assumeComponentHasDynamicEnableProperty( ...
                ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Verify that the 'Enable' property exists and is set to
            % 'on'.
            testCase.assertTrue( isprop( component, 'Enable' ), ...
                [ConstructorName, ' does not ', ...
                'have the ''Enable'' property.'] )
            testCase.verifyTrue( strcmp( component.Enable, 'on' ), ...
                ['The ''Enable'' property of the ', ...
                ConstructorName, ' is not set to ''on''.'] )
            disp("pass 32");
        end % tContainerDynamicEnableGetMethod

        function tContainerDynamicEnableSetMethod( ...
                testCase, ConstructorName )
            disp("check 33");
            % Filter the test if the component does not have a dynamic
            % 'Enable' property.
            testCase.assumeComponentHasDynamicEnableProperty( ...
                ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Check that setting 'on' or 'off' is accepted.
            for enable = {'on', 'off'}
                enableSetter = ...
                    @() set( component, 'Enable', enable{1} );
                testCase.verifyWarningFree( enableSetter, ...
                    [ConstructorName, ' has not accepted a value ', ...
                    'of ''', enable{1}, ...
                    ''' for the ''Enable'' property.'] )
            end % for

            % Check that setting an invalid value causes an error.
            if verLessThan( 'matlab', '9.9' )
                errorID = 'uiextras:InvalidPropertyValue';
            else
                errorID = ...
                    'MATLAB:datatypes:onoffboolean:IncorrectValue';
            end % if
            invalidSetter = @() set( component, 'Enable', {} );
            testCase.verifyError( invalidSetter, errorID, ...
                [ConstructorName, ' has not produced an ', ...
                'error with the expected ID when the ''Enable'' ', ...
                'property was set to an invalid value.'] )
            disp("pass 33");
        end % tContainerDynamicEnableSetMethod

        function tGetSelectedChild( testCase, ConstructorName )
            disp("check 34");
            % Filter the test if the component does not have the
            % 'SelectedChild' property.
            testCase.assumeComponentHasSelectedChildProperty( ...
                ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Verify that the 'SelectedChild' property is equal to [] (for
            % Panel and BoxPanel) or 0 (for CardPanel and TabPanel).
            if ismember( ConstructorName, ...
                    {'uiextras.CardPanel', 'uiextras.TabPanel'} )
                expectedValue = 0;
            else
                expectedValue = [];
            end % if
            testCase.verifyEqual( component.SelectedChild, ...
                expectedValue, ...
                ['The ''SelectedChild'' property of ', ...
                ConstructorName, ' is not equal to [].'] )

            % Add a child to the component.
            uicontrol( component )

            % Verify that the 'SelectedChild' property is equal to 1.
            testCase.verifyEqual( component.SelectedChild, 1, ...
                ['The ''SelectedChild'' property of ', ...
                ConstructorName, ' is not equal to 1.'] )
            disp("pass 34");
        end % tGetSelectedChild

        function tSetSelectedChild( testCase, ConstructorName )
            disp("check 35");
            % Filter the test if the component does not have the
            % 'SelectedChild' property.
            testCase.assumeComponentHasSelectedChildProperty( ...
                ConstructorName )

            % Create the component.
            component = testCase.constructComponentWithChildren( ...
                ConstructorName );

            % Verify that setting the 'SelectedChild' property is
            % warning-free.
            setter = @() set( component, 'SelectedChild', 1 );
            testCase.verifyWarningFree( setter, ...
                [ConstructorName, ' did not accept setting the ', ...
                '''SelectedChild'' property.'] )
            disp("pass 35");
        end % tSetSelectedChild

        function tAutoResizeChildrenIsNotAProperty( ...
                testCase, ConstructorName )
            disp("check 36");
            % This test is only for containers (not panels).
            testCase.assumeComponentIsAContainer( ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % Verify that it does not have the 'AutoResizeChildren'
            % property.
            hasAutoResizeChildren = ...
                isprop( component, 'AutoResizeChildren' );
            testCase.verifyFalse( hasAutoResizeChildren, ...
                ['The ', ConstructorName, ' component has the ', ...
                '''AutoResizeChildren'' property. '] )
            disp("pass 36");
        end % tAutoResizeChildrenIsNotAProperty

        function tAutoResizeChildrenIsOffForPanels( ...
                testCase, ConstructorName )
            disp("check 37");
            % This test is only for panels (not containers).
            testCase.assumeComponentIsAPanel( ConstructorName )

            % Create the component.
            component = testCase.constructComponent( ConstructorName );

            % The 'AutoResizeChildren' property was added to
            % matlab.ui.container.Panel in R2017a, so we need to check
            % whether this property exists to accommodate older releases.
            if isprop( component, 'AutoResizeChildren' )
                autoResizeKids = char( component.AutoResizeChildren );
                testCase.verifyEqual( autoResizeKids, 'off', ...
                    ['Expected the ''AutoResizeChildren'' property ', ...
                    'of the ', ConstructorName, ' component to be ', ...
                    '''off''.'] )
            end % if
            disp("pass 37");
        end % tAutoResizeChildrenIsOffForPanels

        function tSettingAutoResizeChildrenToOffIsPreserved( ...
                testCase, ConstructorName )
            disp("check 38");
            % This test is only for panels (not containers).
            testCase.assumeComponentIsAPanel( ConstructorName )

            % The 'AutoResizeChildren' property was added to
            % matlab.ui.container.Panel in R2017a, so we need to be in this
            % version or later to run this test.
            testCase.assumeMATLABVersionIsAtLeast( 'R2017a' )

            % Create the component, setting 'AutoResizeChildren' to 'off'.
            component = testCase.constructComponent( ConstructorName, ...
                'AutoResizeChildren', 'off' );

            % Verify that the constructor switched this property off.
            autoResizeKids = char( component.AutoResizeChildren );
            testCase.verifyEqual( autoResizeKids, 'off', ...
                ['The ', ConstructorName, ' constructor did not ', ...
                'turn off the ''AutoResizeChildren'' property.'] )
            disp("pass 38");
        end % tSettingAutoResizeChildrenToOffIsPreserved
%}
    end % methods ( Test, Sealed )
%{
    methods ( Test, Sealed, ParameterCombination = 'sequential' )

        function tConstructorIsWarningFreeWithArguments( ...
                testCase, ConstructorName, NameValuePairs )
            disp("check 39");
            % Verify that creating the component and passing additional
            % input arguments to the constructor is warning-free.
            %creator = @() testCase.constructComponent( ...
            %    ConstructorName, NameValuePairs{:} );
            %testCase.verifyWarningFree( creator, ...
             %   ['The ', ConstructorName, ' constructor was not ', ...
            %    'warning-free when called with additional ', ...
            %    'input arguments.'] )
            disp("pass 39");
        end % tConstructorIsWarningFreeWithArguments

        function tConstructorWithArgumentsReturnsScalarComponent( ...
                testCase, ConstructorName, NameValuePairs )
            disp("check 40");
            % Call the component constructor.
            component = testCase.constructComponent( ...
                ConstructorName, NameValuePairs{:} );

            % Assert that the type is correct.
            testCase.assertClass( component, ConstructorName, ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'an object of type ', ConstructorName, ' when called ', ...
                'with the ''Parent'' input argument and additional ', ...
                'input arguments.'] )

            % Assert that the returned object is a scalar.
            testCase.assertSize( component, [1, 1], ...
                ['The ', ConstructorName, ...
                ' constructor did not return ', ...
                'a scalar object when called with the ''Parent'' ', ...
                'input argument and additional input arguments.'] )
            disp("pass 40");
        end % tConstructorWithArgumentsReturnsScalarComponent

        function tConstructorSetsNameValuePairsCorrectly( ...
                testCase, ConstructorName, NameValuePairs )
            disp("check 41");
            % Call the component constructor.
            component = testCase.constructComponent( ...
                ConstructorName, NameValuePairs{:} );

            % Verify that the component constructor has correctly assigned
            % the name-value pairs.
            for k = 1 : 2 : length( NameValuePairs )-1
                propertyName = NameValuePairs{k};
                propertyValue = NameValuePairs{k+1};
                actualValue = component.(propertyName);
                if ~isa( propertyValue, 'function_handle' )
                    classOfPropertyValue = class( propertyValue );
                    actualValue = feval( ...
                        classOfPropertyValue, actualValue );
                end % if
                testCase.verifyEqual( actualValue, propertyValue, ...
                    ['The ', ConstructorName, ' constructor has not ', ...
                    'assigned the ''', propertyName, ''' property ', ...
                    'correctly.'] )
            end % for
            disp("pass41");
        end % tConstructorSetsNameValuePairsCorrectly

        function tGetAndSetMethodsFunctionCorrectly( ...
                testCase, ConstructorName, NameValuePairs )
            disp("check 42");
            % Construct the component.
            component = testCase.constructComponent( ConstructorName );

            % For each property, set its value and verify that the
            % component has correctly assigned the value.
            for k = 1 : 2 : length( NameValuePairs )
                % Extract the current name-value pair.
                propertyName = NameValuePairs{k};
                propertyValue = NameValuePairs{k+1};
                % Set the property in the component.
                component.(propertyName) = propertyValue;
                % Verify that the property has been assigned correctly, up
                % to a possible data type conversion.
                actual = component.(propertyName);
                if ~isa( propertyValue, 'function_handle' )
                    propertyClass = class( propertyValue );
                    actual = feval( propertyClass, actual );
                end % if
                testCase.verifyEqual( actual, propertyValue, ...
                    ['Setting the ''', propertyName, ''' property of ', ...
                    'the ', ConstructorName, ' object did not store ', ...
                    'the value correctly.'] )
            end % for
            disp("pass 42");
        end % tGetAndSetMethodsFunctionCorrectly

    end % methods ( Test, Sealed, ParameterCombination = 'sequential' )
%}
    methods ( Sealed, Access = protected )

        function [component, componentChildren] = ...
                constructComponentWithChildren( testCase, constructorName )

            % Create a component of the type specified by the
            % constructorName input. Add three buttons with red, green, and
            % blue background colors, with an empty space between green and
            % blue. Return the four child references in the output argument
            % componentChildren.
            component = testCase.constructComponent( constructorName );
            componentChildren = [
                uicontrol( 'Parent', component, 'BackgroundColor', 'r' )
                uicontrol( 'Parent', component, 'BackgroundColor', 'g' )
                uiextras.Empty( 'Parent', component )
                uicontrol( 'Parent', component, 'BackgroundColor', 'b' )];

        end % constructComponentWithChildren

        function assumeComponentIsFromNamespace( testCase, ...
                ConstructorName, namespace )

            % Check whether the given container, specified by
            % ConstructorName, belongs to the given namespace.
            condition = strncmp( ConstructorName, namespace, ...
                length( namespace ) );
            testCase.assumeTrue( condition, ...
                ['The component ', ConstructorName, ...
                ' is not from the ', namespace, ' namespace.'] )

        end % assumeComponentIsFromNamespace

        function assumeComponentHasDynamicEnableProperty( ...
                testCase, ConstructorName )

            % Assume that the component, specified by ConstructorName, has
            % a dynamic 'Enable' property.
            testCase.assumeTrue( ismember( ConstructorName, ...
                testCase.ContainersWithDynamicEnableProperty ), ...
                ['The component ', ConstructorName, ' does not have ', ...
                'a dynamic ''Enable'' property.'] )

        end % assumeComponentHasDynamicEnableProperty

        function assumeComponentHasEnableGetSetMethods( ...
                testCase, ConstructorName )

            % Assume that the component, specified by ConstructorName, has
            % get and set methods defined for its 'Enable' property.
            testCase.assumeTrue( ismember( ConstructorName, ...
                testCase.ContainersWithEnableGetAndSetMethods ), ...
                ['The component ', ConstructorName, ' does not have ', ...
                'get and set methods defined for its ', ...
                '''Enable'' property.'] )

        end % assumeContainerHasEnableGetSetMethods

        function assumeComponentHasSelectedChildProperty( ...
                testCase, ConstructorName )

            % Assume that the component, specified by ConstructorName, has
            % the 'SelectedChild' property.
            testCase.assumeTrue( ismember( ConstructorName, ...
                testCase.ContainersWithSelectedChildProperty ), ...
                ['The component ', ConstructorName, ' does not have ', ...
                'the ''SelectedChild'' property.'] )

        end % assumeComponentHasSelectedChildProperty

        function assumeComponentIsAPanel( testCase, ConstructorName )

            % Assume that the component, specified by ConstructorName, has
            % matlab.ui.container.Panel as one of its superclasses.
            panelClassName = 'matlab.ui.container.Panel';
            isapanel = ismember( panelClassName, ...
                superclasses( ConstructorName ) );
            testCase.assumeTrue( isapanel, ...
                ['This test is only applicable to subclasses of ', ...
                panelClassName, '.'] )

        end % assumeComponentIsAPanel

        function assumeComponentIsAContainer( testCase, ConstructorName )

            % Assume that the component, specified by ConstructorName, has
            % uix.Container (and thus
            % matlab.ui.container.internal.UIContainer) as one of its
            % superclasses.
            containerClassName = 'uix.Container';
            isacontainer = ismember( containerClassName, ...
                superclasses( ConstructorName ) );
            testCase.assumeTrue( isacontainer, ...
                ['This test is only applicable to subclasses of ', ...
                containerClassName, '.'] )

        end % assumeComponentIsAContainer

    end % methods ( Sealed, Access = protected )

end % class

function varargout = ...
    constructComponentWithoutFixture( ConstructorName, varargin )
%CONSTRUCTCOMPONENTWITHOUTFIXTURE Construct a component of type
%ConstructorName, passing optional name-value pair arguments to the
%constructor. Optionally, return the component reference as an output
%argument for further testing. This local function does not use the figure
%fixture to facilitate component testing without necessarily using the
%'Parent' input argument.

% Check the number of output arguments.
nargoutchk( 0, 1 )

% Construct the component.
component = feval( ConstructorName, varargin{:} );

% Ensure it is cleaned up.
componentCleanup = onCleanup( @() delete( component ) );

% Return the component reference, if required.
if nargout == 1
    varargout{1} = component;
end % if

end % constructComponentWithoutFixture
