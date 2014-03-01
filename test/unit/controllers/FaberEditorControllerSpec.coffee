describe 'FaberEditorController', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($rootScope, $controller)->
      @editorController = $controller('FaberEditorController', $scope: $rootScope.$new())

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@editorController).toBeDefined()