describe 'Block Directive:', ()->
  blockTemplate = '<faber-block data-faber-block-content="passedDownBlock" data-faber-block-inherited-blacklist="blacklist"></faber-block>'

  config = null
  rootScope = null
  compile = null
  componentsService = null

  beforeEach module 'faber'
  beforeEach ->
    inject ($rootScope, $compile, $injector, $templateCache, faberConfig)->
      $templateCache.put 'a-component', '<p>A component</p>'
      $templateCache.put 'group-component', '<p>Group component</p>'
      $templateCache.put 'child-component', '<p>Child component</p>'
      $templateCache.put 'top-level-only-component', '<p>Top level only component</p>'

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

  describe 'when initialised,', ->
    beforeEach ->
      componentsService.init [
        ()->
          id: 'a-component'
          type: 'element'
      ,
        ()->
          id: 'group-component'
          type: 'group'
      ]

      @element = createDirective()
      @scope = @element.isolateScope()
      @scope.expanded = true

    it 'should be defined', ->
      element = createDirective()
      expect(element).toBeDefined()

    describe 'if the component type is element,', ->
      beforeEach ->
        @scope.component = componentsService.findById('a-component')
        @scope.$digest()

      it 'cannot add any children to the block', ->
        expect(@scope.component.type).toBe 'element'
        expect(@element.find('faber-components').length).toBe 0

  xdescribe 'when select the block', ->
    beforeEach ->
      inject ($injector)->
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

        element = createDirective()
        scope = element.isolateScope()
        scope.expanded = true


        block1 = component: 'component1'
        block2 = component: 'component2'
        block3 = component: 'component3'

        scope.isTopLevel = true
        scope.block.blocks = [block1, block2, block3]
        scope.$digest()

        console.log element

        block1Element = angular.element element.find('faber-block')[0]
        block1Scope = block1Element.isolateScope()
        block2Element = angular.element element.find('faber-block')[1]
        @block2Scope = block2Element.isolateScope()
        block3Element = angular.element element.find('faber-block')[2]
        block3Scope = block3Element.isolateScope()

        console.log scope.block.blocks

    it 'should be able to unselect all other blocks', ->
      @block2Scope.select()