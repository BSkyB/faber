describe 'GroupBlockController:', ->
  scope = null

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector, $rootScope, $controller, $log)->
      scope = $rootScope.$new()
      controller = $controller('GroupBlockController', $scope: scope)
      componentsService = $injector.get 'componentsService'

  describe 'when initialised,', ->
    it 'should have all group components available', ->

    describe 'if not given any initial content', ->
      it 'should not have any child blocks', ->

    describe 'if given initial content', ->
      it 'should have correct group component set', ->

      it 'should have correct child blocks set', ->