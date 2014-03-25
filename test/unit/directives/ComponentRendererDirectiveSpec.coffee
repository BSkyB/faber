describe 'Component Renderer Directive:', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($templateCache, $compile, $rootScope, $injector)->
      componentsService = $injector.get 'componentsService'
      comp = ()->
        id: 'sample-component'
        type: 'element'
        template: '<p>Sample Component</p>'
        init: ()->
        selected: ()->
        unselected: ()->
      componentsService.init [comp]

      scope = $rootScope.$new()
      scope.passedDownBlock = { component: 'sample-component' }
      blockElement = $compile('<faber-block data-faber-block-content="passedDownBlock"><faber-component-renderer></faber-component-renderer></faber-block>')(scope)
      scope.$digest()
      blockScope = blockElement.isolateScope()
      @element = $compile(angular.element(blockElement.find('faber-component-renderer')))(blockScope)
      @scope = @element.scope()

      @comp = @scope.component

      spyOn @comp, 'init'
      spyOn @comp, 'selected'
      spyOn @comp, 'unselected'

      @scope.$digest()

  describe 'when render a component', ->
    it 'should be able to render the template of the given component', ->
      expect(@element.text()).toBe 'Sample Component'

    it 'should be able to call init callback of the component', ->
      expect(@scope.component.init).toHaveBeenCalled()

  describe 'when selected the rendered block', ->
    it 'should be able to call selected callback of the component', ->
      expect(@scope.component.selected).toHaveBeenCalled()

  describe 'when unselected the rendered block', ->
    it 'should be able to call unselected callback of the component', ->
      @scope.renderer.unselect()

      expect(@scope.component.unselected).toHaveBeenCalled()

  describe 'when update is called with content data', ->
    it 'shoud update the block\'s content data', ->
      @scope.renderer.update('<p>Lorem ipsum</p>')

      expect(@scope.block.content).toBe '<p>Lorem ipsum</p>'