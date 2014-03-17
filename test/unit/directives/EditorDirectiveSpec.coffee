describe 'Editor Directive:', ()->
  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope, $injector, $templateCache, faberConfig)->
      $templateCache.put 'a-component', '<p>A component</p>'
      $templateCache.put 'top-level-only-component', '<p>Top level component</p>'

      @config = faberConfig
      @config.components = [
        inputs:
          title: 'component title'
        template: 'a-component'
        type: 'element'
      ,
        template: 'top-level-only-component'
        type: 'element'
        topLevelOnly: true
      ]

      @componentsService = $injector.get 'componentsService'

      scope = $rootScope.$new()
      @element = $compile('<faber-editor></faber-editor>')(scope)
      scope.$digest()
      @scope = @element.scope()

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(@element).toBeDefined()

    it 'should have a set of components so you can add the first block', ->
      expect(@element.find('faber-components').length).toBe 1

  describe 'when a block is added,', ->
    beforeEach ->
      topLevelOnly =
        inputs:
          title: 'top level only component set'
        component: 'top-level-only-component'

      @result = @scope.add topLevelOnly
      @scope.$digest()

    it 'can have top level only components', ->
      expect(@result).toBeTruthy()
      expect(@scope.block.blocks.length).toBe 1

    it 'should have another set of component list so another block can be added using it', ->
      expect(@element.find('faber-components').length).toBe 2
