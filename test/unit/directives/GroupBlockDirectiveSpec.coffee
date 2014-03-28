describe 'GroupBlockDirective:', ()->
  blockTemplate = '<faber-group-block></faber-group-block>'

  config = null
  rootScope = null
  compile = null
  componentsService = null

  createDirective = (template)->
    scope = rootScope.$new()
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
    @scope = @element.scope()
    @scope.component = componentsService.findById 'group-component'
    @scope.$digest()

  describe 'when initialised,', ->
    it 'should have interchangeable group component list', ->
      expect(@element.find('option').length).toBe 2

    it 'should have a button to add group item', ->
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

  # TODO
  xdescribe 'when selected (edit mode),', ->
    it 'should be able to collapse the block', ->
      expect(false).toBeTruthy()

    it 'should be able to expand the block', ->
      expect(false).toBeTruthy()

  # TODO
  xdescribe 'when not selected (preview mode),', ->
    it 'should not allow to collapse the block', ->
      expect(false).toBeTruthy()

  describe 'when add group item button is clicked', ->
    beforeEach ->
      @button = angular.element @element.find('faber-components').find('button')
      @button.triggerHandler('click')
      @scope.$digest()

    it 'should add a group item block', ->
      expect(@scope.block.blocks.length).toBe 1
      expect(@element.find('faber-block').length).toBe 1
      expect(@element.find('faber-block').find('faber-group-item-block').length).toBe 1

    it 'should hilghight the new item block', ->
      firstScope = angular.element(@element.find('faber-block').find('faber-group-item-block')[0]).scope()

      expect(firstScope.isSelected).toBe true

      # toggle the last faber-components that contains add item block button
      lastFaberComponents = @element.find('faber-components')[2]
      lastFaberComponentsScope = angular.element(lastFaberComponents).scope()
      lastFaberComponentsScope.showingComponents = true
      @scope.$digest()

      # insert a new group item block at the end of the list
      secondButton = angular.element(lastFaberComponents).find('button')
      secondButton.triggerHandler('click')
      @scope.$digest()

      firstScope = angular.element(@element.find('faber-block').find('faber-group-item-block')[0]).scope()
      secondScope = angular.element(@element.find('faber-block').find('faber-group-item-block')[1]).scope()

      expect(@scope.block.blocks.length).toBe 2
      expect(firstScope.isSelected).toBe false
      expect(secondScope.isSelected).toBe true