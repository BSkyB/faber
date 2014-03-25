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
#      @scope = @element.scope()

  describe 'when initialised,', ->
    it 'should be defined', ->
      expect(element).toBeDefined()

    it 'should have a set of components so you can add the first block', ->
      expect(element.find('faber-components').length).toBe 1

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
    block1 = block2 = block3 =
    block1Scope = block2Scope = block3Scope =
    block1Element = block2Element = block3Element = null

    beforeEach ->
      block1 = component: 'a-component'
      block2 = component: 'a-component'
      block3 = component: 'a-component'

      scope.block.blocks = [block1, block2, block3]

      scope.$digest()

      block1Element = angular.element element.find('faber-block')[0]
      block1Scope = block1Element.isolateScope()
      block2Element = angular.element element.find('faber-block')[1]
      block2Scope = block2Element.isolateScope()
      block3Element = angular.element element.find('faber-block')[2]
      block3Scope = block3Element.isolateScope()

    it 'the children should know how many siblings it has', ->
      expect(block1Element.find('option').length).toBe 3
      expect(block2Element.find('option').length).toBe 3
      expect(block3Element.find('option').length).toBe 3

      expect(block1Element.find('select').val()).toBe '0'
      expect(block2Element.find('select').val()).toBe '1'
      expect(block3Element.find('select').val()).toBe '2'

    it 'the children should update its current index when a sibling move to different position', ->
      block3Element.find('select').val('0')
      block3Scope.onSelectChange()
      scope.$digest()

      expect(block1Element.find('select').val()).toBe '1'
      expect(block2Element.find('select').val()).toBe '2'
      expect(block3Element.find('select').val()).toBe '0'

  describe 'when it has group child blocks,', ->
    groupBlock1 = component: 'group-component-1'
    groupBlock2 = component: 'group-component-2'
    groupBlock3 = component: 'group-component-3'
    elementBlock1 = component: 'a-component'
    elementBlock2 = component: 'b-component'

    beforeEach ->
      scope.block.blocks = [elementBlock1, groupBlock1, groupBlock2, groupBlock3, elementBlock2]
      scope.$digest()

    it 'should have correct number of children and their components', ->
      expect(scope.block.blocks.length).toBe 5
      expect(element.find('faber-block').length).toBe 5
      expect(element.find('faber-group-block').length).toBe 3
      expect(element.find('faber-component-renderer').length).toBe 2