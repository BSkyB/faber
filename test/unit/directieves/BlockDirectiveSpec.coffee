describe 'Block Directive:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope)->
      @scope = $rootScope.$new()
      @element = $compile('<faber-block></faber-block>')(@scope)
      @scope.$digest()

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@element).toBeDefined()