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
        template: 'a-component'
        type: 'element'
      ,
        template: 'group-component'
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
        @scope.component = componentsService.findByTemplate('a-component')
        @scope.$digest()

      it 'cannot add any children to the block', ->
        expect(@scope.component.type).toBe 'element'
        expect(@element.find('faber-components').length).toBe 0