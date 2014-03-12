describe 'Components Directive:', ->
  beforeEach module 'faber'
  beforeEach module 'templates'

  beforeEach ->
    inject ($compile, $rootScope, $injector)->
      @componentsService = $injector.get 'componentsService'

      scope = $rootScope.$new()
      components = [
        inputs:
          title: 'component title'
        template: 'a-component'
        type: 'element'
      ,
        template: 'top-level-only-component'
        type: 'element'
        topLevelOnly: true
      ]
      scope.components = ()->
        components

      @element = $compile('<faber-components></faber-editor>')(scope)
      scope.$digest()
      @scope = @element.scope()

  it 'should be able to show all of the given components', ->
    expect(@element.find('li').length).toBe 2