describe 'BlockController:', ->
  log = null
  rootScope = null
  scope = null
  blockController = null
  componentsService = null

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller, $log)->
      log = $log
      log.reset()

      rootScope = $rootScope

      scope = $rootScope.$new()
      blockController = $controller('BlockController', $scope: scope)
      componentsService = $injector.get 'componentsService'

  afterEach ->
    log.reset()

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(blockController).toBeDefined()

  describe 'when removing a child block,', ->
    blockToRemove = null

    beforeEach ->
      blockToRemove =
        inputs:
          title: 'new title'
          body: 'new body'
        component: 'test-component'
      scope.block.blocks = [{}, {}, blockToRemove, {}]


    describe 'if the given block is in the block list,', ->
      describe 'if confirmed', ->
        it 'should be able to remove it from the list', ->
          spyOn(window, 'confirm').andReturn true
          scope.remove blockToRemove

          expect(scope.block.blocks.length).toBe 3
          expect(scope.block.blocks.indexOf blockToRemove).toBeLessThan 0

      describe 'if not confirmed', ->
        it 'should not remove it from the list', ->
          spyOn(window, 'confirm').andReturn false
          scope.remove blockToRemove

          expect(scope.block.blocks.length).toBe 4

    describe 'if the given block is not in the block list,', ->
      it 'doesn\'t do anything', ->
        scope.remove = 'test block'

        expect(scope.block.blocks.length).toBe 4

  describe 'when block data changes', ->
    contentService = null
    config = null

    beforeEach ->
      inject ($injector, faberConfig)->
        componentsService = $injector.get 'componentsService'
        componentsService.init [
          ()->
            id: 'text'
            type: 'element'
        ]

        contentService = $injector.get 'contentService'
        config = faberConfig

    it 'should broadcast BlockUpdated event when content changes', ->
      spyOn rootScope, '$broadcast'

      scope.block.content = 'hello'
      scope.$digest()

      expect(rootScope.$broadcast).toHaveBeenCalledWith 'BlockUpdated'

    it 'should broadcast BlockUpdated event when a child block is added', ->
      spyOn rootScope, '$broadcast'

      scope.add
        content: 'hello'
        component: 'text'
      scope.$digest()

      expect(rootScope.$broadcast).toHaveBeenCalledWith 'BlockUpdated'

  describe 'when a component is set for the block,', ->
    beforeEach ->
      inject ($injector)->
        componentsService = $injector.get 'componentsService'
        componentsService.init [
          ()->
            id: 'aaaaa-component'
            type: 'element'
        ]

    describe 'if the component is available in ComponentsService,', ->
      it 'should apply the component to the block', ->
        scope.block.component = 'aaaaa-component'
        scope.$digest()

        expect(scope.component.id).toBe 'aaaaa-component'

    describe 'if the component is not available,', ->
      it 'should warn', ->
        logs = log.warn.logs

        scope.block.component = 'invalid'
        scope.$digest()

        expect(logs.length).toBe 1
        expect(logs).toContain ['cannot find a component of the given name': 'invalid']

    it 'should be able to insert a block to the given index', ->
      inject ($injector)->
        componentsService = $injector.get 'componentsService'
        componentsService.init [
          ()->
            id: 'insert-this-component'
            type: 'element'
        ]

        block =
          component: 'insert-this-component'
        scope.isTopLevel = true
        scope.block.blocks = [{}, {}, {}]
        scope.insert(2, block)

        expect(scope.block.blocks.length).toBe 4
        expect(scope.block.blocks[2].component).toBe 'insert-this-component'

  describe 'when re-order a block,', ->
    block1 = block2 = block3 = null

    beforeEach ->
      inject ($injector)->
        componentsService = $injector.get 'componentsService'
        componentsService.init [
          ()->
            template: 'component1'
            type: 'element'
        ,
          ()->
            template: 'component2'
            type: 'element'
        ,
          ()->
            template: 'component3'
            type: 'element'
        ]

        block1 = component: 'component1'
        block2 = component: 'component2'
        block3 = component: 'component3'

        scope.isTopLevel = true
        scope.block.blocks = [block1, block2, block3]

    it 'should be able to re-order the children using index', ->
      scope.move(2, 1)

      expect(scope.block.blocks[0]).toBe block1
      expect(scope.block.blocks[1]).toBe block3
      expect(scope.block.blocks[2]).toBe block2

