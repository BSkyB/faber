describe 'GroupBlockDirective:', ()->
  blockTemplate = '<faber-group-block data-faber-block-content="passedDownBlock" data-faber-block-inherited-blacklist="blacklist"></faber-group-block>'

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

    it 'should be defined', ->
      element = createDirective()
      expect(element).toBeDefined()