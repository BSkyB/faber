describe 'Faber Editor Directive:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($compile, $rootScope)->
      $rootScope.greeting = 'hello'
      @element = $compile('<div faber-editor></div>')($rootScope)
      $rootScope.$digest()

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@element).toBeDefined()

    it 'should show correct greeting', ->
      expect(@element.text()).toBe 'hello'