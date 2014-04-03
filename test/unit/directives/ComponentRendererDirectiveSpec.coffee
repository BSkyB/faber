describe 'ComponentRendererDirective:', ->
  rootScope = null

  callbacks =
    initCallback: ()->
    selectedCallback: ()->
    unselectedCallback: ()->

  beforeEach module 'faber'

  beforeEach ->

    inject ($templateCache, $compile, $rootScope, $injector)->

      spyOn callbacks, 'initCallback'
      spyOn callbacks, 'selectedCallback'
      spyOn callbacks, 'unselectedCallback'

      componentsService = $injector.get 'componentsService'
      comp = ()->
        id: 'sample-component'
        type: 'element'
        template: '<p>Sample Component</p>'
        init: ()->
          callbacks.initCallback()
        selected: ()->
          callbacks.selectedCallback()
        unselected: ()->
          callbacks.unselectedCallback()
      componentsService.init [
        ()->
          id: 'group-component'
          type: 'group'
      ,
        comp
      ]

      rootScope = $rootScope
      rootScope.block =
        component: 'group-component'
        blocks: [
          component: 'sample-component'
        ]
      scope = $rootScope.$new()
      scope.passedDownBlock = rootScope.block.blocks[0]
      blockElement = $compile('<faber-block data-faber-block-content="passedDownBlock"></faber-block>')(scope)
      scope.$digest()
      @blockScope = blockElement.isolateScope()
      @element = blockElement.find('faber-component-renderer')
      @scope = @element.isolateScope()

      @scope.$digest()

  describe 'when render a component', ->
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

  describe 'when selected the rendered block', ->
    it 'should be able to call selected callback of the component', ->
      rootScope.$broadcast 'SelectBlockOfIndex', rootScope, 0
      @blockScope.$digest()

      expect(callbacks.selectedCallback).toHaveBeenCalled()

  describe 'when unselected the rendered block', ->
    it 'should be able to call unselected callback of the component', ->
      @scope.unselectRendered()

      expect(callbacks.unselectedCallback).toHaveBeenCalled()

  describe 'when update is called with content data', ->
    it 'shoud update the block\'s content data', ->
      @scope.updateRendered('<p>Lorem ipsum</p>')

      expect(@scope.block.content).toBe '<p>Lorem ipsum</p>'