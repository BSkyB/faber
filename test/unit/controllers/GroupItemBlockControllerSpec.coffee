describe 'GroupItemBlockController:', ->
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
      controller = $controller('GroupItemBlockController', $scope: scope)

  describe 'when initialised,', ->
    it 'should have only element components available to be added', ->
      expect(scope.components.length).toBe 2
      expect(scope.components[0].id).toBe 'element-component-1'
      expect(scope.components[1].id).toBe 'element-component-2'
