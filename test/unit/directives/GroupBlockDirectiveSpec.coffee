describe 'GroupBlockDirective:', ()->
  blockTemplate = '<faber-group-block></faber-group-block>'

  config = null
  rootScope = null
  compile = null
  injector = null
  componentsService = null

  createDirective = (template)->
    scope = rootScope.$new()
    element = compile(template or blockTemplate)(scope)
    element.data('$injector', injector)

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
      injector = $injector
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
    ,
      GroupItemComponent
    ]

    @element = createDirective()
    @scope = @element.scope()

    @scope.block.component = 'group-component'
    @scope.$digest()

  describe 'when initialised,', ->
    it 'should have interchangeable group component list', ->
      expect(@element.find('option').length).toBe 2

    it 'should have a button to add group item', ->
      componentsScope = angular.element(@element.find('faber-components')).scope()
      componentsScope.showingComponents = true
      componentsScope.$digest()

      button = angular.element @element.find('faber-components').find('button')

      expect(button.length).toBe 1
      expect(button.text()).toBe 'Item'

  describe 'when switch to other group component', ->
    beforeEach ->
      @scope.currentComponent = 'another-group-component'
      @scope.$digest()

    it 'should show the correct component name', ->
      expect(@scope.component.id).toBe 'another-group-component'
      expect(@scope.component.name).toBe 'Another Group Component'

    it 'should select the block after switch the component', ->
      expect(@scope.isSelected).toBeTruthy()

  describe 'when add group item button is clicked', ->
    beforeEach ->
      componentsScope = angular.element(@element.find('faber-components')).scope()
      componentsScope.showingComponents = true
      componentsScope.$digest()

      @button = angular.element @element.find('faber-components').find('button')
      @button.triggerHandler('click')
      @scope.$digest()

    it 'should add a group item block', ->
      expect(@scope.block.blocks.length).toBe 1
      expect(@element.find('faber-block').length).toBe 1
      expect(@element.find('faber-block')[0].querySelectorAll('.group-item').length).toBe 1
