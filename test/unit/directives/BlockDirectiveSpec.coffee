describe 'Block Directive:', ()->
  beforeEach module 'faber'
  beforeEach module 'templates'

  beforeEach ->
    inject ($compile, $rootScope)->
      @scope = $rootScope.$new()
      @element = $compile('<faber-block></faber-block>')(@scope)
      @scope.$digest()

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@element).toBeDefined()
