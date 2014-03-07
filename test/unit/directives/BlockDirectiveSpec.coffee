describe 'Block Directive:', ()->
  beforeEach module 'faber'
  beforeEach module 'templates'

  describe 'when initialised', ->
    beforeEach ->
      inject ($compile, $rootScope)->
        scope = $rootScope.$new()
        scope.passedDownBlock = { component: 'a component' }
        @element = $compile('<faber-block data-faber-block-content="passedDownBlock"></faber-block>')(scope)
        scope.$digest()

    it 'should be defined', ->
      expect(@element).toBeDefined()

  describe 'when a block is added', ->
    beforeEach ->
      inject ($compile, $rootScope)->
        scope = $rootScope.$new()
        scope.passedDownBlock = { component: 'a component' }
        @element = $compile('<faber-block data-faber-block-content="passedDownBlock"></faber-block>')(scope)
        scope.$digest()
        @scope = @element.isolateScope()

    it 'should have as many block directives as the number of child blocks', ->
      @scope.add { component: 'a component' }

      @scope.$digest()

      expect(@scope.block.blocks.length).toBe 1
      expect(@element.find('faber-block').length).toBe 1

    describe 'if the block has component', ->
      beforeEach ->
        inject ($injector)->
          @componentsService = $injector.get 'componentsService'
          @componentsService.init [
            inputs:
              title: 'block title'
            template: 'a-component'
            type: 'element'
          ]

      describe 'if the component is available in ComponentsService', ->
        it 'should apply the component to the block', ->
          @scope.add
            inputs:
              title: 'new title'
              body: 'new body'
            component: 'a-component'
          @scope.$digest()

          @childElement = angular.element(@element.find('faber-block')[0])
          @childScope = @childElement.isolateScope()

          expect(@childScope.component.inputs.title).toBe 'block title'

      describe 'if the component is not available', ->
        beforeEach ->
          inject ($log)->
            $log.reset()
            @log = $log

          @scope.add
            inputs:
              title: 'new title'
              body: 'new body'
            component: 'no template'
          @scope.$digest()

          @childElement = angular.element(@element.find('faber-block')[0])
          @childScope = @childElement.isolateScope()

        afterEach ->
          inject ($log)->
            $log.reset()

        it 'should warn', ->
          logs = @log.warn.logs

          expect(logs.length).toBe 1
          expect(logs).toContain ['cannot find a component of the given template': 'no template']

        it 'should set the block\'s component to base component', ->
          baseComponent = new FaberComponent()

          expect(@childScope.component.name).toBe baseComponent.name
          expect(@childScope.component.template).toBe baseComponent.template
          expect(@childScope.component.type).toBe baseComponent.type
          expect(@childScope.component.nestable).toBe baseComponent.nestable