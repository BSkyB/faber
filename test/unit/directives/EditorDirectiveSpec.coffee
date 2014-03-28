describe 'EditorDirective:', ()->
  config = null
  componentsService = null
  contentService = null
  element = null
  scope = null

  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope, $injector, $templateCache, faberConfig)->
      $templateCache.put 'a-component', '<p>A component</p>'
      $templateCache.put 'top-level-only-component', '<p>Top level component</p>'

      config = faberConfig
      config.components = [
        ()->
          inputs:
            title: 'component title'
          id: 'a-component'
          type: 'element'
      ,
        ()->
          inputs:
            title: 'component title'
          id: 'b-component'
          type: 'element'
      ,
        ()->
          id: 'top-level-only-component'
          type: 'element'
          topLevelOnly: true
      ,
        ()->
          name: 'Group Component 1'
          id: 'group-component-1'
          type: 'group'
          template: '<ul></ul>'
      ,
        ()->
          name: 'Group Component 2'
          id: 'group-component-2'
          type: 'group'
          template: '<ol></ol>'
      ,
        ()->
          name: 'Group Component 3'
          id: 'group-component-3'
          type: 'group'
          template: '<dl></dl>'
      ]

      componentsService = $injector.get 'componentsService'
      contentService = $injector.get 'contentService'

      scope = $rootScope.$new()
      element = $compile('<faber-editor></faber-editor>')(scope)
      scope.$digest()

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(element).toBeDefined()

    it 'should have a set of components so you can add the first block', ->
      expect(element.find('faber-components').length).toBe 1

    describe 'when setting expanded flag,', ->
      beforeEach ->
        inject ($injector, $rootScope, $controller)->
          config.expanded = false

          scope = $rootScope
          spyOn scope, '$broadcast'

          $controller('EditorController', $scope: scope)
          scope.$digest()

      it 'set default expanded flag', ->
        expect(scope.expanded).toBe false

      it 'should broadcast expand all event', ->
        expect(scope.$broadcast).toHaveBeenCalledWith 'CollapseAll'

  describe 'when a block is added,', ->
    result = null

    beforeEach ->
      topLevelOnly =
        inputs:
          title: 'top level only component set'
        component: 'top-level-only-component'

      result = scope.add topLevelOnly
      scope.$digest()

    it 'can have top level only components', ->
      expect(result).toBeTruthy()
      expect(scope.block.blocks.length).toBe 1

    it 'should have another set of component list so another block can be added using it', ->
      expect(element.find('faber-components').length).toBe 2

    it 'should be able to export a correct block list', ->
      scope.add component: 'a-component'
      scope.add component: 'b-component'

      exported = contentService.export()
      obj = angular.fromJson exported

      expect(obj.length).toBe 3
      expect(obj[0].component).toBe 'top-level-only-component'
      expect(obj[1].component).toBe 'a-component'
      expect(obj[2].component).toBe 'b-component'

  describe 'when it has child blocks,', ->
    beforeEach ->
      @groupBlock1 = component: 'group-component-1'
      @groupBlock2 = component: 'group-component-2'
      @groupBlock3 = component: 'group-component-3'
      @elementBlock1 = component: 'a-component'
      @elementBlock2 = component: 'b-component'

      scope.block.blocks = [@elementBlock1, @groupBlock1, @groupBlock2, @groupBlock3, @elementBlock2]

      scope.$digest()

      @block1Element = angular.element element.find('faber-block')[0]
      @block1Scope = @block1Element.isolateScope()
      @block2Element = angular.element element.find('faber-block')[1]
      @block2Scope = @block2Element.isolateScope()
      @block3Element = angular.element element.find('faber-block')[2]
      @block3Scope = @block3Element.isolateScope()
      @block4Element = angular.element element.find('faber-block')[3]
      @block4Scope = @block4Element.isolateScope()
      @block5Element = angular.element element.find('faber-block')[4]
      @block5Scope = @block5Element.isolateScope()

    it 'should have correct number of children and their components', ->
      expect(scope.block.blocks.length).toBe 5
      expect(element.find('faber-block').length).toBe 5
      expect(element.find('faber-group-block').length).toBe 3
      expect(element.find('faber-element-block').length).toBe 2

    it 'the children should update its current index when a sibling move to different position', ->
      @block3Element.find('select').val('0')
      @block3Scope.onSelectChange()
      scope.$digest()

      expect(@block1Element.find('select').val()).toBe '1'
      expect(@block2Element.find('select').val()).toBe '2'
      expect(@block3Element.find('select').val()).toBe '0'
      expect(@block4Element.find('select').val()).toBe '3'
      expect(@block5Element.find('select').val()).toBe '4'

    describe 'when a group block is inserted', ->
      it 'should use \'faber-group-block\' to render the group', ->
        scope.insertGroup(2)
        scope.$digest()

        expect(scope.block.blocks.length).toBe 6
        expect(scope.block.blocks.length).toBe 6
        expect(element.find('faber-group-block').length).toBe 4
        expect(element.find('faber-element-block').length).toBe 2

  describe 'when content is imported,', ->
    beforeEach ->
      contentService.import '[
        {"component":"group-component-1","blocks":[]},
        {"component":"a-component"},
        {"component":"group-component-2","blocks":[]}
      ]'
      scope.$digest()

    it 'should not highlight/select any blocks', ->
      faberBlocks = element.find('faber-block')

      inject ($timeout)->
        $timeout ()->
          expect(scope.block.blocks.length).toBe 3
          expect(faberBlocks.length).toBe 3
          expect(angular.element(faberBlocks[0]).isolateScope().isSelected).toBeFalsy()
          expect(angular.element(faberBlocks[1]).isolateScope().isSelected).toBeFalsy()
          expect(angular.element(faberBlocks[2]).isolateScope().isSelected).toBeFalsy()