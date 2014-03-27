describe 'GroupItemBlockDirective:', ->
  blockTemplate = '<faber-group-item-block></faber-group-item-block>'

  rootScope = null
  compile = null
  componentsService = null

  createDirective = (template)->
    scope = rootScope.$new()
    element = compile(template or blockTemplate)(scope)
    scope.$digest()

    return element

  beforeEach module 'faber'

  beforeEach ->
    inject ($rootScope, $compile, $injector)->
      compile = $compile
      rootScope = $rootScope
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

    @element = createDirective()
    @scope = @element.scope()

  describe 'when initialised,', ->
    it 'should have only element components to be available', ->
      buttons = @element.find('faber-components').find('button')
      expect(buttons.length).toBe 2
      expect(angular.element(buttons[0]).text()).toBe 'Element Component 1'
      expect(angular.element(buttons[1]).text()).toBe 'Element Component 2'

  describe 'when the item block has children', ->
    it 'should be able to show correct number of the child blocks', ->
      @scope.block.blocks = [
        component: 'element-component-1'
      ,
        component: 'element-component-2'
      ,
        component: 'element-component-1'
      ,
        component: 'element-component-2'
      ]
      @scope.$digest()

      expect(@element.find('faber-block').length).toBe 4
      expect(@element.find('faber-element-block').length).toBe 4