describe 'Block Directive:', ()->
  blockTemplate = '<faber-block data-faber-block-content="passedDownBlock" data-faber-block-inherited-blacklist="blacklist"></faber-block>'

  config = null
  rootScope = null
  compile = null
  componentsService = null

  beforeEach module 'faber'
  beforeEach module 'templates'
  beforeEach ->
    inject ($rootScope, $compile, $injector, $templateCache, faberConfig)->
      $templateCache.put 'a-component', '<p>A component</p>'

      config = faberConfig
      config.expanded = false

      compile = $compile
      rootScope = $rootScope
      componentsService = $injector.get 'componentsService'

  createDirective = (template)->
    scope = rootScope.$new()
    scope.passedDownBlock = { component: 'a component' }
    element = compile(template or blockTemplate)(scope)
    scope.$digest()

    return element

  describe 'when initialised', ->
    it 'should be defined', ->
      @element = createDirective()
      expect(@element).toBeDefined()

  describe 'when a block is added', ->
    beforeEach ->
      componentsService.init [
        inputs:
          title: 'component title'
        template: 'a-component'
        type: 'element'
      ,
        template: 'top-level-only-component'
        type: 'element'
        topLevelOnly: true
      ,
        template: 'another-top-level-only-component'
        type: 'group'
        topLevelOnly: true
      ]

      @element = createDirective()
      @scope = @element.isolateScope()

    afterEach ->
      @scope.block.blocks = []

    it 'should have as many block directives as the number of child blocks', ->
      @scope.add { component: 'a-component' }
      @scope.expanded = true
      @scope.$digest()

      expect(@scope.block.blocks.length).toBe 1
      expect(@element.find('faber-block').length).toBe 1

    it 'should set the child block\'s expanded flag to the root scope\'s flag', ->
      @scope.add
        inputs:
          title: 'new title'
          body: 'new body'
        component: 'a-component'
      @scope.expanded = true
      @scope.$digest()

      childElement = angular.element(@element.find('faber-block')[0])
      childScope = childElement.isolateScope()

      expect(childScope.expanded).toBe false

    describe 'if the block has component', ->
      describe 'if the component is available in ComponentsService', ->
        it 'should apply the component to the block', ->
          @scope.add
            inputs:
              title: 'new title'
              body: 'new body'
            component: 'a-component'
          @scope.expanded = true
          @scope.$digest()

          @childElement = angular.element(@element.find('faber-block')[0])
          @childScope = @childElement.isolateScope()

          expect(@childScope.component.inputs.title).toBe 'component title'

    describe 'if the block is not top level', ->
      beforeEach ->
        @result = @scope.add
          inputs:
            title: 'top level'
          component: 'a-component'
        @scope.expanded = true
        @scope.$digest()

        @childElement = angular.element(@element.find('faber-block')[0])
        @childScope = @childElement.isolateScope()

        @childResult = @childScope.add
          inputs:
            title: 'second level'
          component: 'top-level-only-component'
        @childScope.$digest()

      it 'should not set top level only component to the block', ->
        expect(@result).toBeTruthy()
        expect(@scope.block.blocks.length).toBe 1
        expect(@childResult).toBeFalsy()
        expect(@childScope.block.blocks.length).toBe 0

      it 'should not have top level only components in its component list', ->
        expect(@scope.components().length).toBe 1
        expect(@scope.components()[0].template).toBe 'a-component'