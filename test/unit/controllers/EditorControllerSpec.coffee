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

  describe 'when content is imported', ->
    it 'should get all imported blocks from content service', ->
      @contentService.import sampleJson

      expect(@scope.blocks.length).toBe angular.fromJson(sampleJson).length

