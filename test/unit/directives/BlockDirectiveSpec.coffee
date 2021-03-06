describe 'BlockDirective:', ()->
  blockTemplate = '<faber-block data-faber-block-content="passedDownBlock"></faber-block>'

  config = null
  injector = null
  rootScope = null
  compile = null
  componentsService = null

  createDirective = (template)->
    rootScope.block =
      component: 'group-component'
      blocks: [
        component: 'a-component'
      ,
        component: 'child-component'
      ]
    scope = rootScope.$new()
    scope.passedDownBlock = rootScope.block.blocks[0]
    element = compile(template or blockTemplate)(scope)
    element.data('$injector', injector) # OMG.
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
      injector = $injector
      componentsService = $injector.get 'componentsService'
      componentsService.init [
        ()->
          id: 'a-component'
          type: 'element'
      ,
        ()->
          id: 'group-component'
          type: 'group'
      ,
        ()->
          id: 'child-component'
          type: 'element'
      ,
        GroupItemComponent
      ]

      @element = createDirective()
      @scope = @element.isolateScope()
      @scope.isExpanded = true

  describe 'when initialised,', ->
    it 'should be defined', ->
      element = createDirective()
      expect(element).toBeDefined()

    describe 'if the component type is element,', ->
      beforeEach ->
        @scope.block.component = 'a-component'
        @scope.$digest()

      it 'cannot have any children to the block', ->
        expect(@scope.component.type).toBe 'element'
        expect(@element.find('faber-components').length).toBe 0

      it 'should have \'faber-element-block\' class', ->
        expect(angular.element(@element.children()[0]).hasClass('faber-element-block')).toBe true

    describe 'if the component type is group,', ->
      beforeEach ->
        @scope.block.component = 'group-component'
        @scope.$digest()

      it 'should not have \'faber-element-block\' class', ->
        expect(@scope.isElementBlock).toBeFalsy()
        expect(@scope.isGroupBlock).toBeTruthy()
        expect(@scope.isGroupItemBlock).toBeFalsy()
        expect(angular.element(@element.children()[0]).hasClass('faber-element-block')).toBe false

      it 'should be able to switch to preview mode from edit mode', ->
        @scope.isPreview = false
        @scope.$digest()

        # make it to edit mode first
        expect(@scope.isPreview).toBeFalsy()

        previewButton = @element[0].querySelector('button.faber-preview-group-button')

        # preview button should be there
        expect(previewButton).not.toBe null

        # edit button should not be there
        expect(@element[0].querySelector('button.faber-edit-group-button')).toBe null

        $previewButton = angular.element previewButton
        $previewButton.triggerHandler 'click'
        @scope.$digest()

        expect(@scope.isPreview).toBeTruthy()

      it 'should be able to switch to edit mode from preview mode', ->
        @scope.isPreview = true
        @scope.$digest()

        # make it to preview mode first
        expect(@scope.isPreview).toBeTruthy()

        editButton = @element[0].querySelector('button.faber-edit-group-button')

        # edit button should be there
        expect(editButton).not.toBe null

        # preview button should not be there
        expect(@element[0].querySelector('button.faber-preview-group-button')).toBe null

        $editButton = angular.element editButton
        $editButton.triggerHandler 'click'
        @scope.$digest()

        expect(@scope.isPreview).toBeFalsy()

      describe 'when in edit mode,', ->
        beforeEach ->
          @scope.block.blocks = [
            # group item 1
            component: 'group-item'
            title: "Item 1"
            blocks: [
              component: 'child-component'
            ,
              component: 'child-component'
            ]
          ,
            # group item 2
            component: 'group-item'
            title: "Item 2"
            blocks: [
              component: 'child-component'
            ]
          ]
          @scope.$digest()

          @groupItemBlock1 = @element.find('faber-block')[0]
          @groupItemBlock1Scope = angular.element(@groupItemBlock1).isolateScope()

          @groupItem1Renderer = angular.element(@groupItemBlock1).find('faber-component-renderer')[0]
          @groupItem1RendererScope = angular.element(@groupItem1Renderer).isolateScope()

        describe 'if there are group item blocks', ->
          it 'should have the correct number of group items', ->
            expect(@scope.block.blocks.length).toBe 2
            expect(@element[0].querySelectorAll('div.group-item').length).toBe 2

          it 'should be able to expand a collapsed group item block', ->
            @groupItemBlock1Scope.isExpanded = false
            @groupItemBlock1Scope.$digest()

            # check it's not expanded first
            expect(@groupItemBlock1Scope.isExpanded).toBe false
            expect(@groupItem1RendererScope.isExpanded).toBe false

            expandButton = @groupItemBlock1.querySelector('button.faber-icon-plus')

            # expand button should be there
            expect(expandButton).not.toBe null

            # collapse button should not be there
            expect(@groupItemBlock1.querySelector('button.faber-icon-minus')).toBe null

            $expandButton = angular.element expandButton
            $expandButton.triggerHandler 'click'
            @groupItemBlock1Scope.$digest()

            expect(@groupItem1RendererScope.isExpanded).toBe true

          it 'should be able to collapse an expanded group item block', ->
            @groupItemBlock1Scope.isExpanded = true
            @groupItemBlock1Scope.$digest()

            expect(@groupItemBlock1Scope.isExpanded).toBe true
            expect(@groupItem1RendererScope.isExpanded).toBe true

            collapseButton = @groupItemBlock1.querySelector('button.faber-icon-minus')

            expect(collapseButton).not.toBe null
            expect(@groupItemBlock1.querySelector('button.faber-icon-plus')).toBe null

            $collapseButton = angular.element collapseButton
            $collapseButton.triggerHandler 'click'
            @groupItemBlock1Scope.$digest()

            expect(@groupItem1RendererScope.isExpanded).toBe false

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

  describe 'when preview all event is fired,', ->
    describe 'if it is a group block,', ->
      it 'should be switched to preview mode', ->
        @scope.isGroupBlock = true
        rootScope.$broadcast 'PreviewAll'

        expect(@scope.isPreview).toBe true

    describe 'if it is not a group block', ->
      it 'should not be switched to preview mode', ->
        rootScope.$broadcast 'PreviewAll'

        expect(@scope.isPreview).toBe false

  describe 'when collapse all event is fired,', ->
    beforeEach ->
      rootScope.$broadcast 'CollapseAll'

    it 'should be collapsed', ->
      expect(@scope.isExpanded).toBe false

  describe 'when expand all event is fired,', ->
    beforeEach ->
      @scope.isExpanded = false
      rootScope.$broadcast 'ExpandAll'

    it 'should be expanded', ->
      expect(@scope.isExpanded).toBe true

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
