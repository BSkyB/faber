describe 'Block Directive:', ()->
  blockTemplate = '<faber-block data-faber-block-content="passedDownBlock"></faber-block>'

  config = null
  rootScope = null
  compile = null
  componentsService = null

  createDirective = (template)->
    scope = rootScope.$new()
    scope.passedDownBlock = { component: 'a component' }
    element = compile(template or blockTemplate)(scope)
    scope.$digest()

    return element

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

  describe 'when initialised,', ->
    it 'should be defined', ->
      element = createDirective()
      expect(element).toBeDefined()

    describe 'if the component type is element,', ->
      beforeEach ->
        @scope.component = componentsService.findById('a-component')
        @scope.$digest()

      it 'cannot have any children to the block', ->
        expect(@scope.component.type).toBe 'element'
        expect(@element.find('faber-components').length).toBe 0

      it 'should have \'faber-element-block\' class', ->
        expect(angular.element(@element.children()[0]).hasClass('faber-element-block')).toBe true

    describe 'if the component type is group,', ->
      beforeEach ->
        @scope.component = componentsService.findById('group-component')
        @scope.$digest()

      it 'should not have \'faber-element-block\' class', ->
        expect(angular.element(@element.children()[0]).hasClass('faber-element-block')).toBe false

      it 'should be able to collapse an expanded group item block', ->
         # TODO
        expect(@scope.expanded).toBe true

      it 'should be able to expand a collapsed group item block', ->
        # TODO

  describe 'when a block is selected,', ->
    it 'if the block is the selected block it should set highlight the block', ->
      @scope.onBlockClick()
      @scope.$digest()

      expect(@scope.isSelected).toBe true

    it 'if the block is not the selected block, it should unselect', ->
      # select the block first
      @scope.isSelected = true

      anotherBlockElement = createDirective()
      anotherBlockScope = anotherBlockElement.isolateScope()
      anotherBlockScope.onBlockClick()

      @scope.$digest()

      expect(@scope.isSelected).toBe false

  describe 'when collapse all event is fired,', ->
    beforeEach ->
      rootScope.$broadcast 'CollapseAll'

    it 'should be collapsed', ->
      expect(@scope.expanded).toBe false

  describe 'when expand all event is fired,', ->
    beforeEach ->
      @scope.expanded = false
      rootScope.$broadcast 'ExpandAll'

    it 'should be expanded', ->
      expect(@scope.expanded).toBe true

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

        @scope.isTopLevel = true
        @scope.block.blocks = [block1, block2, block3]

    it 'should be able assign all the children correctly', ->
      @scope.move 2, 0

      expect(@scope.block.blocks[0]).toBe block3
      expect(@scope.block.blocks[1]).toBe block1
      expect(@scope.block.blocks[2]).toBe block2