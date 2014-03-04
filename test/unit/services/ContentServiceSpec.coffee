describe 'ContentService:', ()->

  beforeEach module 'faber'

  beforeEach ->
    inject ($injector)->
      @contentService = $injector.get 'contentService'

  describe 'when initialised', ->
    it 'should be defined', ->
      expect(@contentService).toBeDefined()