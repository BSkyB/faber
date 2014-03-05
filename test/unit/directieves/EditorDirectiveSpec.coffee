describe 'Faber Editor Directive:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope)->
      $rootScope.greeting = 'hello'
      @element = $compile('<faber-editor></faber-editor>')($rootScope)
      $rootScope.$digest()

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@element).toBeDefined()

    it 'should show correct greeting', ->
      expect(@element.text()).toMatch 'hello'