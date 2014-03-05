describe 'BlockController', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller)->
      @scope = $rootScope.$new()
      @blockController = $controller('BlockController', $scope: @scope)

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@blockController).toBeDefined()

  describe 'when adding a block', ->
    it 'should be able to validate the new block before it is added', ->
      invalid = {}
      valid =
        inputs:
          title: 'new title'
          body: 'new body'
        component: 'test-component'
        type: 'element'

      invalidResult = @scope.add invalid
      expect(invalidResult).toBeFalsy()
      expect(@scope.blocks.length).toBe 0

      validResult = @scope.add valid
      expect(validResult).toBeTruthy()
      expect(@scope.blocks.length).toBe 1

  