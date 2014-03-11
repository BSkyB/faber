describe 'Editor Directive:', ()->
  beforeEach module 'faber'
  beforeEach module 'templates'

  beforeEach ->
    inject ($compile, $rootScope, $injector)->
      scope = $rootScope.$new()
      @element = $compile('<faber-editor></faber-editor>')(scope)
      scope.$digest()
      @scope = @element.scope()

      @componentsService = $injector.get 'componentsService'
      @componentsService.init [
        inputs:
          title: 'component title'
        template: 'a-component'
        type: 'element'
      ,
        template: 'top-level-only-component'
        type: 'element'
        topLevelOnly: true
      ]

  describe 'when initialised', ->
   it 'should be defined', ->
      expect(@element).toBeDefined()

  describe 'when a block is added', ->
    it 'can have top level only component', ->
      topLevelOnly =
        inputs:
          title: 'top level only component set'
        component: 'top-level-only-component'

      result = @scope.add topLevelOnly
      @scope.$digest()

      expect(result).toBeTruthy()
      expect(@scope.block.blocks.length).toBe 1