describe 'Editor Directive:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope)->
      @scope = $rootScope.$new()
      @directive = $compile('<faber-editor></faber-editor>')(@scope)
      @scope.$digest()

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@directive).toBeDefined()

#  describe 'if a block is added', ->
#    it 'should add the block to the block list', ->
#      expect(@scope.add).toBeDefined()
#      @scope.add {}
#
#      expect(@scope.blocks.length).toBe 1
