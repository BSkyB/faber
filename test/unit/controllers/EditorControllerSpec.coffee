describe 'EditorController', ->
  beforeEach module 'faber'

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

    it 'should bind blocks to ContentService', ->


  describe 'when content is imported', ->
    it 'should get all imported blocks from content service', ->
      @contentService.import sampleJson

      expect(@scope.blocks.length).toBe angular.fromJson(sampleJson).length

