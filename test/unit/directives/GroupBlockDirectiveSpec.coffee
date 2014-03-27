describe 'GroupBlockDirective:', ()->
  # Use faber-block directive as faber-group-block requires faber-block
  blockTemplate = '<faber-block data-faber-block-content="passedDownBlock"></faber-block>'

  config = null
  rootScope = null
  compile = null
  componentsService = null

  createDirective = (template)->
    scope = rootScope.$new()
    scope.passedDownBlock = { component: 'a component' }
    element = compile(template or blockTemplate)(scope)
    scope.$digest()

    return element

  beforeEach module 'faber'
  beforeEach ->
    inject ($rootScope, $compile, $injector, $templateCache, faberConfig)->
      $templateCache.put 'a-component', '<p>A component</p>'
      $templateCache.put 'group-component', '<p>Group component</p>'
      $templateCache.put 'child-component', '<p>Child component</p>'
      $templateCache.put 'top-level-only-component', '<p>Top level only component</p>'

      config = faberConfig
      config.expanded = false

      compile = $compile
      rootScope = $rootScope
      componentsService = $injector.get 'componentsService'

    componentsService.init [
      ()->
        id: 'a-component'
        type: 'element'
    ,
      ()->
        id: 'group-component'
        name: 'Group Component'
        type: 'group'
    ,
      ()->
        id: 'another-group-component'
        name: 'Another Group Component'
        type: 'group'
    ]

    @element = createDirective()
    @scope = @element.isolateScope()
    @scope.expanded = true
    @scope.block.component = 'group-component'
    @scope.$digest()

    @groupBlockElement = angular.element @element.find('faber-group-block')
    @groupBlockScope = @groupBlockElement.scope()

  describe 'when initialised,', ->
    it 'should be correctly initialised', ->
      expect(@element).toBeDefined()

    it 'should have interchangeable group component list', ->
      expect(@groupBlockElement.find('option').length).toBe 2

  describe 'when switch to other group component', ->
    beforeEach ->
      @groupBlockScope.currentComponent = 'another-group-component'
      @groupBlockScope.$digest()

    it 'should show the correct component name', ->
      expect(@groupBlockScope.component.id).toBe 'another-group-component'
      expect(@groupBlockScope.component.name).toBe 'Another Group Component'

    it 'should select the block after switch the component', ->
      expect(@scope.isSelected).toBeTruthy()

  xit 'should be able to collapse the block', ->
    expect(false).toBeTruthy()

  xit 'should be able to expand the block', ->
    expect(false).toBeTruthy()
