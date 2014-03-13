describe 'BlockController:', ->
  log = null

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller, $log)->
      log = $log
      log.reset()

      @scope = $rootScope.$new()
      @blockController = $controller('BlockController', $scope: @scope)
      @componentsService = $injector.get 'componentsService'

  afterEach ->
    log.reset()

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(@blockController).toBeDefined()

  describe 'when removing a child block,', ->
    beforeEach ->
      @blockToRemove =
        inputs:
          title: 'new title'
          body: 'new body'
        component: 'test-component'
      @scope.block.blocks = [{}, {}, @blockToRemove, {}]

    describe 'if the given block is in the block list,', ->
      it 'should be able to remove it from the list', ->
        @scope.remove @blockToRemove

        expect(@scope.block.blocks.length).toBe 3
        expect(@scope.block.blocks.indexOf @blockToRemove).toBeLessThan 0

    describe 'if the given block is not in the block list,', ->
      it 'doesn\'t do anything', ->
        @scope.remove = 'test block'

        expect(@scope.block.blocks.length).toBe 4

  describe 'when collapse all event is fired,', ->
    beforeEach ->
      inject ($rootScope)->
        $rootScope.$broadcast 'CollapseAll'

    it 'should be collapsed', ->
      expect(@scope.expanded).toBe false

  describe 'when expand all event is fired,', ->
    beforeEach ->
      @scope.expanded = false

      inject ($rootScope)->
        $rootScope.$broadcast 'ExpandAll'

    it 'should be expanded', ->
      expect(@scope.expanded).toBe true

  describe 'when a component is set for the block,', ->
    beforeEach ->
      inject ($injector)->
        @componentsService = $injector.get 'componentsService'
        @componentsService.init [
          inputs:
            title: 'block title'
          template: 'aaaaa-component'
          type: 'element'
        ]

    describe 'if the component is available in ComponentsService,', ->
      it 'should apply the component to the block', ->
        @scope.block.component = 'aaaaa-component'
        @scope.$digest()

        expect(@scope.component.inputs.title).toBe 'block title'

    describe 'if the component is not available,', ->
      it 'should warn', ->
        logs = log.warn.logs

        @scope.block.component = 'invalid'
        @scope.$digest()

        expect(logs.length).toBe 1
        expect(logs).toContain ['cannot find a component of the given template': 'invalid']

