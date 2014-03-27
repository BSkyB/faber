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
      componentsService.init [comp]

      rootScope = $rootScope
      scope = $rootScope.$new()
      scope.passedDownBlock = component: 'sample-component'
      blockElement = $compile('<faber-block data-faber-block-content="passedDownBlock"></faber-block>')(scope)
      scope.$digest()
      @blockScope = blockElement.isolateScope()
      @element = blockElement.find('faber-component-renderer')
      @scope = @element.isolateScope()

      @scope.$digest()

  describe 'when render a component', ->
    it 'should be able to render the template of the given component', ->
      expect(@element.text()).toBe 'Sample Component'

    it 'should be able to call init callback of the component', ->
      expect(callbacks.initCallback).toHaveBeenCalled()

  describe 'when selected the rendered block', ->
    it 'should be able to call selected callback of the component', ->
      rootScope.$broadcast 'SelectBlock', @blockScope.$id
      @blockScope.$digest()

      expect(callbacks.selectedCallback).toHaveBeenCalled()

  describe 'when unselected the rendered block', ->
    it 'should be able to call unselected callback of the component', ->
      @scope.unselect()

      expect(callbacks.unselectedCallback).toHaveBeenCalled()

  describe 'when update is called with content data', ->
    it 'shoud update the block\'s content data', ->
      @scope.update('<p>Lorem ipsum</p>')

      expect(@scope.block.content).toBe '<p>Lorem ipsum</p>'