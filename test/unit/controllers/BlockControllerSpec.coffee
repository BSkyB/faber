describe 'BlockController', ->
  beforeEach module 'faber'

  beforeEach ->
    inject ($rootScope, $controller)->
      @blockController = $controller('BlockController', $scope: $rootScope.$new())

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@blockController).toBeDefined()