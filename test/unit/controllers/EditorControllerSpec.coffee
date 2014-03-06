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
      expect(@scope.blocks).toBe @contentService.getAll()

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


  describe 'when content is imported', ->
    it 'should get all imported blocks from content service', ->
      @contentService.import sampleJson

      expect(@scope.blocks.length).toBe angular.fromJson(sampleJson).length

