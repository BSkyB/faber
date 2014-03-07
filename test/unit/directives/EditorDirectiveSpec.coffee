describe 'Editor Directive:', ()->
  beforeEach module 'faber'
  beforeEach module 'templates'

  describe 'when initialised', ->
    beforeEach ->
      inject ($compile, $rootScope)->
        scope = $rootScope.$new()
        @element = $compile('<faber-editor></faber-editor>')(scope)
        scope.$digest()
        @scope = @element.scope()

    it 'should be defined', ->
      expect(@element).toBeDefined()

  describe 'if the content is imported', ->
    beforeEach ->
      inject ($compile, $rootScope, $injector)->
        scope = $rootScope.$new()
        @element = $compile('<faber-editor></faber-editor>')(scope)
        scope.$digest()
        @scope = @element.scope()

        @contentService = $injector.get 'contentService'

    it 'should add the blocks to the block list', ->
      @contentService.import sampleJson
      @scope.$digest()

      expect(@scope.blocks.length).toBe 4
#      expect(@element.find('faber-block').length).toBe 4

