describe 'ComponentRendererDirective:', ->
  rootScope = null

  callbacks =
    initCallback: ()->
    selectedCallback: ()->
    unselectedCallback: ()->

  elementComp = ()->
    id: 'sample-component'
    type: 'element'
    template: '<p>{{ block.content }}</p>'
    init: ($scope, $element, initialContent, update)->
      callbacks.initCallback($scope, $element, initialContent, update)
    selected: ($scope, $element, update)->
      callbacks.selectedCallback($scope, $element, update)
    unselected: ($scope, $element, update)->
      callbacks.unselectedCallback($scope, $element, update)

  groupComp = ()->
    id: 'group-component'
    type: 'group'
    template: '<ol><li ng-repeat="b in block.blocks">{{ b.content }}</li></ol>'
    init: ($scope, $element, content)->
      callbacks.initCallback($scope, $element, content)

  beforeEach module 'faber'

  beforeEach ->
    spyOn callbacks, 'initCallback'
    spyOn callbacks, 'selectedCallback'
    spyOn callbacks, 'unselectedCallback'

    inject ($rootScope, componentsService, $injector)->
      componentsService = $injector.get 'componentsService'
      componentsService.init [
        elementComp
        groupComp
        GroupItemComponent
      ]

      rootScope = $rootScope

  describe 'when rendering an element component', ->
    beforeEach ->
      inject ($templateCache, $compile)->
        rootScope.block =
          component: 'group-component'
          blocks: [
            component: 'sample-component'
            content: 'Sample Component'
          ]
        scope = rootScope.$new()
        scope.passedDownBlock = rootScope.block.blocks[0]
        blockElement = $compile('<faber-block data-faber-block-content="passedDownBlock"></faber-block>')(scope)
        scope.$digest()
        @blockScope = blockElement.isolateScope()
        @element = blockElement.find('faber-component-renderer')
        @scope = @element.isolateScope()

        @scope.$digest()

    it 'should know if it is in group preview mode', ->
      inject ($rootScope, $compile)->
        scope = $rootScope.$new()
        scope.block =
          component: 'sample-component'
        scope.isGroupPreview = ()->
          true
        el = $compile('<faber-component-renderer data-faber-component-renderer-block="block" data-faber-group-preview="isGroupPreview()"></faber-component-renderer>')(scope)
        rendererScope = el.isolateScope()

        expect(rendererScope.isGroupPreview).toBe true

    it 'should be able to render the template of the given component', ->
      expect(@element.text()).toBe 'Sample Component'

    it 'should be able to call init callback of the component', ->
      expect(callbacks.initCallback).toHaveBeenCalled()
      expect(callbacks.initCallback.mostRecentCall.args[0]).toEqual @scope
      expect(callbacks.initCallback.mostRecentCall.args[1]).toEqual @element

    describe 'when selected the rendered block', ->
      it 'should be able to call selected callback of the component', ->
        rootScope.$broadcast 'SelectBlockOfIndex', rootScope, 0
        @blockScope.$digest()

        expect(callbacks.selectedCallback).toHaveBeenCalled()
        expect(callbacks.selectedCallback.mostRecentCall.args[0]).toEqual @scope
        expect(callbacks.selectedCallback.mostRecentCall.args[1]).toEqual @element

    describe 'when unselected the rendered block', ->
      describe 'if the block is not already selected', ->
        it 'should not call unselected callback of the component', ->
          @scope.isSelected = false
          @blockScope.$digest()

          rootScope.$broadcast 'SelectBlockOfIndex', rootScope, 1
          @blockScope.$digest()

          expect(callbacks.unselectedCallback).not.toHaveBeenCalled()

      describe 'if the block is already selected', ->
        it 'should be able to call unselected callback of the component', ->
          @scope.selectRendered()
          @blockScope.$digest()

          rootScope.$broadcast 'SelectBlockOfIndex', rootScope, 1
          @blockScope.$digest()

          expect(callbacks.unselectedCallback).toHaveBeenCalled()
          expect(callbacks.unselectedCallback.mostRecentCall.args[0]).toEqual @scope
          expect(callbacks.unselectedCallback.mostRecentCall.args[1]).toEqual @element

    describe 'when update is called with content data', ->
      it 'shoud update the block\'s content data', ->
        @scope.updateRendered('Lorem ipsum')

        expect(@scope.block.content).toBe 'Lorem ipsum'

  describe 'when rendering a group component', ->
    beforeEach ->
      inject ($templateCache, $compile, $rootScope, $injector)->
        rootScope = $rootScope
        rootScope.block =
          component: 'group-component'
          blocks: [
            component: 'group-item'
            blocks: [
              component: 'sample-component'
              content: 'Lorem ipsum 1'
            ,
              component: 'sample-component'
              content: 'Lorem ipsum 2'
            ]
          ]
        scope = $rootScope.$new()
        scope.passedDownBlock = rootScope.block
        @blockElement = $compile('<faber-block data-faber-block-content="passedDownBlock"></faber-block>')(scope)
        @blockElement.data('$injector', $injector)
        scope.$digest()
        @blockScope = @blockElement.isolateScope()

        @groupItemBlockElement = angular.element(@blockElement.find('faber-block')[0])
        @groupItemBlockScope = @groupItemBlockElement.scope()
        @groupItemBlockScope.isExpanded = true
        @groupItemBlockScope.$digest()

    it 'should be able to render the template of the given components', ->
      expect(@groupItemBlockElement[0].querySelectorAll('.sample-component').length).toBe 2
      expect(angular.element(@groupItemBlockElement[0].querySelectorAll('.sample-component')[0]).text()).toBe 'Lorem ipsum 1'
      expect(angular.element(@groupItemBlockElement[0].querySelectorAll('.sample-component')[1]).text()).toBe 'Lorem ipsum 2'

    it 'should be able to call init callback of the component', ->
      firstRendererElement = angular.element @groupItemBlockElement.find('faber-component-renderer')[1]
      firstRendererScope = firstRendererElement.isolateScope()

      secondRendererElement = angular.element @groupItemBlockElement.find('faber-component-renderer')[2]
      secondRendererScope = secondRendererElement.isolateScope()

      expect(callbacks.initCallback).toHaveBeenCalled()
      expect(callbacks.initCallback.calls[0].args[0]).toEqual firstRendererScope
      expect(callbacks.initCallback.calls[0].args[1]).toEqual firstRendererElement
      expect(callbacks.initCallback.calls[1].args[0]).toEqual secondRendererScope
      expect(callbacks.initCallback.calls[1].args[1]).toEqual secondRendererElement
