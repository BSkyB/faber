describe 'Faber Editor', ->

  beforeEach ->
    browser.get '/index.html'

  describe 'when initialised', ->
    it 'should show a list of available components', ->
      expect(false).toBe true