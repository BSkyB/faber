describe 'EditorController', ->
  beforeEach module 'faber'

  beforeEach ->
    inject (faberConfig)->
      @config = faberConfig
      @config.expanded = false

  beforeEach ->
    inject ($injector, $rootScope, $controller)->
      @scope = $rootScope.$new()
      @editorController = $controller('EditorController', $scope: @scope)
      @contentService = $injector.get 'contentService'

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@editorController).toBeDefined()

    it 'should get all initial blocks from content service', ->
      expect(@scope.block.blocks).toBe @contentService.getAll()

    describe 'when setting expanded flag', ->
      beforeEach ->
        inject (faberConfig)->
          @config = faberConfig
          @config.expanded = false

      beforeEach ->
        inject ($injector, $rootScope, $controller)->
          @scope = $rootScope.$new()
          spyOn @scope, '$broadcast'

          @controller = $controller('EditorController', $scope: @scope)

      afterEach ->
        @config = {}

      it 'set default expanded flag', ->
        expect(@scope.expanded).toBe false

      it 'should broadcast expand all event', ->
        expect(@scope.$broadcast).toHaveBeenCalledWith 'CollapseAll'

    describe 'if given an element component', ->
      beforeEach ->
        inject (faberConfig)->
          @config = faberConfig
          @elementComp = new FaberComponent({ name: 'Base component', type: 'element', template: 'template.html'})
          @config.components = [ @elementComp ]

      beforeEach ->
        inject ($injector, $rootScope, $controller)->
          @scope = $rootScope.$new()
          @controller = $controller('EditorController', $scope: @scope)
          @componentsService = $injector.get 'componentsService'

      afterEach ->
        @config = {}

      it 'should add it to the ComponentsService', ->
        allComponents = @componentsService.getAll()

        expect(allComponents.length).toBe 1
        expect(allComponents[0]).toBe @elementComp

    describe 'if given an group component', ->
      beforeEach ->
        inject (faberConfig)->
          @config = faberConfig
          @groupComp = new FaberComponent({ name: 'Base component', type: 'group', template: 'template.html'})
          @config.components = [ @groupComp ]

      beforeEach ->
        inject ($injector, $rootScope, $controller)->
          @scope = $rootScope.$new()
          @controller = $controller('EditorController', $scope: @scope)
          @componentsService = $injector.get 'componentsService'

      afterEach ->
        @config = {}

      it 'should add it to the ComponentsService', ->
        allComponents = @componentsService.getAll()

        expect(allComponents.length).toBe 1
        expect(allComponents[0]).toBe @groupComp

  xdescribe 'when a block is added', ->
    it 'should be able to set top level only component to the block', ->
      inject ($injector)->
        componentsService = $injector.get 'componentsService'

        componentsService.init [
          template: 'top-level-only-component'
          type: 'element'
          topLevelOnly: true
        ]

        topLevelOnly =
          inputs:
            title: 'top level only component set'
          component: 'top-level-only-component'

        topLevelOnlyResult = @scope.add topLevelOnly
        expect(topLevelOnlyResult).toBeTruthy()
        expect(@scope.block.blocks.length).toBe 1

  describe 'when content is imported', ->
    it 'should get all imported blocks from content service', ->
      @contentService.import sampleJson

      expect(@scope.block.blocks.length).toBe angular.fromJson(sampleJson).length

