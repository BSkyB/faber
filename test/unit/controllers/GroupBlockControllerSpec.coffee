describe 'GroupBlockController:', ->
  scope = controller = componentsService = null

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller)->
      componentsService = $injector.get 'componentsService'
      componentsService.init [
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
      ,
        ()->
          name: 'Element Component 1'
          id: 'element-component-1'
          type: 'element'
          template: '<div></div>'
      ,
        ()->
          name: 'Element Component 2'
          id: 'element-component-2'
          type: 'element'
          template: '<div></div>'
      ]

      scope = $rootScope.$new()
      controller = $controller('GroupBlockController', $scope: scope)

  describe 'when initialised,', ->
    it 'should have all element components available to be used for children', ->
      expect(scope.components.length).toBe 2
      expect(scope.components[0].id).toBe 'element-component-1'
      expect(scope.components[1].id).toBe 'element-component-2'

    it 'should have all group components available to be interchangeable', ->
      expect(scope.groupComponents.length).toBe 3
      expect(scope.groupComponents[0].id).toBe 'group-component-1'
      expect(scope.groupComponents[1].id).toBe 'group-component-2'
      expect(scope.groupComponents[2].id).toBe 'group-component-3'

    describe 'if not given any group items', ->
      it 'should not have any children', ->
        expect(scope.block.blocks).toEqual []

    describe 'if given group items', ->
      beforeEach ->
        scope.block.blocks = [
          content: 'first item'
          blocks: [
            component: 'element-component-1'
          ,
            component: 'element-component-2'
          ]
        ,
          content: 'second item'
          blocks: [
            component: 'element-component-2'
          ]
        ]
        scope.$digest()

      it 'should have correct child blocks set', ->
        expect(scope.block.blocks.length).toBe 2

      it 'each group items should have correct number of children and component set', ->
        expect(scope.block.blocks[0].blocks.length).toBe 2

        expect(scope.block.blocks[0].blocks[0].component).toBe 'element-component-1'
        expect(scope.block.blocks[0].blocks[1].component).toBe 'element-component-2'

        expect(scope.block.blocks[1].blocks[0].component).toBe 'element-component-2'

