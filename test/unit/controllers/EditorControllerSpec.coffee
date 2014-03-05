describe 'EditorController', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller)->
      @editorController = $controller('EditorController', $scope: $rootScope.$new())
      @contentService = $injector.get 'contentService'

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@editorController).toBeDefined()

