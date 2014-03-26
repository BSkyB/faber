describe 'Components Directive:', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope, $injector, faberConfig)->
      @componentsService = $injector.get 'componentsService'

      scope = $rootScope.$new()
      faberConfig.components = [
        ()->
          inputs:
            title: 'component title'
          id: 'a-component'
          type: 'element'
      ,
        ()->
          id: 'top-level-only-component'
          type: 'element'
          topLevelOnly: true
      ,
        ()->
          id: 'group-component-1'
          type: 'group'
      ,
        ()->
          id: 'group-component-2'
          type: 'group'
      ,
        ()->
          id: 'group-component-3'
          type: 'group'
      ]

      editorElement = $compile('<faber-editor><faber-components></faber-components></faber-editor>')(scope)
      scope.components = ()->
        components
      scope.$digest()

      @element = $compile(angular.element(editorElement.find('faber-components')))(scope)
      @scope = @element.scope()
      @scope.showingComponents = true
      @scope.$digest()

  it 'should be able to show all of the given element components', ->
    expect(@element.find('li').length).toBe 3

  it 'should add \'Group\' button if there are any group components', ->
    expect(angular.element(@element.find('li')[2]).text()).toBe 'Group'

  it 'should be able to toggle the appearance', ->
    @scope.showingComponents = false
    @scope.toggleComponents()
    @scope.$digest()

    expect(@element.find('li').length).toBe 3

    @scope.toggleComponents()
    @scope.$digest()

    expect(@element.find('li').length).toBe 0


