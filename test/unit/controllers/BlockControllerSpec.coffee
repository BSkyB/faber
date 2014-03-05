describe 'BlockController', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller)->
      @scope = $rootScope.$new()
      @blockController = $controller('BlockController', $scope: @scope)

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@blockController).toBeDefined()

  describe 'when a block is added', ->
    it 'should be able to validate the new block', ->
      expect(false).toBe true

    it 'should be able to add a new block to the block list', ->
      @scope.add {}
      expect(@scope.blocks.length).toBe 1

  it 'should be able to remove a block from the block list', ->
    expect(false).toBe true