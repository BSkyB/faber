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

  describe 'when removing a block', ->
    beforeEach ->
      @blockToRemove =
        inputs:
          title: 'new title'
          body: 'new body'
        component: 'test-component'
        type: 'element'
      @scope.blocks = [{}, {}, @blockToRemove, {}]

    describe 'if the given block is in the block list', ->
      it 'should be able to remobe it from the list', ->
        @scope.remove @blockToRemove

        expect(@scope.blocks.length).toBe 3
        expect(@scope.blocks.indexOf @blockToRemove).toBeLessThan 0

    describe 'if the given block is not in the block list', ->
      it 'doesn\'t do anything', ->
        @scope.remove = 'test block'

        expect(@scope.blocks.length).toBe 4

  describe 'when collapse all event is fired', ->
    beforeEach ->
      inject ($rootScope)->
        $rootScope.$broadcast 'CollapseAll'

    it 'should be collapsed', ->
      expect(@scope.expandWatch.expanded).toBe false

  describe 'when expand all event is fired', ->
    beforeEach ->
      @scope.expandWatch.expanded = false

      inject ($rootScope)->
        $rootScope.$broadcast 'ExpandAll'

    it 'should be expanded', ->
      expect(@scope.expandWatch.expanded).toBe true
