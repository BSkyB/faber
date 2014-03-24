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
      ]

      editorElement = $compile('<faber-editor><faber-components></faber-components></faber-editor>')(scope)
      scope.components = ()->
        components
      scope.$digest()

      @element = $compile(angular.element(editorElement.find('faber-components')))(scope)
      @scope = @element.scope()

  it 'should be able to show all of the given components', ->
    @scope.showingComponents = true
    @scope.$digest()

    expect(@element.find('li').length).toBe 2

  it 'should be able to toggle the appearance', ->
    @scope.showingComponents = false
    @scope.toggleComponents()
    @scope.$digest()

    expect(@element.find('li').length).toBe 2

    @scope.toggleComponents()
    @scope.$digest()

    expect(@element.find('li').length).toBe 0
